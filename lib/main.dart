import 'package:alerthub/app_setup.dart';
import 'package:alerthub/common_libs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  await initializeApplication();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = Get.find<RouterController>().router;
    return GetX<LocaleController>(builder: (controller) {
      final languageCode = controller.languageCode;
      return GetMaterialApp.router(
        routerDelegate: appRouter.delegate(),
        routeInformationParser: appRouter.defaultRouteParser(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: languageCode == null ? null : Locale(languageCode),
        localeResolutionCallback: (locale, supportedLocales) {
          if (supportedLocales.contains(locale)) {
            return locale;
          }
          return const Locale('en');
        },
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: context.lightTheme,
      );
    });
  }
}
