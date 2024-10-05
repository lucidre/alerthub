import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/features/event/presentation/widget/event_item.dart';
import 'package:alerthub/features/user/presentation/controller/user_tab_controller.dart';
import 'package:alerthub/common_libs.dart';

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
        Get.find<UserTabController>().getUpOldData(progressStream);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () => Get.find<UserTabController>().getUpData(),
      child: Column(
        children: [
          buildTitle().fadeInAndMoveFromBottom(),
          verticalSpacer12,
          Expanded(
            child: GetX<UserTabController>(
              builder: (controller) {
                if (controller.upeIsLoading) {
                  return buildLoadingBody();
                } else {
                  return controller.upeEvents.isEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(space4),
                            border: Border.all(color: neutral200),
                          ),
                          child: context.buildNoDataWidget(
                            title: context.localization?.noEvents ?? '',
                            body:
                                context.localization?.youHaveNotCreatedEvent ??
                                    '',
                          ),
                        )
                      : buildList(controller.upeEvents);
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
            context.localization?.yourPostedEvents ?? '',
            style: satoshi600S12,
          ),
          const Spacer(),
          AppBtn.basic(
              onPressed: () => context.router.push(CreateEventRoute()),
              child: Row(
                children: [
                  Text(
                    context.localization?.addEvent ?? '',
                    style: satoshi600S12,
                  ),
                  horizontalSpacer4,
                  const Icon(
                    CupertinoIcons.add_circled_solid,
                    color: blackColor,
                  ),
                ],
              ))
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
