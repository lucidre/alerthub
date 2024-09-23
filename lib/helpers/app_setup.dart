import 'package:flutter/services.dart';
import 'package:alerthub/common_libs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:alerthub/firebase_options.dart';

initializeApplication() async {
  _initializeControlllers();
  await _initializeWindow();
  await _initializeSharedPreferences();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

_initializeControlllers() {
  Get.put(RouterController(), permanent: true);
  Get.put(MapController(), permanent: true);
  Get.put(ConnectionStatusController(), permanent: true);
  Get.put(ProfileController(), permanent: true);
}

_initializeWindow() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

_initializeSharedPreferences() async {
  await AppPreferences.init();
}
