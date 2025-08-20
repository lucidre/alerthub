import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:alerthub/common_libs.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  final location = Location();
  final RxBool _hasInitLocationLister = false.obs;

  final Rxn<LatLng> _current = Rxn();
  LatLng? get userPosition => _current.value;
  Rxn<LatLng>? get userPositionRxn => _current;

  setHomePosition(LatLng? position) => _current.value = position;

  initLocationUpdate() async {
    if (_hasInitLocationLister.value) {
      return;
    }
    try {
      bool enabled = await location.serviceEnabled();
      if (enabled) {
        enabled = await location.requestService();
        if (!enabled) {
          throw 'Device location is turned off or disabled.';
        }
      } else {
        throw 'Device location is turned off or disabled.';
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

      _hasInitLocationLister(true);
      location.onLocationChanged.listen(
        (current) {
          if (current.latitude != null && current.longitude != null) {
            final latLng = LatLng(current.latitude!, current.longitude!);
            setHomePosition(latLng);
          }
        },
      );
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
