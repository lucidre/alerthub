import 'package:alerthub/features/event/domain/usecases/event_service.dart';
import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/common_libs.dart';

class EventsOngoingController extends GetxController {
  final EventService eventService;
  EventsOngoingController(this.eventService);

  final RxList<Event> _ongoingEvents = <Event>[].obs;
  final RxInt _ongoingPage = 0.obs;
  final RxBool _ongoingIsLoading = true.obs;
  final RxBool _ongoingHasError = false.obs;
  final RxBool _ongoingAllDataLoaded = false.obs;
  final RxBool _ongoingOldDataLoading = false.obs;
  final RxBool _ongoingIsRefreshing = false.obs;

  List<Event> get ongoingEvents => _ongoingEvents;
  int get ongoingPage => _ongoingPage.value;
  bool get ongoingIsLoading => _ongoingIsLoading.value;
  bool get ongoingHasError => _ongoingHasError.value;
  bool get ongoingAllDataLoaded => _ongoingAllDataLoaded.value;
  bool get ongoingOldDataLoading => _ongoingOldDataLoading.value;
  bool get ongoingIsRefreshing => _ongoingIsRefreshing.value;

  set ongoingIsLoading(bool value) => _ongoingIsLoading.value = value;
  set ongoingHasError(bool value) => _ongoingHasError.value = value;
  set ongoingAllDataLoaded(bool value) => _ongoingAllDataLoaded.value = value;
  set ongoingOldDataLoading(bool value) => _ongoingOldDataLoading.value = value;
  set ongoingIsRefreshing(bool value) => _ongoingIsRefreshing.value = value;

  void addOngoingEvents(List<Event> events) {
    _ongoingEvents.addAll(events);
    _ongoingEvents.refresh();
  }

  void clearOngoingEvents() {
    _ongoingEvents.clear();
    _ongoingEvents.refresh();
  }

  Future<void> getOngoingData() async {
    _ongoingPage.value = 0;
    ongoingIsLoading = true;
    ongoingHasError = false;
    clearOngoingEvents();

    try {
      final data = await eventService.ongoing(ongoingPage);
      final list = data.data ?? [];

      addOngoingEvents(list);
      ongoingAllDataLoaded = list.isEmpty;
      ongoingHasError = false;
      ongoingIsLoading = false;
    } catch (exception) {
      ongoingHasError = true;
      ongoingIsLoading = false;
      return Future.error(exception.toString());
    }
  }

  Future<void> getOngoingOldData(StreamController<bool> progressStream) async {
    if (ongoingIsLoading ||
        ongoingAllDataLoaded ||
        !ongoingEvents.isNotEmpty ||
        ongoingOldDataLoading) {
      return;
    }
    _ongoingPage.value = ongoingPage + 1;
    ongoingOldDataLoading = true;
    progressStream.add(true);

    try {
      final data = await eventService.ongoing(ongoingPage);
      final list = data.data ?? [];
      ongoingAllDataLoaded = list.isEmpty;
      addOngoingEvents(list);
      ongoingOldDataLoading = false;
      progressStream.add(false);
    } catch (exception) {
      ongoingAllDataLoaded = true;
      ongoingOldDataLoading = false;
      return Future.error(exception.toString());
    }
  }
}
