// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:alerthub/common_libs.dart' as _i36;
import 'package:alerthub/features/app_main/presentation/pages/blueetooth_screen.dart'
    as _i4;
import 'package:alerthub/features/app_main/presentation/pages/healthcare_main.dart'
    as _i13;
import 'package:alerthub/features/app_main/presentation/pages/user_main.dart'
    as _i30;
import 'package:alerthub/features/event/data/model/event/event.dart' as _i37;
import 'package:alerthub/features/event/presentation/pages/create_event.dart'
    as _i5;
import 'package:alerthub/features/event/presentation/pages/event_address_picker.dart'
    as _i6;
import 'package:alerthub/features/event/presentation/pages/event_details.dart'
    as _i8;
import 'package:alerthub/features/event/presentation/pages/event_details_map.dart'
    as _i7;
import 'package:alerthub/features/event/presentation/pages/event_search.dart'
    as _i9;
import 'package:alerthub/features/event/presentation/pages/events_nearby.dart'
    as _i10;
import 'package:alerthub/features/event/presentation/pages/events_ongoing.dart'
    as _i11;
import 'package:alerthub/features/event/presentation/pages/user_posted_events.dart'
    as _i31;
import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart'
    as _i38;
import 'package:alerthub/features/hospitals/presentation/pages/health_care_drivers_list.dart'
    as _i12;
import 'package:alerthub/features/hospitals/presentation/pages/health_care_user_list.dart'
    as _i14;
import 'package:alerthub/features/hospitals/presentation/pages/hospital_details.dart'
    as _i17;
import 'package:alerthub/features/hospitals/presentation/pages/hospital_details_map.dart'
    as _i16;
import 'package:alerthub/features/hospitals/presentation/pages/hospitals_nearby.dart'
    as _i18;
import 'package:alerthub/features/informations/data/model/informations/information.dart'
    as _i39;
import 'package:alerthub/features/informations/presentation/pages/information_details.dart'
    as _i19;
import 'package:alerthub/features/notifications/presentation/pages/notifications.dart'
    as _i20;
import 'package:alerthub/features/onboarding/presentation/pages/onboarding.dart'
    as _i21;
import 'package:alerthub/features/panic/presentation/pages/panic_screen.dart'
    as _i22;
import 'package:alerthub/features/settings/presentation/pages/setting_language.dart'
    as _i23;
import 'package:alerthub/features/settings/presentation/pages/settings.dart'
    as _i24;
import 'package:alerthub/features/splash/presentation/pages/splash_screen.dart'
    as _i25;
import 'package:alerthub/features/user/presentation/pages/account_setup/ambulance_account_setup.dart'
    as _i2;
import 'package:alerthub/features/user/presentation/pages/account_setup/hospital_account_setup.dart'
    as _i15;
import 'package:alerthub/features/user/presentation/pages/account_setup/user_account_setup.dart'
    as _i26;
import 'package:alerthub/features/user/presentation/pages/ambulance_not_verified.dart'
    as _i3;
import 'package:alerthub/features/user/presentation/pages/sign_up.dart' as _i33;
import 'package:alerthub/features/user/presentation/pages/user_edit_profile.dart'
    as _i27;
import 'package:alerthub/features/user/presentation/pages/user_emergency_contact.dart'
    as _i28;
import 'package:alerthub/features/user/presentation/pages/user_forgot_password.dart'
    as _i29;
import 'package:alerthub/features/user/presentation/pages/user_sign_in.dart'
    as _i32;
import 'package:alerthub/shared/pages/address_picker.dart' as _i1;
import 'package:alerthub/shared/pages/view_image.dart' as _i34;
import 'package:auto_route/auto_route.dart' as _i35;

/// generated route for
/// [_i1.AddressPickerScreen]
class AddressPickerRoute extends _i35.PageRouteInfo<void> {
  const AddressPickerRoute({List<_i35.PageRouteInfo>? children})
    : super(AddressPickerRoute.name, initialChildren: children);

  static const String name = 'AddressPickerRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i1.AddressPickerScreen();
    },
  );
}

/// generated route for
/// [_i2.AmbulanceAccountSetupScreen]
class AmbulanceAccountSetupRoute
    extends _i35.PageRouteInfo<AmbulanceAccountSetupRouteArgs> {
  AmbulanceAccountSetupRoute({
    _i36.Key? key,
    required String email,
    List<_i35.PageRouteInfo>? children,
  }) : super(
         AmbulanceAccountSetupRoute.name,
         args: AmbulanceAccountSetupRouteArgs(key: key, email: email),
         initialChildren: children,
       );

  static const String name = 'AmbulanceAccountSetupRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AmbulanceAccountSetupRouteArgs>();
      return _i2.AmbulanceAccountSetupScreen(key: args.key, email: args.email);
    },
  );
}

class AmbulanceAccountSetupRouteArgs {
  const AmbulanceAccountSetupRouteArgs({this.key, required this.email});

  final _i36.Key? key;

  final String email;

  @override
  String toString() {
    return 'AmbulanceAccountSetupRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [_i3.AmbulanceNotVerifiedScreen]
class AmbulanceNotVerifiedRoute
    extends _i35.PageRouteInfo<AmbulanceNotVerifiedRouteArgs> {
  AmbulanceNotVerifiedRoute({
    _i36.Key? key,
    required String email,
    List<_i35.PageRouteInfo>? children,
  }) : super(
         AmbulanceNotVerifiedRoute.name,
         args: AmbulanceNotVerifiedRouteArgs(key: key, email: email),
         initialChildren: children,
       );

  static const String name = 'AmbulanceNotVerifiedRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AmbulanceNotVerifiedRouteArgs>();
      return _i3.AmbulanceNotVerifiedScreen(key: args.key, email: args.email);
    },
  );
}

class AmbulanceNotVerifiedRouteArgs {
  const AmbulanceNotVerifiedRouteArgs({this.key, required this.email});

  final _i36.Key? key;

  final String email;

  @override
  String toString() {
    return 'AmbulanceNotVerifiedRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [_i4.BluetoothListScreen]
class BluetoothListRoute extends _i35.PageRouteInfo<void> {
  const BluetoothListRoute({List<_i35.PageRouteInfo>? children})
    : super(BluetoothListRoute.name, initialChildren: children);

  static const String name = 'BluetoothListRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i4.BluetoothListScreen();
    },
  );
}

/// generated route for
/// [_i5.CreateEventScreen]
class CreateEventRoute extends _i35.PageRouteInfo<CreateEventRouteArgs> {
  CreateEventRoute({
    _i36.Key? key,
    _i37.Event? event,
    List<_i35.PageRouteInfo>? children,
  }) : super(
         CreateEventRoute.name,
         args: CreateEventRouteArgs(key: key, event: event),
         initialChildren: children,
       );

  static const String name = 'CreateEventRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateEventRouteArgs>(
        orElse: () => const CreateEventRouteArgs(),
      );
      return _i5.CreateEventScreen(key: args.key, event: args.event);
    },
  );
}

class CreateEventRouteArgs {
  const CreateEventRouteArgs({this.key, this.event});

  final _i36.Key? key;

  final _i37.Event? event;

  @override
  String toString() {
    return 'CreateEventRouteArgs{key: $key, event: $event}';
  }
}

/// generated route for
/// [_i6.EventAddressPickerScreen]
class EventAddressPickerRoute extends _i35.PageRouteInfo<void> {
  const EventAddressPickerRoute({List<_i35.PageRouteInfo>? children})
    : super(EventAddressPickerRoute.name, initialChildren: children);

  static const String name = 'EventAddressPickerRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i6.EventAddressPickerScreen();
    },
  );
}

/// generated route for
/// [_i7.EventDetailsMapScreen]
class EventDetailsMapRoute
    extends _i35.PageRouteInfo<EventDetailsMapRouteArgs> {
  EventDetailsMapRoute({
    _i36.Key? key,
    required _i37.Event event,
    List<_i35.PageRouteInfo>? children,
  }) : super(
         EventDetailsMapRoute.name,
         args: EventDetailsMapRouteArgs(key: key, event: event),
         initialChildren: children,
       );

  static const String name = 'EventDetailsMapRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EventDetailsMapRouteArgs>();
      return _i7.EventDetailsMapScreen(key: args.key, event: args.event);
    },
  );
}

class EventDetailsMapRouteArgs {
  const EventDetailsMapRouteArgs({this.key, required this.event});

  final _i36.Key? key;

  final _i37.Event event;

  @override
  String toString() {
    return 'EventDetailsMapRouteArgs{key: $key, event: $event}';
  }
}

/// generated route for
/// [_i8.EventDetailsScreen]
class EventDetailsRoute extends _i35.PageRouteInfo<EventDetailsRouteArgs> {
  EventDetailsRoute({
    _i36.Key? key,
    required _i37.Event event,
    List<_i35.PageRouteInfo>? children,
  }) : super(
         EventDetailsRoute.name,
         args: EventDetailsRouteArgs(key: key, event: event),
         initialChildren: children,
       );

  static const String name = 'EventDetailsRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EventDetailsRouteArgs>();
      return _i8.EventDetailsScreen(key: args.key, event: args.event);
    },
  );
}

class EventDetailsRouteArgs {
  const EventDetailsRouteArgs({this.key, required this.event});

  final _i36.Key? key;

  final _i37.Event event;

  @override
  String toString() {
    return 'EventDetailsRouteArgs{key: $key, event: $event}';
  }
}

/// generated route for
/// [_i9.EventSearchScreen]
class EventSearchRoute extends _i35.PageRouteInfo<EventSearchRouteArgs> {
  EventSearchRoute({
    _i36.Key? key,
    required String search,
    List<_i35.PageRouteInfo>? children,
  }) : super(
         EventSearchRoute.name,
         args: EventSearchRouteArgs(key: key, search: search),
         initialChildren: children,
       );

  static const String name = 'EventSearchRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EventSearchRouteArgs>();
      return _i9.EventSearchScreen(key: args.key, search: args.search);
    },
  );
}

class EventSearchRouteArgs {
  const EventSearchRouteArgs({this.key, required this.search});

  final _i36.Key? key;

  final String search;

  @override
  String toString() {
    return 'EventSearchRouteArgs{key: $key, search: $search}';
  }
}

/// generated route for
/// [_i10.EventsNearbyScreen]
class EventsNearbyRoute extends _i35.PageRouteInfo<void> {
  const EventsNearbyRoute({List<_i35.PageRouteInfo>? children})
    : super(EventsNearbyRoute.name, initialChildren: children);

  static const String name = 'EventsNearbyRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i10.EventsNearbyScreen();
    },
  );
}

/// generated route for
/// [_i11.EventsOngoingScreen]
class EventsOngoingRoute extends _i35.PageRouteInfo<void> {
  const EventsOngoingRoute({List<_i35.PageRouteInfo>? children})
    : super(EventsOngoingRoute.name, initialChildren: children);

  static const String name = 'EventsOngoingRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i11.EventsOngoingScreen();
    },
  );
}

/// generated route for
/// [_i12.HealthCareDriverListScreen]
class HealthCareDriverListRoute extends _i35.PageRouteInfo<void> {
  const HealthCareDriverListRoute({List<_i35.PageRouteInfo>? children})
    : super(HealthCareDriverListRoute.name, initialChildren: children);

  static const String name = 'HealthCareDriverListRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i12.HealthCareDriverListScreen();
    },
  );
}

/// generated route for
/// [_i13.HealthCareMainScreen]
class HealthCareMainRoute extends _i35.PageRouteInfo<void> {
  const HealthCareMainRoute({List<_i35.PageRouteInfo>? children})
    : super(HealthCareMainRoute.name, initialChildren: children);

  static const String name = 'HealthCareMainRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i13.HealthCareMainScreen();
    },
  );
}

/// generated route for
/// [_i14.HealthCareUserListScreen]
class HealthCareUserListRoute extends _i35.PageRouteInfo<void> {
  const HealthCareUserListRoute({List<_i35.PageRouteInfo>? children})
    : super(HealthCareUserListRoute.name, initialChildren: children);

  static const String name = 'HealthCareUserListRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i14.HealthCareUserListScreen();
    },
  );
}

/// generated route for
/// [_i15.HospitalAccountSetupScreen]
class HospitalAccountSetupRoute
    extends _i35.PageRouteInfo<HospitalAccountSetupRouteArgs> {
  HospitalAccountSetupRoute({
    _i36.Key? key,
    required String email,
    List<_i35.PageRouteInfo>? children,
  }) : super(
         HospitalAccountSetupRoute.name,
         args: HospitalAccountSetupRouteArgs(key: key, email: email),
         initialChildren: children,
       );

  static const String name = 'HospitalAccountSetupRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HospitalAccountSetupRouteArgs>();
      return _i15.HospitalAccountSetupScreen(key: args.key, email: args.email);
    },
  );
}

class HospitalAccountSetupRouteArgs {
  const HospitalAccountSetupRouteArgs({this.key, required this.email});

  final _i36.Key? key;

  final String email;

  @override
  String toString() {
    return 'HospitalAccountSetupRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [_i16.HospitalDetailsMapScreen]
class HospitalDetailsMapRoute
    extends _i35.PageRouteInfo<HospitalDetailsMapRouteArgs> {
  HospitalDetailsMapRoute({
    _i36.Key? key,
    required _i38.Hospital hospital,
    List<_i35.PageRouteInfo>? children,
  }) : super(
         HospitalDetailsMapRoute.name,
         args: HospitalDetailsMapRouteArgs(key: key, hospital: hospital),
         initialChildren: children,
       );

  static const String name = 'HospitalDetailsMapRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HospitalDetailsMapRouteArgs>();
      return _i16.HospitalDetailsMapScreen(
        key: args.key,
        hospital: args.hospital,
      );
    },
  );
}

class HospitalDetailsMapRouteArgs {
  const HospitalDetailsMapRouteArgs({this.key, required this.hospital});

  final _i36.Key? key;

  final _i38.Hospital hospital;

  @override
  String toString() {
    return 'HospitalDetailsMapRouteArgs{key: $key, hospital: $hospital}';
  }
}

/// generated route for
/// [_i17.HospitalDetailsScreen]
class HospitalDetailsRoute
    extends _i35.PageRouteInfo<HospitalDetailsRouteArgs> {
  HospitalDetailsRoute({
    _i36.Key? key,
    required _i38.Hospital hospital,
    List<_i35.PageRouteInfo>? children,
  }) : super(
         HospitalDetailsRoute.name,
         args: HospitalDetailsRouteArgs(key: key, hospital: hospital),
         initialChildren: children,
       );

  static const String name = 'HospitalDetailsRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HospitalDetailsRouteArgs>();
      return _i17.HospitalDetailsScreen(key: args.key, hospital: args.hospital);
    },
  );
}

class HospitalDetailsRouteArgs {
  const HospitalDetailsRouteArgs({this.key, required this.hospital});

  final _i36.Key? key;

  final _i38.Hospital hospital;

  @override
  String toString() {
    return 'HospitalDetailsRouteArgs{key: $key, hospital: $hospital}';
  }
}

/// generated route for
/// [_i18.HospitalsNearbyScreen]
class HospitalsNearbyRoute extends _i35.PageRouteInfo<void> {
  const HospitalsNearbyRoute({List<_i35.PageRouteInfo>? children})
    : super(HospitalsNearbyRoute.name, initialChildren: children);

  static const String name = 'HospitalsNearbyRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i18.HospitalsNearbyScreen();
    },
  );
}

/// generated route for
/// [_i19.InformationDetailsScreen]
class InformationDetailsRoute
    extends _i35.PageRouteInfo<InformationDetailsRouteArgs> {
  InformationDetailsRoute({
    _i36.Key? key,
    required _i39.Information information,
    List<_i35.PageRouteInfo>? children,
  }) : super(
         InformationDetailsRoute.name,
         args: InformationDetailsRouteArgs(key: key, information: information),
         initialChildren: children,
       );

  static const String name = 'InformationDetailsRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InformationDetailsRouteArgs>();
      return _i19.InformationDetailsScreen(
        key: args.key,
        information: args.information,
      );
    },
  );
}

class InformationDetailsRouteArgs {
  const InformationDetailsRouteArgs({this.key, required this.information});

  final _i36.Key? key;

  final _i39.Information information;

  @override
  String toString() {
    return 'InformationDetailsRouteArgs{key: $key, information: $information}';
  }
}

/// generated route for
/// [_i20.NotificationsScreen]
class NotificationsRoute extends _i35.PageRouteInfo<void> {
  const NotificationsRoute({List<_i35.PageRouteInfo>? children})
    : super(NotificationsRoute.name, initialChildren: children);

  static const String name = 'NotificationsRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i20.NotificationsScreen();
    },
  );
}

/// generated route for
/// [_i21.OnboardingScreen]
class OnboardingRoute extends _i35.PageRouteInfo<void> {
  const OnboardingRoute({List<_i35.PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i21.OnboardingScreen();
    },
  );
}

/// generated route for
/// [_i22.PanicScreen]
class PanicRoute extends _i35.PageRouteInfo<void> {
  const PanicRoute({List<_i35.PageRouteInfo>? children})
    : super(PanicRoute.name, initialChildren: children);

  static const String name = 'PanicRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i22.PanicScreen();
    },
  );
}

/// generated route for
/// [_i23.SettingLaunguageScreen]
class SettingLaunguageRoute extends _i35.PageRouteInfo<void> {
  const SettingLaunguageRoute({List<_i35.PageRouteInfo>? children})
    : super(SettingLaunguageRoute.name, initialChildren: children);

  static const String name = 'SettingLaunguageRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i23.SettingLaunguageScreen();
    },
  );
}

/// generated route for
/// [_i24.SettingsScreen]
class SettingsRoute extends _i35.PageRouteInfo<void> {
  const SettingsRoute({List<_i35.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i24.SettingsScreen();
    },
  );
}

/// generated route for
/// [_i25.SplashScreen]
class SplashRoute extends _i35.PageRouteInfo<void> {
  const SplashRoute({List<_i35.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i25.SplashScreen();
    },
  );
}

/// generated route for
/// [_i26.UserAccountSetupScreen]
class UserAccountSetupRoute
    extends _i35.PageRouteInfo<UserAccountSetupRouteArgs> {
  UserAccountSetupRoute({
    _i36.Key? key,
    required String email,
    List<_i35.PageRouteInfo>? children,
  }) : super(
         UserAccountSetupRoute.name,
         args: UserAccountSetupRouteArgs(key: key, email: email),
         initialChildren: children,
       );

  static const String name = 'UserAccountSetupRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<UserAccountSetupRouteArgs>();
      return _i26.UserAccountSetupScreen(key: args.key, email: args.email);
    },
  );
}

class UserAccountSetupRouteArgs {
  const UserAccountSetupRouteArgs({this.key, required this.email});

  final _i36.Key? key;

  final String email;

  @override
  String toString() {
    return 'UserAccountSetupRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [_i27.UserEditProfileScreen]
class UserEditProfileRoute extends _i35.PageRouteInfo<void> {
  const UserEditProfileRoute({List<_i35.PageRouteInfo>? children})
    : super(UserEditProfileRoute.name, initialChildren: children);

  static const String name = 'UserEditProfileRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i27.UserEditProfileScreen();
    },
  );
}

/// generated route for
/// [_i28.UserEmergencyContactScreen]
class UserEmergencyContactRoute extends _i35.PageRouteInfo<void> {
  const UserEmergencyContactRoute({List<_i35.PageRouteInfo>? children})
    : super(UserEmergencyContactRoute.name, initialChildren: children);

  static const String name = 'UserEmergencyContactRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i28.UserEmergencyContactScreen();
    },
  );
}

/// generated route for
/// [_i29.UserForgotPasswordScreen]
class UserForgotPasswordRoute extends _i35.PageRouteInfo<void> {
  const UserForgotPasswordRoute({List<_i35.PageRouteInfo>? children})
    : super(UserForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'UserForgotPasswordRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i29.UserForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [_i30.UserMainScreen]
class UserMainRoute extends _i35.PageRouteInfo<void> {
  const UserMainRoute({List<_i35.PageRouteInfo>? children})
    : super(UserMainRoute.name, initialChildren: children);

  static const String name = 'UserMainRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i30.UserMainScreen();
    },
  );
}

/// generated route for
/// [_i31.UserPostedEventsScreen]
class UserPostedEventsRoute extends _i35.PageRouteInfo<void> {
  const UserPostedEventsRoute({List<_i35.PageRouteInfo>? children})
    : super(UserPostedEventsRoute.name, initialChildren: children);

  static const String name = 'UserPostedEventsRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i31.UserPostedEventsScreen();
    },
  );
}

/// generated route for
/// [_i32.UserSignInScreen]
class UserSignInRoute extends _i35.PageRouteInfo<void> {
  const UserSignInRoute({List<_i35.PageRouteInfo>? children})
    : super(UserSignInRoute.name, initialChildren: children);

  static const String name = 'UserSignInRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i32.UserSignInScreen();
    },
  );
}

/// generated route for
/// [_i33.UserSignUpScreen]
class UserSignUpRoute extends _i35.PageRouteInfo<void> {
  const UserSignUpRoute({List<_i35.PageRouteInfo>? children})
    : super(UserSignUpRoute.name, initialChildren: children);

  static const String name = 'UserSignUpRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      return const _i33.UserSignUpScreen();
    },
  );
}

/// generated route for
/// [_i34.ViewImageScreen]
class ViewImageRoute extends _i35.PageRouteInfo<ViewImageRouteArgs> {
  ViewImageRoute({
    _i36.Key? key,
    required String imageUrl,
    List<_i35.PageRouteInfo>? children,
  }) : super(
         ViewImageRoute.name,
         args: ViewImageRouteArgs(key: key, imageUrl: imageUrl),
         initialChildren: children,
       );

  static const String name = 'ViewImageRoute';

  static _i35.PageInfo page = _i35.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ViewImageRouteArgs>();
      return _i34.ViewImageScreen(key: args.key, imageUrl: args.imageUrl);
    },
  );
}

class ViewImageRouteArgs {
  const ViewImageRouteArgs({this.key, required this.imageUrl});

  final _i36.Key? key;

  final String imageUrl;

  @override
  String toString() {
    return 'ViewImageRouteArgs{key: $key, imageUrl: $imageUrl}';
  }
}
