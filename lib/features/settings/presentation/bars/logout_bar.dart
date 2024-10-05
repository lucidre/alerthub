// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoutBar extends StatefulWidget {
  const LogoutBar({super.key});

  @override
  State<LogoutBar> createState() => _LogoutBarState();
}

class _LogoutBarState extends State<LogoutBar> {
  bool isLoading = false;

  logOut() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signOut();
      Get.find<UserProfileController>().deleteUserData();
      context.router.pushAndPopUntil(
        const SplashRoute(),
        predicate: (_) => false,
      );
    } catch (_) {
      context.showErrorSnackBar(context.localization?.errorLoggingOut ?? '');
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
        buildLottie(),
        Text(
          context.localization?.logoutFromDevice ?? '',
          style: satoshi600S14,
        ).fadeInAndMoveFromBottom(),
        verticalSpacer8,
        Text(
          context.localization?.clearStoredData ?? '',
          style: satoshi500S12,
        ).fadeInAndMoveFromBottom(),
        verticalSpacer24,
        AppBtn.from(
          onPressed: () => logOut(),
          text: context.localization?.yes ?? '',
          isLoading: isLoading,
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
      logoutLottie,
      animate: true,
      repeat: true,
      reverse: true,
      width: 250,
      height: 250,
      fit: BoxFit.contain,
    );
  }
}
