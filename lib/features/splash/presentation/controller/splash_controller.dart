import 'package:alerthub/features/splash/domain/usecases/splash_service.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final SplashService splashService;
  SplashController(this.splashService);

//This is needed because the free render service used to host the api shuts down if there are no activitites for a while.
  void wakeUpServer() async {
    try {
      await splashService.wakeup();
    } catch (_) {}
  }
}
