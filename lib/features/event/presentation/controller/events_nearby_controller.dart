import 'dart:async';

import 'package:alerthub/features/event/domain/usecases/event_service.dart';
import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/shared/controllers/location_controller.dart';
import 'package:get/get.dart';

class EventsNearbyController extends GetxController {
  final EventService eventService;
  EventsNearbyController(this.eventService);

  final nearByRadius = 500;
  final RxList<Event> _nearbyEvents = <Event>[].obs;
  final RxInt _nearbyPage = 0.obs;
  final RxBool _nearbyIsLoading = true.obs;
  final RxBool _nearbyHasError = false.obs;
  final RxBool _nearbyAllDataLoaded = false.obs;
  final RxBool _nearbyOldDataLoading = false.obs;
  final RxBool _nearbyIsRefreshing = false.obs;

  List<Event> get nearbyEvents => _nearbyEvents;
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

  addNearbyEvents(List<Event> events) {
    _nearbyEvents.addAll(events);
    _nearbyEvents.refresh();
  }

  clearNearbyEvents() {
    _nearbyEvents.clear();
    _nearbyEvents.refresh();
  }

  getNearbyData() async {
    _nearbyPage(0);
    nearbyIsLoading = true;
    nearbyHasError = false;
    clearNearbyEvents();

    try {
      final controller = Get.find<LocationController>();
      await controller.initLocationUpdate();
      final currentLocation = controller.userPosition;

      final lat = currentLocation?.latitude;
      final lng = currentLocation?.longitude;

      final data = await eventService.nearby(
        radius: nearByRadius,
        lat: lat ?? -1,
        lng: lng ?? -1,
        page: nearbyPage,
      );
      final list = data.data ?? [];

      addNearbyEvents(list);
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
        !nearbyEvents.isNotEmpty ||
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

      final data = await eventService.nearby(
        radius: nearByRadius,
        lat: lat ?? -1,
        lng: lng ?? -1,
        page: nearbyPage,
      );
      final list = data.data ?? [];
      nearbyAllDataLoaded = list.isEmpty;
      addNearbyEvents(list);
      nearbyOldDataLoading = false;
      progressStream.add(false);
    } catch (exception) {
      nearbyAllDataLoaded = true;
      nearbyOldDataLoading = false;
      return Future.error(exception.toString());
    }
  }
}
