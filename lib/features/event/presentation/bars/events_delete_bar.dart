// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/event/presentation/controller/event_details_controller.dart';
import 'package:alerthub/common_libs.dart';

class EventsDeleteBar extends StatefulWidget {
  const EventsDeleteBar({super.key});

  @override
  State<EventsDeleteBar> createState() => _EventsDeleteBarState();
}

class _EventsDeleteBarState extends State<EventsDeleteBar> {
  bool isLoading = false;

  void saveForm() async {
    setState(() {
      isLoading = true;
    });

    try {
      final controller = Get.find<EventDetailsController>();
      await controller.deleteEvent();
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
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(space4),
        color: context.backgroundColor,
      ),
      child: Container(
        padding: const EdgeInsets.all(space12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(space4),
          color: whiteColor,
        ),
        child: buildBody(),
      ),
    );
  }

  Column buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildLottie().fadeInAndMoveFromBottom(),
        Text(
          context.localization?.deleteEvent ?? '',
          style: satoshi600S14,
        ),
        verticalSpacer8,
        Text(
          context.localization?.deleteEventDescription ?? '',
          style: satoshi500S14,
          textAlign: TextAlign.center,
        ).fadeInAndMoveFromBottom(),
        verticalSpacer24,
        AppBtn.from(
          isLoading: isLoading,
          onPressed: () => saveForm(),
          text: context.localization?.proceed ?? '',
        ),
        verticalSpacer12,
        AppBtn.from(
          onPressed: () => context.router.maybePop(),
          text: context.localization?.cancel ?? '',
          isOutlined: true,
        ),
      ],
    );
  }

  LottieBuilder buildLottie() {
    return Lottie.asset(
      deleteLottie,
      animate: true,
      repeat: true,
      reverse: true,
      width: 250,
      height: 250,
      fit: BoxFit.contain,
    );
  }
}
