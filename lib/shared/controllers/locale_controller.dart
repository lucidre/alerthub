import 'package:alerthub/app_preferences.dart';
import 'package:alerthub/common_libs.dart';

class LocaleController extends GetxController {
  final Rx<String> _localeCode = AppPreferences.defaultLanguageCode.obs;

  updateCurrentLocale(String? languageCode) async {
    final code = languageCode ?? AppPreferences.defaultLanguageCode;
    await AppPreferences.setLanguageCode(localeLanguageCode: code);
    _localeCode(code);
  }

  String? get languageCode =>
      _localeCode.value == AppPreferences.defaultLanguageCode
          ? null
          : _localeCode.value;
}
