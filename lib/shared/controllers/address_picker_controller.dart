import 'package:alerthub/common_libs.dart' hide Marker;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:map_location_picker/map_location_picker.dart';

class AddressPickerController extends GetxController {
  // Private Rx fields
  final _geocodingResult = Rx<GeocodingResult?>(null);
  final _mapController = Rx<GoogleMapController?>(null);
  final _displayPosition = Rx<LatLng?>(null);
  final _homePosition = Rx<LatLng?>(null);
  final _selectedAddress = Rx<String?>(null);
  final _zoomLevel = 18.0.obs;
  final _geocodingResultList = <GeocodingResult>[].obs;
  final _hasZoomedToHome = false.obs;
  final _isLoading = true.obs;
  final _hasError = false.obs;
  final _homeAsset = Rx<AssetMapBitmap?>(null);
  final _error = ''.obs;

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
  AssetMapBitmap? get homeAsset => _homeAsset.value;
  String get error => _error.value;
  Set<Marker> get markers => {
        if (homePosition != null)
          Marker(
            markerId: const MarkerId('_currentLocation'),
            icon: homeAsset ??
                BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueMagenta),
            position: homePosition!,
          ),
        if (displayPosition != null)
          Marker(
            markerId: const MarkerId('one'),
            position: displayPosition!,
          ),
      };

  // Setters
  set geocodingResult(GeocodingResult? value) => _geocodingResult.value = value;
  set mapController(GoogleMapController? value) => _mapController.value = value;
  set displayPosition(LatLng? value) => _displayPosition.value = value;
  set homePosition(LatLng? value) => _homePosition.value = value;
  set selectedAddress(String? value) => _selectedAddress.value = value;
  set zoomLevel(double value) => _zoomLevel.value = value;
  set hasZoomedToHome(bool value) => _hasZoomedToHome.value = value;
  set isLoading(bool value) => _isLoading.value = value;
  set hasError(bool value) => _hasError.value = value;
  set homeAsset(AssetMapBitmap? value) => _homeAsset.value = value;
  set error(String value) => _error.value = value;

  // Method to update geocodingResultList
  set geocodingResultList(List<GeocodingResult> results) {
    _geocodingResultList.clear();
    _geocodingResultList.addAll(results);
  }

  @override
  void onInit() {
    super.onInit();
    reset();
    getLocationUpdate();
    loadAsset();
  }

  void reset() {
    _geocodingResult.value = null;
    _displayPosition.value = null;
    _selectedAddress.value = null;
    _zoomLevel.value = 18.0;
    _geocodingResultList.clear();
    _hasZoomedToHome.value = false;
    _isLoading.value = true;
    _hasError.value = false;
    _error.value = '';
  }

  @override
  void onClose() {
    _mapController.value?.dispose();
    super.onClose();
  }

  loadAsset() async {
/*     homeAsset = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(70, 70)), homePng); */
  }

  onMapCreated(GoogleMapController controller) {
    mapController = controller;
    hasZoomedToHome = false;
    if (homePosition != null) {
      zoomToHome(homePosition!);
    }
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
      controller.userPositionRxn?.listen((current) {
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

      await mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          latLng,
          17,
        ),
      );
    } else {
      Future.delayed(const Duration(seconds: 2), () => zoomToHome(latLng));
    }
  }

  void updateCamera() {
    final update = CameraUpdate.newCameraPosition(CameraPosition(
      target: displayPosition!,
      zoom: zoomLevel,
    ));
    mapController?.animateCamera(update);
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
        throw response.errorMessage ??
            "Address not found, something went wrong!";
      }
      selectedAddress = response.results.first.formattedAddress ?? "";
      geocodingResult = response.results.first;

      if (response.results.length > 1) {
        geocodingResultList = response.results;
      } else {
        geocodingResultList = [];
      }
    } catch (exception) {
      debugPrint(exception.toString());
      return Future.error(exception.toString());
    }
  }
}
