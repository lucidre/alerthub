import 'package:alerthub/common_libs.dart';
import 'package:alerthub/models/event/event.dart';
import 'package:alerthub/presentation/event/event_item2.dart';

class HomeNearBySection extends StatelessWidget {
  const HomeNearBySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTitle(context).fadeInAndMoveFromBottom(),
        verticalSpacer12,
        GetX<HomeController>(
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
                              title: 'No Events',
                              body:
                                  'There are no events happening within 500 meters of your current location.',
                            ),
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
              'Events Near You',
              style: satoshi600S12,
            ),
          ),
          horizontalSpacer12,
          AppBtn.basic(
            onPressed: () => context.router.push(const NearbyEventsRoute()),
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
