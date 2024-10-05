import 'dart:math';

import 'package:alerthub/features/event/domain/usecases/event_service.dart';
import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/common_libs.dart';

import 'package:collection/collection.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class EventsMapTabController extends GetxController {
  final EventService eventService;

  EventsMapTabController(this.eventService);

  final searchRadius = 10000.0;

  StreamSubscription<LocationData>? locationStream;

  final RxBool _considerChangingCenterPosition = false.obs;
  final RxBool _hasZoomedToHome = false.obs;
  final RxBool _isLoading = true.obs;
  final RxBool _hasError = true.obs;
  final RxBool _hasInitLocationListener = false.obs;

  final Rxn<GoogleMapController> _mapController = Rxn();

  final Rxn<LatLng> _userPosition = Rxn();

  final Rxn<LatLng> _currentPosition = Rxn();
  final Rxn<LatLng> _newPosition = Rxn();

  final RxSet<Event> _events = <Event>{}.obs;

  LatLng? get userPosition => _userPosition.value;
  LatLng? get newPosition => _newPosition.value;
  LatLng? get currentPosition => _currentPosition.value;

  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;

  bool get hasZoomedToHome => _hasZoomedToHome.value;
  bool get considerChangingCenterPosition =>
      _considerChangingCenterPosition.value;

  Set<Event> get events => _events;
  GoogleMapController? get mapController => _mapController.value;
  StreamSubscription<LatLng?>? positionStramSubscription;

  setMapController(controller) => _mapController.value = controller;
  setUserPosition(position) => _userPosition.value = position;

  addMapEvent(Event value) {
    final oldEvent = events.firstWhereOrNull((e) => e.id == value.id);
    if (oldEvent != null) {
      //  needed in case the event details has been changed by the user.
      events.remove(oldEvent);
    }
    _events.add(value);

    _events.refresh();
  }

  cancelStream() {
    positionStramSubscription?.cancel();
  }

  Future<void> getLocationUpdate() async {
    if (_hasInitLocationListener.value) {
      return;
    }
    try {
      final controller = Get.find<LocationController>();
      await controller.initLocationUpdate();

      if (controller.userPosition != null) {
        _userPosition.value = controller.userPosition;
        zoomToHome(controller.userPosition!);
      }

      positionStramSubscription?.cancel();
      positionStramSubscription = controller.userPositionRxn?.listen((current) {
        if (current != null) {
          final latLng = LatLng(current.latitude, current.longitude);
          setUserPosition(latLng);
          zoomToHome(latLng);
        }
      });

      await Future.delayed(const Duration(seconds: 1));
      _hasInitLocationListener(true);
    } catch (_) {}
  }

  getData() async {
    _isLoading(true);
    _hasError(false);

    try {
      await getLocationUpdate();

      if (currentPosition == null) {
        Future.delayed(const Duration(seconds: 1), () => getData());
        return;
      }

      final data = await eventService.map(
        radius: searchRadius,
        lat: currentPosition!.latitude,
        lng: currentPosition!.longitude,
      );

      final events = data.data ?? [];

      for (final event in events) {
        addMapEvent(event);
      }
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
      _currentPosition(latLng);
      _newPosition(latLng);
      final latLngZoom = CameraUpdate.newLatLngZoom(latLng, 15);
      await mapController!.animateCamera(latLngZoom);
      _considerChangingCenterPosition(true);
      _hasZoomedToHome(true);
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
