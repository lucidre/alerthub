// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:alerthub/common_libs.dart' as _i17;
import 'package:alerthub/models/event/event.dart' as _i18;
import 'package:alerthub/presentation/alert/alert_mode.dart' as _i1;
import 'package:alerthub/presentation/authentication/forgot_password.dart'
    as _i5;
import 'package:alerthub/presentation/authentication/sign_in.dart' as _i13;
import 'package:alerthub/presentation/authentication/sign_up.dart' as _i14;
import 'package:alerthub/presentation/event/create_event.dart' as _i2;
import 'package:alerthub/presentation/event/event_details.dart' as _i4;
import 'package:alerthub/presentation/event/mapview.dart' as _i7;
import 'package:alerthub/presentation/event/nearby_event.dart' as _i8;
import 'package:alerthub/presentation/event/ongoing_event.dart' as _i10;
import 'package:alerthub/presentation/main/main_screen.dart' as _i6;
import 'package:alerthub/presentation/onboarding/onboarding.dart' as _i9;
import 'package:alerthub/presentation/profile/edit_profile.dart' as _i3;
import 'package:alerthub/presentation/search/search_screen.dart' as _i11;
import 'package:alerthub/presentation/settings/settings.dart' as _i12;
import 'package:alerthub/presentation/splash/splash_screen.dart' as _i15;
import 'package:auto_route/auto_route.dart' as _i16;

/// generated route for
/// [_i1.AlertModeScreen]
class AlertModeRoute extends _i16.PageRouteInfo<void> {
  const AlertModeRoute({List<_i16.PageRouteInfo>? children})
      : super(
          AlertModeRoute.name,
          initialChildren: children,
        );

  static const String name = 'AlertModeRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i1.AlertModeScreen();
    },
  );
}

/// generated route for
/// [_i2.CreateEventScreen]
class CreateEventRoute extends _i16.PageRouteInfo<void> {
  const CreateEventRoute({List<_i16.PageRouteInfo>? children})
      : super(
          CreateEventRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateEventRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i2.CreateEventScreen();
    },
  );
}

/// generated route for
/// [_i3.EditProfileScreen]
class EditProfileRoute extends _i16.PageRouteInfo<void> {
  const EditProfileRoute({List<_i16.PageRouteInfo>? children})
      : super(
          EditProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'EditProfileRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i3.EditProfileScreen();
    },
  );
}

/// generated route for
/// [_i4.EventDetailsScreen]
class EventDetailsRoute extends _i16.PageRouteInfo<EventDetailsRouteArgs> {
  EventDetailsRoute({
    _i17.Key? key,
    required _i18.Event event,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          EventDetailsRoute.name,
          args: EventDetailsRouteArgs(
            key: key,
            event: event,
          ),
          initialChildren: children,
        );

  static const String name = 'EventDetailsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EventDetailsRouteArgs>();
      return _i4.EventDetailsScreen(
        key: args.key,
        event: args.event,
      );
    },
  );
}

class EventDetailsRouteArgs {
  const EventDetailsRouteArgs({
    this.key,
    required this.event,
  });

  final _i17.Key? key;

  final _i18.Event event;

  @override
  String toString() {
    return 'EventDetailsRouteArgs{key: $key, event: $event}';
  }
}

/// generated route for
/// [_i5.ForgotPasswordScreen]
class ForgotPasswordRoute extends _i16.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i16.PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i5.ForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [_i6.MainScreen]
class MainRoute extends _i16.PageRouteInfo<void> {
  const MainRoute({List<_i16.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i6.MainScreen();
    },
  );
}

/// generated route for
/// [_i7.MapViewScreen]
class MapViewRoute extends _i16.PageRouteInfo<void> {
  const MapViewRoute({List<_i16.PageRouteInfo>? children})
      : super(
          MapViewRoute.name,
          initialChildren: children,
        );

  static const String name = 'MapViewRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i7.MapViewScreen();
    },
  );
}

/// generated route for
/// [_i8.NearbyEventsScreen]
class NearbyEventsRoute extends _i16.PageRouteInfo<void> {
  const NearbyEventsRoute({List<_i16.PageRouteInfo>? children})
      : super(
          NearbyEventsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NearbyEventsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i8.NearbyEventsScreen();
    },
  );
}

/// generated route for
/// [_i9.OnboardingScreen]
class OnboardingRoute extends _i16.PageRouteInfo<void> {
  const OnboardingRoute({List<_i16.PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i9.OnboardingScreen();
    },
  );
}

/// generated route for
/// [_i10.OngoingEventsScreen]
class OngoingEventsRoute extends _i16.PageRouteInfo<void> {
  const OngoingEventsRoute({List<_i16.PageRouteInfo>? children})
      : super(
          OngoingEventsRoute.name,
          initialChildren: children,
        );

  static const String name = 'OngoingEventsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i10.OngoingEventsScreen();
    },
  );
}

/// generated route for
/// [_i11.SearchScreen]
class SearchRoute extends _i16.PageRouteInfo<SearchRouteArgs> {
  SearchRoute({
    _i17.Key? key,
    required String search,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          SearchRoute.name,
          args: SearchRouteArgs(
            key: key,
            search: search,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SearchRouteArgs>();
      return _i11.SearchScreen(
        key: args.key,
        search: args.search,
      );
    },
  );
}

class SearchRouteArgs {
  const SearchRouteArgs({
    this.key,
    required this.search,
  });

  final _i17.Key? key;

  final String search;

  @override
  String toString() {
    return 'SearchRouteArgs{key: $key, search: $search}';
  }
}

/// generated route for
/// [_i12.SettingsScreen]
class SettingsRoute extends _i16.PageRouteInfo<void> {
  const SettingsRoute({List<_i16.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i12.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i13.SignInScreen]
class SignInRoute extends _i16.PageRouteInfo<void> {
  const SignInRoute({List<_i16.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i13.SignInScreen();
    },
  );
}

/// generated route for
/// [_i14.SignUpScreen]
class SignUpRoute extends _i16.PageRouteInfo<void> {
  const SignUpRoute({List<_i16.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i14.SignUpScreen();
    },
  );
}

/// generated route for
/// [_i15.SplashScreen]
class SplashRoute extends _i16.PageRouteInfo<void> {
  const SplashRoute({List<_i16.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i16.PageInfo page = _i16.PageInfo(
    name,
    builder: (data) {
      return const _i15.SplashScreen();
    },
  );
}
