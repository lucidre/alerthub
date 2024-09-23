// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/api/firebase_util.dart';
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/models/event/event.dart';
import 'package:alerthub/presentation/event/event_item.dart';
import 'package:flutter/cupertino.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  final String search;
  const SearchScreen({
    super.key,
    required this.search,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  final List<EventModel> events = [];

  bool isLoading = true;
  bool hasError = false;
  bool allDataLoaded = false;
  bool oldDataLoading = false;
  bool isRefreshing = false;

  final progressStream = StreamController<bool>();
  final scrollController = ScrollController();
  final refreshController = RefreshController(initialRefresh: false);

  void onRefresh() async {
    setState(() {
      isRefreshing = true;
    });
    await getData();
    setState(() {
      isRefreshing = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      searchController.text = widget.search;
      getData();
      progressStream.add(false);

      scrollController.addListener(() {
        if (scrollController.position.pixels >
                scrollController.position.maxScrollExtent - 10 &&
            !isLoading &&
            !allDataLoaded &&
            !isRefreshing &&
            events.isNotEmpty &&
            !oldDataLoading) {
          getOldData();
        }
      });
    });
  }

  getData() async {
    isLoading = true;
    hasError = false;
    events.clear();
    setState(() {});

    try {
      final search = searchController.text.trim();
      final data = await $firebaseUtil.searchEvents(search);
      events.addAll(data);
      if (isRefreshing) {
        refreshController.refreshCompleted();
      }
    } catch (exception) {
      hasError = true;
      context.showErrorSnackBar(exception.toString());
      if (isRefreshing) {
        refreshController.refreshFailed();
      }
    }

    isLoading = false;
    setState(() {});
  }

  getOldData() async {
    oldDataLoading = true;
    progressStream.add(true);

    try {
      final data = await $firebaseUtil.searchEvents(
        searchController.text.trim(),
        events.last.createdAt,
      );
      allDataLoaded = data.isEmpty;
      events.addAll(data);
    } catch (exception) {
      allDataLoaded = true;
    }

    oldDataLoading = false;
    progressStream.add(false);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      enableInternetCheck: false,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Stack(
      children: [
        buildBackgroundColor(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.top),
            buildHeader().fadeInAndMoveFromBottom(),
            verticalSpacer12,
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(space4),
                    topRight: Radius.circular(space4),
                  ),
                ),
                padding: const EdgeInsets.all(space12),
                child: Column(
                  children: [
                    Expanded(
                      child: SmartRefresher(
                        enablePullDown: true,
                        header: const ClassicHeader(
                            refreshStyle: RefreshStyle.UnFollow),
                        onRefresh: () => onRefresh(),
                        controller: refreshController,
                        child: isLoading
                            ? buildLoadingBody()
                            : hasError
                                ? context.buildErrorWidget(
                                    onRetry: () => getData())
                                : searchController.text.trim().isEmpty
                                    ? context.buildNoDataWidget(
                                        title: 'No Parameter',
                                        body:
                                            'Kindly enter an event name or location to search.',
                                      )
                                    : events.isEmpty
                                        ? context.buildNoDataWidget()
                                        : buildList(),
                      ),
                    ),
                    AppFetchingProgressBar(stream: progressStream.stream),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  buildLoadingBody() {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemBuilder: (ctx, index) {
        return EventItem(
          event: EventModel(),
          shimmerEnabled: true,
          onPressed: () {},
        );
      },
      physics: const BouncingScrollPhysics(),
      itemCount: 10,
    );
  }

//TODO On refesh being called on list drag.
  Widget buildList() {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(0),
      itemBuilder: (ctx, index) {
        final event = events[index];
        return EventItem(
          event: event,
          shimmerEnabled: false,
          onPressed: () => context.router.push(
            EventDetailsRoute(event: event),
          ),
        );
      },
      physics: const BouncingScrollPhysics(),
      itemCount: events.length,
    );
  }

  Padding buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: space12, right: space12),
      child: Row(
        children: [
          buildBackButton().fadeInAndMoveFromBottom(),
          horizontalSpacer12,
          Expanded(child: buildSearchField().fadeInAndMoveFromBottom()),
          horizontalSpacer12,
          buildFilterButton().fadeInAndMoveFromBottom(),
        ],
      ),
    );
  }

  Container buildFilterButton() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border.all(color: neutral300),
        borderRadius: BorderRadius.circular(space4),
      ),
      child: const Icon(
        CupertinoIcons.slider_horizontal_3,
        color: blackColor,
      ),
    );
  }

  GestureDetector buildBackButton() {
    return GestureDetector(
      onTap: () => context.router.maybePop(),
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: whiteColor,
          border: Border.all(
            color: neutral300,
          ),
          borderRadius: BorderRadius.circular(space4),
        ),
        child: const Icon(
          CupertinoIcons.chevron_back,
          color: blackColor,
        ),
      ),
    );
  }

  TextFormField buildSearchField() {
    return TextFormField(
      textInputAction: TextInputAction.search,
      decoration: context.inputDecoration(
        hintText: "Search event name or location",
        fillColor: whiteColor,
        borderSide: const BorderSide(color: neutral300),
      ),
      keyboardType: TextInputType.name,
      onFieldSubmitted: (_) => getData(),
      controller: searchController,
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: null,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
    );
  }

  Container buildBackgroundColor() {
    return Container(
      width: double.infinity,
      height: context.screenHeight * .6,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFF333333),
            Color(0xFF2C2929),
          ],
        ),
      ),
    );
  }
}
