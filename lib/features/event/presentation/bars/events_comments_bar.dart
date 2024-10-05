// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/event/presentation/controller/event_details_controller.dart';
import 'package:alerthub/common_libs.dart';

class EventCommentsBar extends StatefulWidget {
  const EventCommentsBar({
    super.key,
  });

  @override
  State<EventCommentsBar> createState() => _EventCommentsBarState();
}

class _EventCommentsBarState extends State<EventCommentsBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(space12),
          topRight: Radius.circular(space12),
        ),
      ),
      child: buildBody(),
    );
  }

  buildBody() {
    return Column(
      children: [
        buildTitle().fadeInAndMoveFromBottom(),
        verticalSpacer12,
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(space12),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(space4),
              border: Border.all(color: neutral200),
            ),
            child: buildList(),
          ),
        )
      ],
    );
  }

  Widget buildList() {
    return GetX<EventDetailsController>(builder: (controller) {
      final comments = controller.event?.comments ?? [];
      return ListView.separated(
        padding: const EdgeInsets.all(0),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (ctx, index) {
          final comment = comments[index];
          return Padding(
            padding: const EdgeInsets.all(space12),
            child: Row(
              children: [
                Text(
                  comment,
                  style: satoshi500S12,
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => context.divider,
        itemCount: comments.length,
      );
    });
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
      child:
          Text(context.localization?.eventComments ?? '', style: satoshi600S14),
    );
  }
}
