import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/event/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/features/event/data/repositorites/event_repository_impl.dart';
import 'package:alerthub/features/event/domain/usecases/event_service.dart';
import 'package:alerthub/features/event/presentation/controller/user_posted_events.dart';
import 'package:alerthub/features/event/presentation/widget/event_item.dart';

@RoutePage()
class UserPostedEventsScreen extends StatefulWidget {
  const UserPostedEventsScreen({super.key});

  @override
  State<UserPostedEventsScreen> createState() => _UserPostedEventsScreenState();
}

class _UserPostedEventsScreenState extends State<UserPostedEventsScreen> {
  final refreshController = RefreshController(initialRefresh: false);
  final scrollController = ScrollController();
  final progressStream = StreamController<bool>();
  final tag = UniqueKey().toString();

  @override
  void initState() {
    super.initState();
    Get.put(
      UserPostedEventsController(
        EventService(
          EventRepositoryImpl(
            EventRemoteDataSource(),
          ),
        ),
      ),
      tag: tag,
    );

    Future.delayed(Duration.zero, () {
      progressStream.add(false);

      scrollController.addListener(() {
        if (scrollController.position.pixels <=
            scrollController.position.maxScrollExtent - 10) {
          return;
        }
        Get.find<UserPostedEventsController>(tag: tag)
            .getUpOldData(progressStream);
      });
    });
  }

  getData() async {
    try {
      final controller = Get.find<UserPostedEventsController>(tag: tag);
      await controller.getUpData();
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
  }

  void onRefresh() async {
    final controller = Get.find<UserPostedEventsController>(tag: tag);
    await controller.getUpData();
    refreshController.refreshCompleted();
  }

  buildFloatingActinoButton() {
    return FloatingActionButton(
      onPressed: () => context.router.push(CreateEventRoute()),
      backgroundColor: blackShade1Color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(space4),
      ),
      child: const Icon(Icons.add_rounded),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: buildAppBar(),
      floatingActionButton: buildFloatingActinoButton(),
      body: FocusDetector(
        onFocusGained: () => getData(),
        child: SmartRefresher(
          enablePullDown: true,
          header: const ClassicHeader(refreshStyle: RefreshStyle.UnFollow),
          onRefresh: () => onRefresh(),
          controller: refreshController,
          child: Padding(
            padding: const EdgeInsets.all(space12),
            child: buildBody(),
          ),
        ),
      ),
    );
  }

  Column buildBody() {
    return Column(
      children: [
        Expanded(
          child: GetX<UserPostedEventsController>(
            tag: tag,
            builder: (controller) {
              if (controller.upeIsLoading) {
                return buildLoadingBody();
              } else if (controller.upeHasError) {
                return Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(space4),
                    border: Border.all(color: neutral200),
                  ),
                  child: context.buildErrorWidget(onRetry: () => getData()),
                );
              } else if (controller.upeEvents.isEmpty) {
                return Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(space4),
                    border: Border.all(color: neutral200),
                  ),
                  child: context.buildNoDataWidget(
                    title: context.localization?.noEvents ?? '',
                    body: context.localization?.youHaveNotCreatedEvent ?? '',
                  ),
                );
              } else {
                return buildList(controller.upeEvents);
              }
            },
          ),
        ),
        verticalSpacer12,
        AppFetchingProgressBar(stream: progressStream.stream),
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

  buildList(List<Event> events) {
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

  buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      title: Text('Posted events', style: satoshi600S24).fadeIn(),
      centerTitle: false,
      backgroundColor: context.backgroundColor,
    );
  }
}
