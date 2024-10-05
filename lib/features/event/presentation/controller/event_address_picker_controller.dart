import 'dart:async';

import 'package:alerthub/shared/controllers/location_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';

class EventAddressPickerController extends GetxController {
  final Rxn<GeocodingResult> _geocodingResult = Rxn<GeocodingResult>();
  final Rxn<GoogleMapController> _mapController = Rxn<GoogleMapController>();
  final Rxn<LatLng> _displayPosition = Rxn<LatLng>();
  final Rxn<LatLng> _homePosition = Rxn<LatLng>();
  final RxnString _selectedAddress = RxnString();
  final RxDouble _zoomLevel = 18.0.obs;
  final RxList<GeocodingResult> _geocodingResultList = <GeocodingResult>[].obs;
  final RxBool _hasZoomedToHome = false.obs;
  final RxBool _isLoading = true.obs;
  final RxBool _hasError = false.obs;
  final RxString _error = ''.obs;

  // Getters
  GeocodingResult? get geocodingResult => _geocodingResult.value;
  GoogleMapController? get mapController => _mapController.value;
  LatLng? get displayPosition => _displayPosition.value;
  LatLng? get homePosition => _homePosition.value;
  String? get selectedAddress => _selectedAddress.value;
  double get zoomLevel => _zoomLevel.value;
  List<GeocodingResult> get geocodingResultList => _geocodingResultList;
  bool get hasZoomedToHome => _hasZoomedToHome.value;
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  String get error => _error.value;

  // Setters
  set geocodingResult(GeocodingResult? value) => _geocodingResult.value = value;
  set mapController(GoogleMapController? value) => _mapController.value = value;
  set displayPosition(LatLng? value) => _displayPosition.value = value;
  set homePosition(LatLng? value) => _homePosition.value = value;
  set selectedAddress(String? value) => _selectedAddress.value = value;
  set zoomLevel(double value) => _zoomLevel.value = value;
  set geocodingResultList(List<GeocodingResult> value) =>
      _geocodingResultList.value = value;
  set hasZoomedToHome(bool value) => _hasZoomedToHome.value = value;
  set isLoading(bool value) => _isLoading.value = value;
  set hasError(bool value) => _hasError.value = value;
  set error(String value) => _error.value = value;

  StreamSubscription<LatLng?>? positionStramSubscription;

  cancelStream() {
    positionStramSubscription?.cancel();
  }

  Future<void> getLocationUpdate() async {
    isLoading = true;
    hasError = false;
    error = '';

    try {
      final controller = Get.find<LocationController>();
      await controller.initLocationUpdate();
      if (controller.userPosition != null) {
        homePosition = controller.userPosition;
        zoomToHome(controller.userPosition!);
      }
      positionStramSubscription?.cancel();
      positionStramSubscription = controller.userPositionRxn?.listen((current) {
        if (current != null) {
          final latLng = LatLng(current.latitude, current.longitude);
          homePosition = latLng;
          zoomToHome(latLng);
        }
      });
    } catch (exception) {
      error = exception.toString();
      hasError = true;
    }
    isLoading = false;
  }

  zoomToHome(LatLng latLng) async {
    if (hasZoomedToHome) return;

    if (mapController != null) {
      hasZoomedToHome = true;
      displayPosition = latLng;
      decodeAddress(latLng.latitude, latLng.longitude);

      await mapController!
          .animateCamera(CameraUpdate.newLatLngZoom(latLng, 20));
    } else {
      Future.delayed(const Duration(seconds: 2), () => zoomToHome(latLng));
    }
  }

  Future<void> decodeAddress(double lat, double lng) async {
    final location = Location(lat: lat, lng: lng);
    try {
      final geocoding = GoogleMapsGeocoding(apiKey: dotenv.env['mapKey'] ?? '');
      final response = await geocoding.searchByLocation(location);

      if (response.hasNoResults ||
          response.isDenied ||
          response.isInvalid ||
          response.isNotFound ||
          response.unknownError ||
          response.isOverQueryLimit) {
        selectedAddress = null;

        return Future.error(response.errorMessage ??
            "Address not found, something went wrong!");
      }
      selectedAddress = response.results.first.formattedAddress ?? "";
      geocodingResult = response.results.first;

      if (response.results.length > 1) {
        geocodingResultList = response.results;
      } else {
        geocodingResultList = [];
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
