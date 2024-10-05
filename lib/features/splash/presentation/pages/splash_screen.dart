// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/app_preferences.dart';
import 'package:alerthub/features/splash/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/splash/data/repositorites/splash_repository_impl.dart';
import 'package:alerthub/features/splash/domain/usecases/splash_service.dart';
import 'package:alerthub/features/splash/presentation/controller/splash_controller.dart';
import 'package:alerthub/common_libs.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    final splashController = Get.put(SplashController(
      SplashService(
        SplashRepositoryImpl(
          SplashRemoteDataSource(),
        ),
      ),
    ));
    splashController.wakeUpServer();

    final userController = Get.find<UserProfileController>();
    userController.initUserData();

    final localizationController = Get.find<LocaleController>();
    localizationController
        .updateCurrentLocale(AppPreferences.getSavedLocalization());

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
    if (FirebaseAuth.instance.currentUser != null) {
      context.router.replace(const AppMainRoute());
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
          buildDecore(),
          buildDecore2(),
          buildTextField(),
        ],
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

  Positioned buildDecore2() {
    return Positioned(
      bottom: -30,
      left: -30,
      child: Opacity(
        opacity: .03,
        child: Transform.flip(
          flipY: true,
          flipX: true,
          child: Image.asset(
            decore,
            height: context.height * .4,
            width: context.height * .4,
          ),
        ),
      ).fadeInAndMoveFromBottom(),
    );
  }

  Container buildBackgroundColor() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: gradientColors,
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
        context.localization?.alertHub ?? '',
        style: satoshi700S32.copyWith(
          color: shadeWhite,
          fontSize: 35,
        ),
      ),
    ));
  }
}
