// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/event/presentation/controller/event_details_controller.dart';
import 'package:alerthub/common_libs.dart';

class EventsVoteBar extends StatefulWidget {
  const EventsVoteBar({
    super.key,
  });

  @override
  State<EventsVoteBar> createState() => _EventsVoteBarState();
}

class _EventsVoteBarState extends State<EventsVoteBar> {
  final commentController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool? isAccurate;

  uploadVote() {
    FocusScope.of(context).unfocus();
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return Future.error(context.localization?.kindlyFillAllFields ?? '');
    }
    if (isLoading) {
      return Future.error(context.localization?.kindlyWait ?? '');
    }

    if (isAccurate == null) {
      context
          .showErrorSnackBar(context.localization?.selectEventAccuracy ?? '');
      return;
    }
    formKey.currentState?.save();
    showVotingStatus();
  }

  Future showVotingStatus() async {
    setState(() {
      isLoading = true;
    });

    try {
      final comment = commentController.text.trim();
      final controller = Get.find<EventDetailsController>();
      await controller.voteEvent(isAccurate!, comment);
      context.showSuccessSnackBar(context.localization?.voteSaved ?? '');
      context.router.maybePop(true);
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          top: space12,
          right: space12,
          left: space12,
          bottom: space12 + context.bottom),
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
        buildTitle().fadeInAndMoveFromBottom(),
        verticalSpacer12,
        buildEventAccurateItem().fadeInAndMoveFromBottom(),
        verticalSpacer12,
        buildEventInaccurateItem().fadeInAndMoveFromBottom(),
        verticalSpacer24,
        buildReasonField(),
        verticalSpacer24,
        AppBtn.from(
          isLoading: isLoading,
          onPressed: () => uploadVote(),
          text: context.localization?.vote ?? '',
        )
      ],
    );
  }

  Form buildReasonField() {
    return Form(
      key: formKey,
      child: TextFormField(
        textInputAction: TextInputAction.newline,
        decoration: context.inputDecoration(
            hintText: context.localization?.reasonForChoice ?? ''),
        keyboardType: TextInputType.multiline,
        maxLines: null,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return context.localization?.provideReasonForChoice ?? '';
          }
          return null;
        },
        controller: commentController,
      ).fadeInAndMoveFromBottom(),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.localization?.eventValidity ?? '',
                style: satoshi600S14),
            verticalSpacer12,
            context.divider,
            verticalSpacer12,
            Text(
              context.localization?.castVoteInstruction ?? '',
              style: satoshi500S12,
            )
          ],
        ));
  }

  InkWell buildEventInaccurateItem() {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          isAccurate = false;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: space12),
        decoration: BoxDecoration(
          color: destructive100.withOpacity(.4),
          borderRadius: BorderRadius.circular(space4),
          border: Border.all(color: destructive300),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.thumb_down_rounded,
              color: destructive700,
            ),
            horizontalSpacer8,
            Expanded(
              child: Text(
                context.localization?.eventInaccurate ?? '',
                style: satoshi500S14.copyWith(color: destructive700),
              ),
            ),
            IgnorePointer(
              ignoring: true,
              child: SimpleRadioButton(
                active: isAccurate == false,
                onToggled: (_) {},
                color: destructive700,
                isExpanded: false,
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell buildEventAccurateItem() {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          isAccurate = true;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: space12),
        decoration: BoxDecoration(
          color: primary100.withOpacity(.4),
          borderRadius: BorderRadius.circular(space4),
          border: Border.all(color: primary400),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.thumb_up_rounded,
              color: primary800,
            ),
            horizontalSpacer8,
            Expanded(
              child: Text(
                context.localization?.eventAccurate ?? '',
                style: satoshi500S14.copyWith(color: primary800),
              ),
            ),
            IgnorePointer(
              ignoring: true,
              child: SimpleRadioButton(
                active: isAccurate == true,
                onToggled: (_) {},
                isExpanded: false,
                color: primary800,
              ),
            )
          ],
        ),
      ),
    );
  }
}
