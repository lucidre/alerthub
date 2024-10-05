import 'package:alerthub/app_preferences.dart';
import 'package:alerthub/features/user/data/data_sources/remote_data_source.dart';
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/user/data/model/user_data/user.dart';

class UserProfileController extends GetxController {
  final Rxn<User> _user = Rxn();

  User? get user => _user.value;

  deleteUserData() {
    _user.value = null;
    AppPreferences.logOutUser();
  }

  initUserData() {
    final user = AppPreferences.userData;
    if (user != null) {
      _user(user);
    }
  }

  getUser() async {
    try {
      final data = await UserRemoteDataSource().getUser();
      final user = data.data;
      if (user != null) {
        AppPreferences.setUserData(user: user);
        _user(user);
      }
    } catch (_) {}
  }
}
