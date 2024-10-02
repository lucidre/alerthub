// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/api/firebase_util.dart';
import 'package:alerthub/common_libs.dart';

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
      await $firebaseUtil.sAuth.signOut();
      Get.find<HomeController>().deleteUserData();
      context.router.pushAndPopUntil(
        const SplashRoute(),
        predicate: (_) => false,
      );
    } catch (_) {
      context.showErrorSnackBar('An error occurred while logging you out.');
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
          'Logout',
          style: satoshi600S14,
        ).fadeInAndMoveFromBottom(),
        verticalSpacer8,
        Text(
          'Are you sure you want to logout from this device?',
          style: satoshi500S12,
        ).fadeInAndMoveFromBottom(),
        verticalSpacer24,
        AppBtn.from(
          onPressed: () => logOut(),
          text: 'Yes',
          isLoading: isLoading,
        ),
        verticalSpacer12,
        AppBtn.from(
          onPressed: () => context.router.maybePop(),
          text: 'Cancel',
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
