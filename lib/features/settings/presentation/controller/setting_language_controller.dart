import 'package:alerthub/common_libs.dart';

class SettingLangageController extends GetxController {
  final RxnString _selectedLanguageLocale = RxnString();

  String? get selectedLanguageLocale => _selectedLanguageLocale.value;
  set selectedLanguageLocale(String? value) =>
      _selectedLanguageLocale.value = value;
}
