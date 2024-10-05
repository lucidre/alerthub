 
import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/common_libs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventDetailsMapController extends GetxController {
  final Rxn<LatLng> _eventPosition = Rxn<LatLng>();
  final Rxn<LatLng> _homePosition = Rxn<LatLng>();
  final Rxn<GoogleMapController> _controller = Rxn<GoogleMapController>();

  // Getters
  LatLng? get eventPosition => _eventPosition.value;
  LatLng? get homePosition => _homePosition.value;
  GoogleMapController? get controller => _controller.value;

  // Setters
  set eventPosition(LatLng? value) => _eventPosition.value = value;
  set homePosition(LatLng? value) => _homePosition.value = value;
  set controller(GoogleMapController? value) => _controller.value = value;

  StreamSubscription<LatLng?>? positionStramSubscription;

  initData(Event event) {
    eventPosition = LatLng(
      event.lat ?? -1,
      event.lng ?? -1,
    );

    zoomToHome(eventPosition!);
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
