import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HospitalDetailsMapController extends GetxController {
  final Rxn<LatLng> _hospitalPosition = Rxn<LatLng>();
  final Rxn<LatLng> _homePosition = Rxn<LatLng>();
  final Rxn<GoogleMapController> _controller = Rxn<GoogleMapController>();

  // Getters
  LatLng? get hospitalPosition => _hospitalPosition.value;
  LatLng? get homePosition => _homePosition.value;
  GoogleMapController? get controller => _controller.value;

  // Setters
  set hospitalPosition(LatLng? value) => _hospitalPosition.value = value;
  set homePosition(LatLng? value) => _homePosition.value = value;
  set controller(GoogleMapController? value) => _controller.value = value;

  StreamSubscription<LatLng?>? positionStramSubscription;

  initData(Hospital hospital) {
    hospitalPosition = LatLng(
      hospital.lat ?? -1,
      hospital.lng ?? -1,
    );

    zoomToHome(hospitalPosition!);
    getLocationUpdate();
  }

  zoomToHome(LatLng latLng) async {
    if (controller != null) {
      await controller!.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 10),
      );
    } else {
      Future.delayed(
        const Duration(seconds: 2),
        () => zoomToHome(latLng),
      );
    }
  }

  Future<void> getLocationUpdate() async {
    try {
      final controller = Get.find<LocationController>();
      await controller.initLocationUpdate();
      if (controller.userPosition != null) {
        homePosition = controller.userPosition;
      }

      positionStramSubscription?.cancel();
      positionStramSubscription = controller.userPositionRxn?.listen((current) {
        if (current != null) {
          final latLng = LatLng(current.latitude, current.longitude);
          homePosition = latLng;
        }
      });
    } catch (_) {}
  }

  cancelStream() {
    positionStramSubscription?.cancel();
  }
}
