import 'package:alerthub/app_preferences.dart';
import 'package:alerthub/features/panic/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/panic/data/repositorites/panic_repository_impl.dart';
import 'package:alerthub/features/panic/domain/usecases/panic_service.dart';
import 'package:alerthub/features/panic/presentation/controller/panic_controller.dart';
import 'package:alerthub/shared/controllers/healthcare_bottom_bar_controller.dart';
import 'package:flutter/services.dart';
import 'package:alerthub/common_libs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:alerthub/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

initializeApplication() async {
  _initializeControlllers();
  await _initializeWindow();
  await _initializeSharedPreferences();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: "assets/.env");
}

_initializeControlllers() {
  Get.put(UserProfileController(), permanent: true);
  Get.put(UserBottomBarController(), permanent: true);
  Get.put(HealthCareBottomBarController(), permanent: true);
  Get.put(RouterController(), permanent: true);
  Get.put(LocationController(), permanent: true);
  Get.put(ConnectionStatusController(), permanent: true);
  Get.put(LocaleController(), permanent: true);
  Get.put(
      PanicController(
        PanicService(
          PanicRepositoryImpl(
            PanicRemoteDataSource(),
          ),
        ),
      ),
      permanent: true);
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
