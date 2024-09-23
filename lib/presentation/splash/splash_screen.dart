// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/api/firebase_util.dart';
import 'package:alerthub/common_libs.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? fadeAnimation;
  Animation<Offset>? slideAnimation;

  @override
  void initState() {
    super.initState();
    setUpAnimation();
  }

  void setUpAnimation() {
    controller = AnimationController(duration: slowDuration, vsync: this);
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller!,
        curve: Curves.easeIn,
      ),
    );
    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller!,
      curve: Curves.easeInOut,
    ));

    controller?.addListener(() {
      if (controller!.isCompleted) {
        startTime();
      }
    });

    const duration = Duration(seconds: 2);
    Timer(duration, () {
      controller?.forward();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void route() async {
    if ($firebaseUtil.sAuth.currentUser != null) {
      context.router.replace(const MainRoute());
    } else {
      context.router.replace(const OnboardingRoute());
    }
  }

  Future startTime() async {
    const duration = Duration(seconds: 2);
    return Timer(duration, route);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      enableInternetCheck: false,
      backgroundColor: blackColor,
      body: Stack(
        children: [
          buildBackgroundColor(),
          buildFlameImage(),
          buildTextField(),
        ],
      ),
    );
  }

  Positioned buildFlameImage() {
    return Positioned(
      right: -context.width * .8,
      bottom: -context.width * .8,
      child: Image.asset(
        "assets/images/flame.png",
        height: context.height * .9,
        width: context.height * .9,
        opacity: const AlwaysStoppedAnimation(0.6),
      ).fadeInAndMoveFromBottom(),
    );
  }

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

  buildTextField() {
    return Center(
        child: AnimatedBuilder(
      animation: controller!,
      builder: (_, child) {
        return Opacity(
          opacity: fadeAnimation?.value ?? 0.0,
          child: FractionalTranslation(
            translation: slideAnimation?.value ?? Offset.zero,
            child: child,
          ),
        );
      },
      child: Text(
        appName,
        style: satoshi700S32.copyWith(color: shadeWhite),
      ),
    ));
  }
}
