import 'package:alerthub/models/user_data/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alerthub/common_libs.dart';

/// DART CLASS TO SAVE DATA TO LOCAL STORAGE
class AppPreferences {
  static SharedPreferences? _preference;

  static Future init() async {
    return _preference = await SharedPreferences.getInstance();
  }

  static const _userLoginDataKey = "userDataKey";

  static Future setUserData({
    required User user,
  }) async {
    await _preference?.setString(_userLoginDataKey, user.toJson());
  }

  static Future logOutUser() async {
    await _preference?.setString(_userLoginDataKey, '');
  }

  static String get _userLoginData =>
      _preference?.getString(_userLoginDataKey) ?? '';

  static User? get userData =>
      _userLoginData.isEmpty ? null : User.fromJson(_userLoginData);
}
