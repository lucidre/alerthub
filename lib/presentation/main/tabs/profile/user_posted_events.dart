import 'package:alerthub/common_libs.dart';

import 'package:alerthub/models/event/event.dart';
import 'package:alerthub/presentation/event/event_item.dart';
import 'package:flutter/cupertino.dart';

class UserPostedEvents extends StatefulWidget {
  const UserPostedEvents({super.key});
  @override
  State<UserPostedEvents> createState() => _UserPostedEventsState();
}

class _UserPostedEventsState extends State<UserPostedEvents> {
  final scrollController = ScrollController();
  final progressStream = StreamController<bool>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      progressStream.add(false);

      scrollController.addListener(() {
        if (scrollController.position.pixels <=
            scrollController.position.maxScrollExtent - 10) {
          return;
        }
        Get.find<ProfileController>().getUpOldData(progressStream);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () => Get.find<ProfileController>().getUpData(),
      child: Column(
        children: [
          buildTitle().fadeInAndMoveFromBottom(),
          verticalSpacer12,
          Expanded(
            child: GetX<ProfileController>(
              builder: (controller) {
                if (controller.upIsLoading) {
                  return buildLoadingBody();
                } else {
                  return controller.upEvents.isEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(space4),
                            border: Border.all(color: neutral200),
                          ),
                          child: context.buildNoDataWidget(
                            title: 'No Events',
                            body: 'You have not created any events.',
                          ),
                        )
                      : buildList(controller.upEvents);
                }
              },
            ),
          ),
          verticalSpacer12,
          AppFetchingProgressBar(stream: progressStream.stream),
        ],
      ),
    );
  }

  Container buildTitle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: Row(
        children: [
          Text(
            'Your Posted Events',
            style: satoshi600S12,
          ),
          const Spacer(),
          AppBtn.basic(
            onPressed: () => context.router.push(const CreateEventRoute()),
            child: const Icon(
              CupertinoIcons.create,
              color: blackColor,
            ),
          )
        ],
      ),
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
}
