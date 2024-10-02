// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart';
import 'package:alerthub/api/firebase_util.dart';

class AccountDeleteBar extends StatefulWidget {
  const AccountDeleteBar({super.key});

  @override
  State<AccountDeleteBar> createState() => _AccountDeleteBarState();
}

class _AccountDeleteBarState extends State<AccountDeleteBar> {
  bool isLoading = false;

  void saveForm() async {
    setState(() {
      isLoading = true;
    });

    try {
      await $firebaseUtil.sAuth.signOut();
      context.router.pushAndPopUntil(
        const SplashRoute(),
        predicate: (_) => false,
      );
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
          'Delete Account',
          style: satoshi600S14,
        ),
        verticalSpacer8,
        Text(
          'We’re sad to see you leave. Keep in mind that this action will result in the deletion of all your data.',
          style: satoshi500S14,
          textAlign: TextAlign.center,
        ).fadeInAndMoveFromBottom(),
        verticalSpacer24,
        AppBtn.from(
          isLoading: isLoading,
          onPressed: () => saveForm(),
          text: 'Proceed',
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
