import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/features/event/presentation/controller/events_home_tab_controller.dart';
import 'package:alerthub/features/event/presentation/widget/event_item2.dart';
import 'package:alerthub/common_libs.dart';

class EventsNearbyHomeItem extends StatelessWidget {
  const EventsNearbyHomeItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTitle(context).fadeInAndMoveFromBottom(),
        verticalSpacer12,
        GetX<EventsHomeTabController>(
          builder: (controller) {
            final isLoading = controller.nearbyIsLoading;
            final hasError = controller.nearbyHasError;
            final events = controller.nearbyEvents;
            return isLoading
                ? buildLoadingBody()
                : hasError
                    ? Container(
                        padding: const EdgeInsets.all(space12),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(space4),
                          border: Border.all(color: neutral200),
                        ),
                        alignment: Alignment.center,
                        child: context.buildErrorWidget(
                          isMini: true,
                          onRetry: () => controller.getNearbyData(),
                        ),
                      )
                    : events.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(space12),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(space4),
                              border: Border.all(color: neutral200),
                            ),
                            alignment: Alignment.center,
                            child: context.buildNoDataWidget(
                                isMini: true,
                                title: context.localization?.noEvents ?? '',
                                body:
                                    context.localization?.noEventsNearby ?? ''),
                          )
                        : buildBody(context, events);
          },
        ),
      ],
    );
  }

  buildLoadingBody() {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(0),
        itemBuilder: (ctx, index) {
          return EventItem2(
            event: const Event(),
            shimmerEnabled: true,
            onPressed: () {},
          );
        },
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
      ),
    );
  }

  buildBody(BuildContext context, List<Event> events) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(0),
        itemBuilder: (ctx, index) {
          final event = events[index];
          return EventItem2(
            event: event,
            shimmerEnabled: false,
            onPressed: () =>
                context.router.push(EventDetailsRoute(event: event)),
          );
        },
        physics: const BouncingScrollPhysics(),
        itemCount: events.length,
      ),
    );
  }

  Container buildTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.localization?.nearbyEvents ?? '',
              style: satoshi600S12,
            ),
          ),
          horizontalSpacer12,
          AppBtn.basic(
            onPressed: () => context.router.push(const EventsNearbyRoute()),
            child: Text(
              context.localization?.seeAll ?? '',
              style: satoshi500S12,
            ),
          )
        ],
      ),
    );
  }
}
