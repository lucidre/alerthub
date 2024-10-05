import 'package:alerthub/common_libs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension Localization on BuildContext {
  AppLocalizations? get localization => AppLocalizations.of(this);
}
