// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/event/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/features/event/data/repositorites/event_repository_impl.dart';
import 'package:alerthub/features/event/domain/usecases/event_service.dart';
import 'package:alerthub/features/event/presentation/controller/events_search_controller.dart';
import 'package:alerthub/features/event/presentation/widget/event_item.dart';
import 'package:alerthub/common_libs.dart';

import 'package:flutter/cupertino.dart';

@RoutePage()
class EventSearchScreen extends StatefulWidget {
  final String search;
  const EventSearchScreen({
    super.key,
    required this.search,
  });

  @override
  State<EventSearchScreen> createState() => _EventSearchScreenState();
}

class _EventSearchScreenState extends State<EventSearchScreen> {
  final StreamController<bool> progressStream = StreamController<bool>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final controller = Get.put(
      EventsSearchController(
        EventService(
          EventRepositoryImpl(
            EventRemoteDataSource(),
          ),
        ),
      ),
    );

    Future.delayed(Duration.zero, () {
      controller.searchController.text = widget.search;
      getData();
      progressStream.add(false);

      scrollController.addListener(() {
        if (scrollController.position.pixels <
            scrollController.position.maxScrollExtent - 10) {
          return;
        }
        controller.getOldData(progressStream);
      });
    });
  }

  getData() async {
    try {
      final controller = Get.find<EventsSearchController>();
      await controller.getData();
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
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
            SizedBox(height: context.top + space12),
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
                      child:
                          GetX<EventsSearchController>(builder: (controller) {
                        final refreshController = controller.refreshController;
                        final isLoading = controller.isLoading;
                        final hasError = controller.hasError;
                        final searchController = controller.searchController;
                        final events = controller.events;
                        return SmartRefresher(
                          enablePullDown: true,
                          header: const ClassicHeader(
                              refreshStyle: RefreshStyle.UnFollow),
                          onRefresh: () => controller.onRefresh(),
                          controller: refreshController,
                          child: isLoading
                              ? buildLoadingBody()
                              : hasError
                                  ? context.buildErrorWidget(
                                      onRetry: () => getData())
                                  : searchController.text.trim().isEmpty
                                      ? context.buildNoDataWidget(
                                          title: context
                                                  .localization?.noParameter ??
                                              '',
                                          body: context.localization
                                                  ?.enterEventNameOrLocation ??
                                              '',
                                        )
                                      : events.isEmpty
                                          ? context.buildNoDataWidget()
                                          : buildList(events),
                        );
                      }),
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
          event: const Event(),
          shimmerEnabled: true,
          onPressed: () {},
        );
      },
      physics: const BouncingScrollPhysics(),
      itemCount: 10,
    );
  }

  Widget buildList(List<Event> events) {
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
        ],
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
    final controller = Get.find<EventsSearchController>();
    final searchController = controller.searchController;
    return TextFormField(
      textInputAction: TextInputAction.search,
      decoration: context.inputDecoration(
        hintText: context.localization?.searchEventNameOrLocation ?? '',
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
