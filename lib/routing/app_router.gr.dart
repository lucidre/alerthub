// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:alerthub/common_libs.dart' as _i20;
import 'package:alerthub/features/app_main/presentation/pages/app_main.dart'
    as _i1;
import 'package:alerthub/features/event/data/model/event/event.dart' as _i21;
import 'package:alerthub/features/event/presentation/pages/create_event.dart'
    as _i2;
import 'package:alerthub/features/event/presentation/pages/event_address_picker.dart'
    as _i3;
import 'package:alerthub/features/event/presentation/pages/event_details.dart'
    as _i5;
import 'package:alerthub/features/event/presentation/pages/event_details_map.dart'
    as _i4;
import 'package:alerthub/features/event/presentation/pages/event_search.dart'
    as _i6;
import 'package:alerthub/features/event/presentation/pages/events_nearby.dart'
    as _i7;
import 'package:alerthub/features/event/presentation/pages/events_ongoing.dart'
    as _i8;
import 'package:alerthub/features/notifications/presentation/pages/notifications.dart'
    as _i9;
import 'package:alerthub/features/onboarding/presentation/pages/onboarding.dart'
    as _i10;
import 'package:alerthub/features/settings/presentation/pages/setting_language.dart'
    as _i11;
import 'package:alerthub/features/settings/presentation/pages/settings.dart'
    as _i12;
import 'package:alerthub/features/splash/presentation/pages/splash_screen.dart'
    as _i13;
import 'package:alerthub/features/user/presentation/pages/user_edit_profile.dart'
    as _i14;
import 'package:alerthub/features/user/presentation/pages/user_forgot_password.dart'
    as _i15;
import 'package:alerthub/features/user/presentation/pages/user_sign_in.dart'
    as _i16;
import 'package:alerthub/features/user/presentation/pages/user_sign_up.dart'
    as _i17;
import 'package:alerthub/shared/pages/view_image.dart' as _i18;
import 'package:auto_route/auto_route.dart' as _i19;

/// generated route for
/// [_i1.AppMainScreen]
class AppMainRoute extends _i19.PageRouteInfo<void> {
  const AppMainRoute({List<_i19.PageRouteInfo>? children})
      : super(
          AppMainRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppMainRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i1.AppMainScreen();
    },
  );
}

/// generated route for
/// [_i2.CreateEventScreen]
class CreateEventRoute extends _i19.PageRouteInfo<CreateEventRouteArgs> {
  CreateEventRoute({
    _i20.Key? key,
    _i21.Event? event,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          CreateEventRoute.name,
          args: CreateEventRouteArgs(
            key: key,
            event: event,
          ),
          initialChildren: children,
        );

  static const String name = 'CreateEventRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateEventRouteArgs>(
          orElse: () => const CreateEventRouteArgs());
      return _i2.CreateEventScreen(
        key: args.key,
        event: args.event,
      );
    },
  );
}

class CreateEventRouteArgs {
  const CreateEventRouteArgs({
    this.key,
    this.event,
  });

  final _i20.Key? key;

  final _i21.Event? event;

  @override
  String toString() {
    return 'CreateEventRouteArgs{key: $key, event: $event}';
  }
}

/// generated route for
/// [_i3.EventAddressPickerScreen]
class EventAddressPickerRoute extends _i19.PageRouteInfo<void> {
  const EventAddressPickerRoute({List<_i19.PageRouteInfo>? children})
      : super(
          EventAddressPickerRoute.name,
          initialChildren: children,
        );

  static const String name = 'EventAddressPickerRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i3.EventAddressPickerScreen();
    },
  );
}

/// generated route for
/// [_i4.EventDetailsMapScreen]
class EventDetailsMapRoute
    extends _i19.PageRouteInfo<EventDetailsMapRouteArgs> {
  EventDetailsMapRoute({
    _i20.Key? key,
    required _i21.Event event,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          EventDetailsMapRoute.name,
          args: EventDetailsMapRouteArgs(
            key: key,
            event: event,
          ),
          initialChildren: children,
        );

  static const String name = 'EventDetailsMapRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EventDetailsMapRouteArgs>();
      return _i4.EventDetailsMapScreen(
        key: args.key,
        event: args.event,
      );
    },
  );
}

class EventDetailsMapRouteArgs {
  const EventDetailsMapRouteArgs({
    this.key,
    required this.event,
  });

  final _i20.Key? key;

  final _i21.Event event;

  @override
  String toString() {
    return 'EventDetailsMapRouteArgs{key: $key, event: $event}';
  }
}

/// generated route for
/// [_i5.EventDetailsScreen]
class EventDetailsRoute extends _i19.PageRouteInfo<EventDetailsRouteArgs> {
  EventDetailsRoute({
    _i20.Key? key,
    required _i21.Event event,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          EventDetailsRoute.name,
          args: EventDetailsRouteArgs(
            key: key,
            event: event,
          ),
          initialChildren: children,
        );

  static const String name = 'EventDetailsRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EventDetailsRouteArgs>();
      return _i5.EventDetailsScreen(
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

  final _i20.Key? key;

  final _i21.Event event;

  @override
  String toString() {
    return 'EventDetailsRouteArgs{key: $key, event: $event}';
  }
}

/// generated route for
/// [_i6.EventSearchScreen]
class EventSearchRoute extends _i19.PageRouteInfo<EventSearchRouteArgs> {
  EventSearchRoute({
    _i20.Key? key,
    required String search,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          EventSearchRoute.name,
          args: EventSearchRouteArgs(
            key: key,
            search: search,
          ),
          initialChildren: children,
        );

  static const String name = 'EventSearchRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EventSearchRouteArgs>();
      return _i6.EventSearchScreen(
        key: args.key,
        search: args.search,
      );
    },
  );
}

class EventSearchRouteArgs {
  const EventSearchRouteArgs({
    this.key,
    required this.search,
  });

  final _i20.Key? key;

  final String search;

  @override
  String toString() {
    return 'EventSearchRouteArgs{key: $key, search: $search}';
  }
}

/// generated route for
/// [_i7.EventsNearbyScreen]
class EventsNearbyRoute extends _i19.PageRouteInfo<void> {
  const EventsNearbyRoute({List<_i19.PageRouteInfo>? children})
      : super(
          EventsNearbyRoute.name,
          initialChildren: children,
        );

  static const String name = 'EventsNearbyRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i7.EventsNearbyScreen();
    },
  );
}

/// generated route for
/// [_i8.EventsOngoingScreen]
class EventsOngoingRoute extends _i19.PageRouteInfo<void> {
  const EventsOngoingRoute({List<_i19.PageRouteInfo>? children})
      : super(
          EventsOngoingRoute.name,
          initialChildren: children,
        );

  static const String name = 'EventsOngoingRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i8.EventsOngoingScreen();
    },
  );
}

/// generated route for
/// [_i9.NotificationsScreen]
class NotificationsRoute extends _i19.PageRouteInfo<void> {
  const NotificationsRoute({List<_i19.PageRouteInfo>? children})
      : super(
          NotificationsRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationsRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i9.NotificationsScreen();
    },
  );
}

/// generated route for
/// [_i10.OnboardingScreen]
class OnboardingRoute extends _i19.PageRouteInfo<void> {
  const OnboardingRoute({List<_i19.PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i10.OnboardingScreen();
    },
  );
}

/// generated route for
/// [_i11.SettingLaunguageScreen]
class SettingLaunguageRoute extends _i19.PageRouteInfo<void> {
  const SettingLaunguageRoute({List<_i19.PageRouteInfo>? children})
      : super(
          SettingLaunguageRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingLaunguageRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i11.SettingLaunguageScreen();
    },
  );
}

/// generated route for
/// [_i12.SettingsScreen]
class SettingsRoute extends _i19.PageRouteInfo<void> {
  const SettingsRoute({List<_i19.PageRouteInfo>? children})
      : super(
          SettingsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i12.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i13.SplashScreen]
class SplashRoute extends _i19.PageRouteInfo<void> {
  const SplashRoute({List<_i19.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i13.SplashScreen();
    },
  );
}

/// generated route for
/// [_i14.UserEditProfileScreen]
class UserEditProfileRoute extends _i19.PageRouteInfo<void> {
  const UserEditProfileRoute({List<_i19.PageRouteInfo>? children})
      : super(
          UserEditProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserEditProfileRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i14.UserEditProfileScreen();
    },
  );
}

/// generated route for
/// [_i15.UserForgotPasswordScreen]
class UserForgotPasswordRoute extends _i19.PageRouteInfo<void> {
  const UserForgotPasswordRoute({List<_i19.PageRouteInfo>? children})
      : super(
          UserForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserForgotPasswordRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i15.UserForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [_i16.UserSignInScreen]
class UserSignInRoute extends _i19.PageRouteInfo<void> {
  const UserSignInRoute({List<_i19.PageRouteInfo>? children})
      : super(
          UserSignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserSignInRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i16.UserSignInScreen();
    },
  );
}

/// generated route for
/// [_i17.UserSignUpScreen]
class UserSignUpRoute extends _i19.PageRouteInfo<void> {
  const UserSignUpRoute({List<_i19.PageRouteInfo>? children})
      : super(
          UserSignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserSignUpRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      return const _i17.UserSignUpScreen();
    },
  );
}

/// generated route for
/// [_i18.ViewImageScreen]
class ViewImageRoute extends _i19.PageRouteInfo<ViewImageRouteArgs> {
  ViewImageRoute({
    _i20.Key? key,
    required String imageUrl,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          ViewImageRoute.name,
          args: ViewImageRouteArgs(
            key: key,
            imageUrl: imageUrl,
          ),
          initialChildren: children,
        );

  static const String name = 'ViewImageRoute';

  static _i19.PageInfo page = _i19.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ViewImageRouteArgs>();
      return _i18.ViewImageScreen(
        key: args.key,
        imageUrl: args.imageUrl,
      );
    },
  );
}

class ViewImageRouteArgs {
  const ViewImageRouteArgs({
    this.key,
    required this.imageUrl,
  });

  final _i20.Key? key;

  final String imageUrl;

  @override
  String toString() {
    return 'ViewImageRouteArgs{key: $key, imageUrl: $imageUrl}';
  }
}
