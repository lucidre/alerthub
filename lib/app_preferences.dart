import 'package:alerthub/features/user/data/model/user_data/user.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alerthub/common_libs.dart';

/// DART CLASS TO SAVE DATA TO LOCAL STORAGE
class AppPreferences {
  static SharedPreferences? _preference;

  static Future init() async {
    return _preference = await SharedPreferences.getInstance();
  }

  static const _userLoginDataKey = "userDataKey";
  static const _hospitalLoginDataKey = "userDataKey";
  static const _userTypeKey = "userTypeKey";
  static const _languageCodeKey = 'localeLanguageCode';
  static const defaultLanguageCode = '---';

  static String? getSavedLocalization() {
    if (languageCode == defaultLanguageCode) {
      return null;
    } else {
      return languageCode;
    }
  }

  static String get languageCode =>
      _preference?.getString(_languageCodeKey) ?? defaultLanguageCode;

  static Future setLanguageCode({required String localeLanguageCode}) async {
    await _preference?.setString(_languageCodeKey, localeLanguageCode);
  }


  static String? get userType => _preference?.getString(_userTypeKey);

  static Future setUserType({required String type}) async {
    await _preference?.setString(_userTypeKey, type);
  }

  static Future setUserData({
    required User user,
  }) async {
    await _preference?.setString(_userLoginDataKey, user.toJson());
  }

  static Future setHospitalData({
    required Hospital hospital,
  }) async {
    await _preference?.setString(_hospitalLoginDataKey, hospital.toJson());
  }

  static Future logOutUser() async {
    await _preference?.setString(_userLoginDataKey, '');
    await _preference?.setString(_hospitalLoginDataKey, '');
  }

  static String get _userLoginData =>
      _preference?.getString(_userLoginDataKey) ?? '';

  static String get _hospitalLoginData =>
      _preference?.getString(_hospitalLoginDataKey) ?? '';

  static User? get userData =>
      _userLoginData.isEmpty ? null : User.fromJson(_userLoginData);

  static Hospital? get hospitalData =>
      _hospitalLoginData.isEmpty ? null : Hospital.fromJson(_hospitalLoginData);
}
