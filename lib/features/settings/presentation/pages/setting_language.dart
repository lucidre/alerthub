import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/settings/presentation/controller/setting_language_controller.dart';
import 'package:alerthub/features/settings/presentation/widget/settings_language_item.dart';
import 'package:alerthub/shared/models/locale/locale.dart';

@RoutePage()
class SettingLaunguageScreen extends StatefulWidget {
  const SettingLaunguageScreen({super.key});

  @override
  State<SettingLaunguageScreen> createState() => _LaunguageScreenState();
}

class _LaunguageScreenState extends State<SettingLaunguageScreen> {
  List<AppLocale> get appLocales => [
        AppLocale(
          rawName: "System Default",
          translatedName: '(${context.localization!.systemDefault})',
          locale: null,
        ),
        AppLocale(
          rawName: "English",
          translatedName: '(${context.localization!.english})',
          locale: const Locale('en'),
        ),
        AppLocale(
          rawName: "Spanish",
          translatedName: '(${context.localization!.spanish})',
          locale: const Locale('es'),
        ),
        AppLocale(
          rawName: "French",
          translatedName: '(${context.localization!.french})',
          locale: const Locale('fr'),
        ),
        AppLocale(
          rawName: "Chinese",
          translatedName: '(${context.localization!.chinese})',
          locale: const Locale('zh'),
        ),
      ];

  @override
  void initState() {
    super.initState();
    final controller = Get.put(SettingLangageController());
    final languageCode = Get.find<LocaleController>().languageCode;
    controller.selectedLanguageLocale = languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      enableInternetCheck: false,
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text(context.localization?.language ?? '', style: satoshi600S24)
          .fadeIn(),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(space12),
      child: Column(
        children: [
          Expanded(
            child: buildList(),
          ),
          verticalSpacer16,
          buildButton(),
          verticalSpacer16,
        ],
      ),
    );
  }

  GetX<SettingLangageController> buildList() {
    return GetX<SettingLangageController>(builder: (controller) {
      final selectedLanguageLocale = controller.selectedLanguageLocale;
      return ListView.builder(
        padding: const EdgeInsets.all(0),
        physics: const BouncingScrollPhysics(),
        itemCount: appLocales.length,
        itemBuilder: (ctx, index) {
          final appLocale = appLocales[index];

          return SettingsLanguageItem(
            appLocale: appLocale,
            isSeleted: selectedLanguageLocale == appLocale.locale?.languageCode,
            onPressed: () {
              controller.selectedLanguageLocale =
                  appLocale.locale?.languageCode;
            },
          ).fadeInAndMoveFromBottom();
        },
      );
    });
  }

  AppBtn buildButton() {
    return AppBtn.from(
      onPressed: () {
        final controller = Get.find<SettingLangageController>();
        Get.find<LocaleController>()
            .updateCurrentLocale(controller.selectedLanguageLocale);

        context.router.maybePop();
      },
      isSecondary: context.$isDarkMode,
      expand: true,
      text: context.localization?.update ?? '',
    );
  }
}
