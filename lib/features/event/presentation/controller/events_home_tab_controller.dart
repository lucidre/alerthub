import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/features/event/domain/usecases/event_service.dart';
import 'package:alerthub/common_libs.dart';

class EventsHomeTabController extends GetxController {
  final EventService eventService;

  EventsHomeTabController(this.eventService);

  final nearByRadius = 500;
  final RxList<Event> _nearbyEvents = <Event>[].obs;
  final RxBool _nearbyIsLoading = true.obs;
  final RxBool _nearbyHasError = false.obs;

  List<Event> get nearbyEvents => _nearbyEvents;
  bool get nearbyIsLoading => _nearbyIsLoading.value;
  bool get nearbyHasError => _nearbyHasError.value;

  set nearbyIsLoading(bool value) => _nearbyIsLoading.value = value;
  set nearbyHasError(bool value) => _nearbyHasError.value = value;

  addNearbyEvents(List<Event> events) {
    _nearbyEvents.addAll(events);
    _nearbyEvents.refresh();
  }

  clearNearbyEvents() {
    _nearbyEvents.clear();
    _nearbyEvents.refresh();
  }

  getNearbyData() async {
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
        page: 0,
      );
      final list = data.data ?? [];

      addNearbyEvents(list);

      nearbyHasError = false;
      nearbyIsLoading = false;
    } catch (exception) {
      nearbyHasError = true;
      nearbyIsLoading = false;
      return Future.error(exception.toString());
    }
  }

  ////// ONGOING EVENTS DATA

  final RxList<Event> _ongoingEvents = <Event>[].obs;

  final RxBool _ongoingIsLoading = true.obs;
  final RxBool _ongoingHasError = false.obs;

  List<Event> get ongoingEvents => _ongoingEvents;

  bool get ongoingIsLoading => _ongoingIsLoading.value;
  bool get ongoingHasError => _ongoingHasError.value;

  set ongoingIsLoading(bool value) => _ongoingIsLoading.value = value;
  set ongoingHasError(bool value) => _ongoingHasError.value = value;

  void addOngoingEvents(List<Event> events) {
    _ongoingEvents.addAll(events);
    _ongoingEvents.refresh();
  }

  void clearOngoingEvents() {
    _ongoingEvents.clear();
    _ongoingEvents.refresh();
  }

  Future<void> getOngoingData() async {
    ongoingIsLoading = true;
    ongoingHasError = false;
    clearOngoingEvents();

    try {
      final data = await eventService.ongoing(0);
      final list = data.data ?? [];

      addOngoingEvents(list);

      ongoingHasError = false;
      ongoingIsLoading = false;
    } catch (exception) {
      ongoingHasError = true;
      ongoingIsLoading = false;
      return Future.error(exception.toString());
    }
  }
}
