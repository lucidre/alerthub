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
        AutoRoute(page: SignInRoute.page),
        AutoRoute(page: SignUpRoute.page),
        AutoRoute(page: ForgotPasswordRoute.page),
        AutoRoute(page: MainRoute.page),
        AutoRoute(page: CreateEventRoute.page),
        AutoRoute(page: AlertModeRoute.page),
        AutoRoute(page: SearchRoute.page),
        AutoRoute(page: SettingsRoute.page),
        AutoRoute(page: EditProfileRoute.page),
        AutoRoute(page: EventDetailsRoute.page),
        AutoRoute(page: MapViewRoute.page),
        AutoRoute(page: OngoingEventsRoute.page),
        AutoRoute(page: NearbyEventsRoute.page),
      ];
}
