// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/event/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/event/data/repositorites/event_repository_impl.dart';
import 'package:alerthub/features/event/domain/usecases/event_service.dart';
import 'package:alerthub/features/event/presentation/controller/events_nearby_controller.dart';
import 'package:alerthub/features/event/presentation/widget/event_item.dart';
import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/common_libs.dart';

@RoutePage()
class EventsNearbyScreen extends StatefulWidget {
  const EventsNearbyScreen({super.key});

  @override
  State<EventsNearbyScreen> createState() => _EventsNearbyScreenState();
}

class _EventsNearbyScreenState extends State<EventsNearbyScreen> {
  final progressStream = StreamController<bool>();
  final scrollController = ScrollController();
  final refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    Get.put(EventsNearbyController(
      EventService(
        EventRepositoryImpl(
          EventRemoteDataSource(),
        ),
      ),
    ));

    Future.delayed(Duration.zero, () {
      getData();
      progressStream.add(false);

      scrollController.addListener(() {
        if (scrollController.position.pixels >
            scrollController.position.maxScrollExtent - 10) {
          final controller = Get.find<EventsNearbyController>();
          controller.getNearbyOldData(progressStream);
        }
      });
    });
  }

  getData() async {
    try {
      final controller = Get.find<EventsNearbyController>();
      await controller.getNearbyData();
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
  }

  void onRefresh() async {
    try {
      final controller = Get.find<EventsNearbyController>();
      await controller.getNearbyData();
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
                child: GetX<EventsNearbyController>(
                  builder: (controller) {
                    final isLoading = controller.nearbyIsLoading;
                    final hasError = controller.nearbyHasError;
                    final events = controller.nearbyEvents;
                    return isLoading
                        ? buildLoadingBody()
                        : hasError
                            ? context.buildErrorWidget(onRetry: () => getData())
                            : events.isEmpty
                                ? context.buildNoDataWidget(
                                    title: context.localization?.noEvents ?? '',
                                    body:
                                        context.localization?.noEventsNearby ??
                                            '',
                                  )
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
      title:
          Text(context.localization?.nearbyEvents ?? '', style: satoshi600S24)
              .fadeIn(),
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
