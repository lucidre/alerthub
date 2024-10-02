// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart';
import 'package:alerthub/models/event/event.dart';
import 'package:alerthub/presentation/event/event_item.dart';

@RoutePage()
class OngoingEventsScreen extends StatefulWidget {
  const OngoingEventsScreen({super.key});

  @override
  State<OngoingEventsScreen> createState() => _OngoingEventsScreenState();
}

class _OngoingEventsScreenState extends State<OngoingEventsScreen> {
  final progressStream = StreamController<bool>();
  final scrollController = ScrollController();
  final refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getData();
      progressStream.add(false);

      scrollController.addListener(() {
        if (scrollController.position.pixels >
            scrollController.position.maxScrollExtent - 10) {
          final controller = Get.find<HomeController>();
          controller.getOngoingOldData(progressStream);
        }
      });
    });
  }

  getData() async {
    try {
      final controller = Get.find<HomeController>();
      await controller.getOngoingData();
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
  }

  void onRefresh() async {
    try {
      final controller = Get.find<HomeController>();
      await controller.getOngoingData();
      refreshController.refreshCompleted();
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
      refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(space12),
        child: Column(
          children: [
            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                header:
                    const ClassicHeader(refreshStyle: RefreshStyle.UnFollow),
                onRefresh: () => onRefresh(),
                controller: refreshController,
                child: GetX<HomeController>(
                  builder: (controller) {
                    final isLoading = controller.ongoingIsLoading;
                    final hasError = controller.ongoingHasError;
                    final events = controller.ongoingEvents;
                    return isLoading
                        ? buildLoadingBody()
                        : hasError
                            ? context.buildErrorWidget(onRetry: () => getData())
                            : events.isEmpty
                                ? context.buildNoDataWidget()
                                : buildBody(events);
                  },
                ),
              ),
            ),
            AppFetchingProgressBar(stream: progressStream.stream),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text('Ongoing Events', style: satoshi600S24).fadeIn(),
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

  ListView buildBody(List<Event> events) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(0),
      itemBuilder: (ctx, index) {
        final event = events[index];
        return EventItem(
          event: event,
          shimmerEnabled: false,
          onPressed: () => context.router.push(EventDetailsRoute(event: event)),
        );
      },
      physics: const BouncingScrollPhysics(),
      itemCount: events.length,
    );
  }
}
