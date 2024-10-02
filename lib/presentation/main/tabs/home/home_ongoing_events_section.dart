import 'package:alerthub/common_libs.dart';
import 'package:alerthub/models/event/event.dart';
import 'package:alerthub/presentation/event/event_item.dart';

class HomeOngoingEventsSection extends StatelessWidget {
  const HomeOngoingEventsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTitle(context).fadeInAndMoveFromBottom(),
        verticalSpacer12,
        GetX<HomeController>(
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
              'Ongoing Events',
              style: satoshi600S12,
            ),
          ),
          horizontalSpacer12,
          AppBtn.basic(
            onPressed: () => context.router.push(const OngoingEventsRoute()),
            child: Text(
              'See all',
              style: satoshi500S12,
            ),
          )
        ],
      ),
    );
  }
}
