import 'dart:math';

import 'package:alerthub/common_libs.dart';

@RoutePage()
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Container buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: gradientColors,
        ),
      ),
    );
  }

  Positioned buildDecore() {
    return Positioned(
      top: -30,
      right: -30,
      child: Opacity(
        opacity: .03,
        child: Image.asset(
          decore,
          height: context.height * .4,
          width: context.height * .4,
        ),
      ).fadeInAndMoveFromTop(),
    );
  }

  Widget buildUpperWidget() {
    return Stack(
      children: [
        buildBackground(),
        buildDecore(),
        Center(
          child: buildLottie(),
        )
      ],
    );
  }

  LayoutBuilder buildLottie() {
    return LayoutBuilder(builder: (context, constraint) {
      final minSize = min(constraint.maxHeight, constraint.maxWidth);
      return Transform.scale(
        scale: 1.2,
        child: Lottie.asset(
          globeLottie,
          animate: true,
          repeat: true,
          reverse: true,
          width: minSize,
          height: minSize,
          fit: BoxFit.contain,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      enableInternetCheck: false,
      body: Column(
        children: [
          Expanded(child: buildUpperWidget()),
          buildContent(),
        ],
      ),
    );
  }

  Container buildContent() {
    return Container(
      width: double.infinity,
      color: whiteBrownColor,
      padding: const EdgeInsets.all(space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.localization?.welcomeToAlertHub ?? '',
              style: satoshi700S32),
          Text(context.localization?.latestEventInfo ?? '',
              style: satoshi500S12),
          verticalSpacer12,
          AppBtn.from(
            expand: true,
            onPressed: () => context.router.push(const UserSignUpRoute()),
            text: context.localization?.signUp ?? '',
          ),
          verticalSpacer12,
          AppBtn.from(
            expand: true,
            onPressed: () => context.router.push(const UserSignInRoute()),
            isSecondary: context.$isDarkMode,
            text: context.localization?.logIn ?? '',
            bgColor: shadeWhite,
            textColor: neutral800,
            border: const BorderSide(color: neutral300, width: 1),
          ),
          verticalSpacer24,
        ],
      ),
    );
  }
}
