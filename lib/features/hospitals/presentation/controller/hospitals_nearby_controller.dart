import 'dart:async';

import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart';
import 'package:alerthub/features/hospitals/domain/usecases/hospital_service.dart';
import 'package:alerthub/shared/controllers/location_controller.dart';
import 'package:get/get.dart';

class HospitalsNearbyController extends GetxController {
  final HospitalService hospitalService;
  HospitalsNearbyController(this.hospitalService);

  final nearByRadius = 500;
  final RxList<Hospital> _nearbyHospitals = <Hospital>[].obs;
  final RxInt _nearbyPage = 0.obs;
  final RxBool _nearbyIsLoading = true.obs;
  final RxBool _nearbyHasError = false.obs;
  final RxBool _nearbyAllDataLoaded = false.obs;
  final RxBool _nearbyOldDataLoading = false.obs;
  final RxBool _nearbyIsRefreshing = false.obs;

  List<Hospital> get nearbyHospitals => _nearbyHospitals;
  int get nearbyPage => _nearbyPage.value;
  bool get nearbyIsLoading => _nearbyIsLoading.value;
  bool get nearbyHasError => _nearbyHasError.value;
  bool get nearbyAllDataLoaded => _nearbyAllDataLoaded.value;
  bool get nearbyOldDataLoading => _nearbyOldDataLoading.value;
  bool get nearbyIsRefreshing => _nearbyIsRefreshing.value;

  set nearbyIsLoading(bool value) => _nearbyIsLoading.value = value;
  set nearbyHasError(bool value) => _nearbyHasError.value = value;
  set nearbyAllDataLoaded(bool value) => _nearbyAllDataLoaded.value = value;
  set nearbyOldDataLoading(bool value) => _nearbyOldDataLoading.value = value;
  set nearbyIsRefreshing(bool value) => _nearbyIsRefreshing.value = value;

  addNearbyHospitals(List<Hospital> hospitals) {
    _nearbyHospitals.addAll(hospitals);
    _nearbyHospitals.refresh();
  }

  clearNearbyHospitals() {
    _nearbyHospitals.clear();
    _nearbyHospitals.refresh();
  }

  getNearbyData() async {
    _nearbyPage(0);
    nearbyIsLoading = true;
    nearbyHasError = false;
    clearNearbyHospitals();

    try {
      final controller = Get.find<LocationController>();
      await controller.initLocationUpdate();
      final currentLocation = controller.userPosition;

      final lat = currentLocation?.latitude;
      final lng = currentLocation?.longitude;

      final data = await hospitalService.nearbyHospitals(
        radius: nearByRadius,
        lat: lat ?? -1,
        lng: lng ?? -1,
        page: nearbyPage,
      );
      final list = data.data ?? [];

      addNearbyHospitals(list);
      nearbyAllDataLoaded = list.isEmpty;
      nearbyHasError = false;
      nearbyIsLoading = false;
    } catch (exception) {
      nearbyHasError = true;
      nearbyIsLoading = false;
      return Future.error(exception.toString());
    }
  }

  getNearbyOldData(StreamController<bool> progressStream) async {
    if (nearbyIsLoading ||
        nearbyAllDataLoaded ||
        !nearbyHospitals.isNotEmpty ||
        nearbyOldDataLoading) {
      return;
    }
    _nearbyPage(nearbyPage + 1);
    nearbyOldDataLoading = true;
    progressStream.add(true);

    try {
      final controller = Get.find<LocationController>();
      await controller.initLocationUpdate();
      final currentLocation = controller.userPosition;
      final lat = currentLocation?.latitude;
      final lng = currentLocation?.longitude;

      final data = await hospitalService.nearbyHospitals(
        radius: nearByRadius,
        lat: lat ?? -1,
        lng: lng ?? -1,
        page: nearbyPage,
      );
      final list = data.data ?? [];
      nearbyAllDataLoaded = list.isEmpty;
      addNearbyHospitals(list);
      nearbyOldDataLoading = false;
      progressStream.add(false);
    } catch (exception) {
      nearbyAllDataLoaded = true;
      nearbyOldDataLoading = false;
      return Future.error(exception.toString());
    }
  }
}
