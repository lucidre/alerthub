import 'package:alerthub/app_preferences.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart';
import 'package:alerthub/features/user/data/data_sources/remote_data_source.dart';
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/user/data/model/user_data/user.dart';

class UserProfileController extends GetxController {
  final Rxn<User> _user = Rxn();
  final Rxn<Hospital> _hospital = Rxn();

  User? get user => _user.value;
  Hospital? get hospital => _hospital.value;

  deleteUserData() {
    _user.value = null;
    _hospital.value = null;
    AppPreferences.logOutUser();
  }

  initUserData() {
    final user = AppPreferences.userData;
    final hospital = AppPreferences.hospitalData;
    if (user != null) {
      _user(user);
      _hospital(hospital);
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
  getHospital() async {
    try {
      final data = await UserRemoteDataSource().getHospital();
      final hospital = data.data;
      if (hospital != null) {
        AppPreferences.setHospitalData(hospital: hospital);
        _hospital(hospital);
      }
    } catch (_) {}
  }
}
