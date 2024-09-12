import 'package:shared_preferences/shared_preferences.dart';
import 'package:alerthub/common_libs.dart';

/// DART CLASS TO SAVE DATA TO LOCAL STORAGE
class AppPreferences {
  static SharedPreferences? _preference;

  static Future init() async {
    return _preference = await SharedPreferences.getInstance();
  }

/*   static const _userLoginDataKey = "userLoginDataKey";
  static const _shouldRemeberUserKey = "rememberUserKey";

  static Future setUserData({
    required UserModel user,
    required bool rememberUser,
  }) async {
    await _preference?.setString(_userLoginDataKey, user.toJson());
    await _preference?.setBool(_shouldRemeberUserKey, rememberUser);
  }

  static Future setRemeberUser(bool rememberUser) async {
    await _preference?.setBool(_shouldRemeberUserKey, rememberUser);
  }

  static Future logOutUser() async {
    await _preference?.setString(_userLoginDataKey, '');
    await _preference?.setBool(_shouldRemeberUserKey, false);
  }

  static String get _userLoginData =>
      _preference?.getString(_userLoginDataKey) ?? '';

  static bool get shouldRememberUser =>
      _preference?.getBool(_shouldRemeberUserKey) ?? false;

  static UserModel? get userData =>
      _userLoginData.isEmpty ? null : UserModel.fromJson(_userLoginData); */
}
