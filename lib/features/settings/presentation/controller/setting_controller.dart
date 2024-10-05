import 'package:alerthub/features/settings/domain/usecases/setting_service.dart';

import 'package:alerthub/common_libs.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingController extends GetxController {
  final SettingService settingService;
  SettingController(this.settingService);

  deleteUser() async {
    try {
      await settingService.deleteUser();
    } catch (exception) {
      return Future.error(exception);
    }
  }

  changePassword() async {
    try {
      await settingService.changePassword();
      await FirebaseAuth.instance.signOut();
    } catch (exception) {
      return Future.error(exception);
    }
  }
}
