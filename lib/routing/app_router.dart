import 'package:auto_route/auto_route.dart';
import 'app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Screen,Route',
)
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: OnboardingRoute.page),
        AutoRoute(page: UserSignInRoute.page),
        AutoRoute(page: UserSignUpRoute.page),
        AutoRoute(page: UserForgotPasswordRoute.page),
        AutoRoute(page: AppMainRoute.page),
        AutoRoute(page: CreateEventRoute.page),
        AutoRoute(page: EventSearchRoute.page),
        AutoRoute(page: SettingsRoute.page),
        AutoRoute(page: UserEditProfileRoute.page),
        AutoRoute(page: EventDetailsRoute.page),
        AutoRoute(page: EventsOngoingRoute.page),
        AutoRoute(page: EventsNearbyRoute.page),
        AutoRoute(page: EventAddressPickerRoute.page),
        AutoRoute(page: ViewImageRoute.page),
        AutoRoute(page: NotificationsRoute.page),
        AutoRoute(page: EventDetailsMapRoute.page),
        AutoRoute(page: SettingLaunguageRoute.page),
      ];
}
