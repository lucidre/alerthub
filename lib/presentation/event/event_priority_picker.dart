// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart';
import 'package:alerthub/models/event/event.dart';

class EventPriorityPicker extends StatefulWidget {
  final EventPriority? priority;
  const EventPriorityPicker({super.key, this.priority});

  @override
  State<EventPriorityPicker> createState() => _EventPriorityPickerState();
}

class _EventPriorityPickerState extends State<EventPriorityPicker> {
  EventPriority? selectedPriority;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        selectedPriority = widget.priority;
      });
    });
  }

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
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(space12),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(space4),
            border: Border.all(color: neutral200),
          ),
          child: Text(
            'Event Priority',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
        ),
        verticalSpacer12,
        ...EventPriority.values.map((e) => buildItem(e)),
        verticalSpacer12,
        AppBtn.from(
          onPressed: () {
            context.router.maybePop(selectedPriority);
          },
          text: 'Update',
        )
      ],
    );
  }

  Widget buildItem(EventPriority priority) {
    final isSelected = selectedPriority == priority;
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          selectedPriority = priority;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(space8),
        margin: const EdgeInsets.only(
          top: space6,
          bottom: space6,
        ),
        decoration: BoxDecoration(
          color: priority.backgroundColor.withOpacity(.5),
          borderRadius: BorderRadius.circular(space4),
          border: Border.all(color: priority.borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    priority.displayName,
                    style: satoshi600S14.copyWith(color: priority.textColor),
                  ),
                  Text(
                    priority.creatorDescription,
                    style: satoshi500S12.copyWith(color: priority.textColor),
                  ),
                ],
              ),
            ),
            IgnorePointer(
              ignoring: true,
              child: SimpleRadioButton(
                active: isSelected,
                color: priority.textColor,
                onToggled: (_) {},
                isExpanded: false,
              ),
            ),
          ],
        ),
      ).fadeInAndMoveFromBottom(),
    );
  }
}
