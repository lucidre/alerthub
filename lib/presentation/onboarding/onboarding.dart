import 'package:alerthub/common_libs.dart';

@RoutePage()
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Container buildBackgroundColor() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFF333333),
            Color(0xFF2C2929),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      enableInternetCheck: false,
      body: Column(
        children: [
          Expanded(
            child: buildBackgroundColor(),
          ),
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
          Text("Welcome to AlertHub", style: satoshi700S32),
          Text(
              'We are here to give you the best gas consumption automation. Our trusted registered gas retailers are always ready to serve you. Join us to know more.',
              style: satoshi500S12),
          verticalSpacer12,
          AppBtn.from(
            expand: true,
            onPressed: () {
              context.router.push(const SignUpRoute());
            },
            text: "Sign up",
          ),
          verticalSpacer12,
          AppBtn.from(
            expand: true,
            onPressed: () {
              context.router.push(const SignInRoute());
            },
            isSecondary: context.$isDarkMode,
            text: "Log in",
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
