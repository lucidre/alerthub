import 'package:alerthub/common_libs.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {
  final location = Location();
  final RxBool _hasInitLocationListener = false.obs;

  final Rxn<LatLng> _userPosition = Rxn();

  LatLng? get userPosition => _userPosition.value;
  Rxn<LatLng>? get userPositionRxn => _userPosition;
  StreamSubscription<LocationData>? positionStramSubscription;

  setUserPosition(LatLng? position) => _userPosition.value = position;

  initLocationUpdate() async {
    if (_hasInitLocationListener.value) {
      return;
    }
    try {
      bool enabled = await location.serviceEnabled();
      if (enabled) {
        enabled = await location.requestService();
        if (!enabled) {
          throw 'Location services are disabled/turned off.';
        }
      } else {
        throw 'Location services are disabled/turned off.';
      }

      PermissionStatus permission = await location.hasPermission();

      if (permission == PermissionStatus.denied) {
        permission = await location.requestPermission();
        if (permission == PermissionStatus.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == PermissionStatus.deniedForever) {
        throw 'Location permissions are permanently denied, we cannot request permissions.';
      }

      final current = await location.getLocation();
      if (current.latitude != null && current.longitude != null) {
        final latLng = LatLng(current.latitude!, current.longitude!);
        setUserPosition(latLng);
      }

      positionStramSubscription?.cancel();
      positionStramSubscription = location.onLocationChanged.listen(
        (current) {
          if (current.latitude != null && current.longitude != null) {
            final latLng = LatLng(current.latitude!, current.longitude!);
            setUserPosition(latLng);
          }
        },
      );

      _hasInitLocationListener(true);
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
