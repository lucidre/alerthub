import 'dart:math';
import 'package:alerthub/common_libs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapController extends GetxController {
  final _location = Location();
  StreamSubscription<LocationData>? locationStream;

  final RxBool _considerChangingCenterPosition = false.obs;
  final RxBool _hasZoomedToHome = false.obs;
  final RxBool _isLoading = true.obs;
  final RxBool _hasError = true.obs;

  final Rxn<GoogleMapController> _mapController = Rxn();

  final Rxn<LatLng> _userPosition = Rxn();
  final Rxn<LatLng> _currentPosition = Rxn();
  final Rxn<LatLng> _newPosition = Rxn();

  final RxSet<dynamic> _events = <dynamic>{}.obs;

  LatLng? get userPosition => _userPosition.value;
  LatLng? get newPosition => _newPosition.value;
  LatLng? get currentPosition => _currentPosition.value;
  bool get hasZoomedToHome => _hasZoomedToHome.value;
  bool get considerChangingCenterPosition =>
      _considerChangingCenterPosition.value;
  Set<dynamic> get event => _events;
  GoogleMapController? get mapController => _mapController.value;

  setMapController(controller) => _mapController.value = controller;
  setUserPosition(position) => _userPosition.value = position;

  addMapEvent(value) {
    _events.add(value);

    update();
  }

  getLocationUpdate() async {
    _isLoading(true);
    _hasError(false);

    try {
      bool enabled = await _location.serviceEnabled();

      if (enabled) {
        enabled = await _location.requestService();
        if (!enabled) {
          throw 'Location services are disabled/turned off.';
        }
      } else {
        throw 'Location services are disabled/turned off.';
      }

      PermissionStatus permission = await _location.hasPermission();

      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
        if (permission == PermissionStatus.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == PermissionStatus.deniedForever) {
        throw 'Location permissions are permanently denied, we cannot request permissions.';
      }
      locationStream?.cancel();

      locationStream = _location.onLocationChanged.listen(
        (current) {
          if (current.latitude != null && current.longitude != null) {
            final latLng = LatLng(current.latitude!, current.longitude!);
            setUserPosition(latLng);
            zoomToHome(latLng);
          }
        },
      );
      _isLoading(false);
    } catch (exception) {
      _hasError(true);
      _isLoading(false);
      return Future.error(exception.toString());
    }
  }

  zoomToHome(LatLng latLng) async {
    if (hasZoomedToHome) return;

    if (mapController != null) {
      _hasZoomedToHome(true);
      _currentPosition(latLng);
      _newPosition(latLng);
      final latLngZoom = CameraUpdate.newLatLngZoom(latLng, 15);
      await mapController!.animateCamera(latLngZoom);
      _considerChangingCenterPosition(true);
    } else {
      Future.delayed(
        const Duration(seconds: 2),
        () => zoomToHome(latLng),
      );
    }
  }

  double toRadians(degree) => degree * (pi / 180);

  bool shouldUpdateCurrentPosition(LatLng? position) {
    if (currentPosition == null) return false;

    _newPosition(position);

    double searchRadius = 10000;
    const earthRadius = 6371000;

    final currentPositionLat = currentPosition!.latitude;
    final currentPositionLong = currentPosition!.longitude;
    final newPositionLat = newPosition!.latitude;
    final newPositionLong = newPosition!.longitude;

    final dLat = toRadians(newPositionLat - currentPositionLat);
    final dLon = toRadians(newPositionLong - currentPositionLong);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(toRadians(currentPositionLat)) *
            cos(toRadians(newPositionLat)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = earthRadius * c;

    // if new position is outside previous range.
    if (distance > (searchRadius + 500)) {
      _currentPosition(newPosition);
      return true;
    } else {
      return false;
    }
  }
}
