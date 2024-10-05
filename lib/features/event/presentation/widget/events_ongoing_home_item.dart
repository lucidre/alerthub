import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/features/event/presentation/controller/events_home_tab_controller.dart';
import 'package:alerthub/features/event/presentation/widget/event_item.dart';
import 'package:alerthub/common_libs.dart';

class EventsOngoingHomeItem extends StatelessWidget {
  const EventsOngoingHomeItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTitle(context).fadeInAndMoveFromBottom(),
        verticalSpacer12,
        GetX<EventsHomeTabController>(
          builder: (controller) {
            final isLoading = controller.ongoingIsLoading;
            final hasError = controller.ongoingHasError;
            final events = controller.ongoingEvents;
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
                        child: context.buildErrorWidget(
                          isMini: true,
                          onRetry: () => controller.getOngoingData(),
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
                            child: context.buildNoDataWidget(isMini: true),
                          )
                        : buildBody(context, events);
          },
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
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 10,
    );
  }

  ListView buildBody(BuildContext context, List<Event> events) {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemBuilder: (ctx, index) {
        final event = events[index];
        return EventItem(
          event: event,
          shimmerEnabled: false,
          onPressed: () => context.router.push(EventDetailsRoute(event: event)),
        );
      },
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: events.length,
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
              context.localization?.ongoingEvents ?? '',
              style: satoshi600S12,
            ),
          ),
          horizontalSpacer12,
          AppBtn.basic(
            onPressed: () => context.router.push(const EventsOngoingRoute()),
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
