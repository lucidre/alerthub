import 'package:alerthub/common_libs.dart';
import 'package:alerthub/shared/models/locale/locale.dart';

class SettingsLanguageItem extends StatelessWidget {
  const SettingsLanguageItem({
    super.key,
    required this.appLocale,
    required this.isSeleted,
    required this.onPressed,
  });

  final AppLocale appLocale;
  final bool isSeleted;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => onPressed.call(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: space12),
        margin: const EdgeInsets.only(bottom: space12),
        decoration: BoxDecoration(
          border: Border.all(color: neutral200),
          color: shadeWhite,
          borderRadius: BorderRadius.circular(cornersSmall),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "${appLocale.rawName} ${appLocale.translatedName}",
                style: satoshi600S12,
              ),
            ),
            IgnorePointer(
              ignoring: true,
              child: SimpleRadioButton(
                active: isSeleted,
                onToggled: (_) {},
                isExpanded: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
