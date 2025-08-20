import 'dart:async';

import 'package:alerthub/features/event/domain/usecases/event_service.dart';
import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:get/get.dart';

class UserPostedEventsController extends GetxController {
  final EventService eventService;
  UserPostedEventsController(this.eventService);

  final RxInt _upePage = 0.obs;
  final RxBool _upeIsLoading = true.obs;
  final RxBool _upeHasError = false.obs;
  final RxBool _upeOldDataLoading = false.obs;
  final RxBool _upeAllDataLoaded = false.obs;

  final RxList<Event> _upeEvents = <Event>[].obs;

  int get upePage => _upePage.value;
  bool get upeIsLoading => _upeIsLoading.value;
  bool get upeHasError => _upeHasError.value;
  bool get upeOldDataLoading => _upeOldDataLoading.value;
  bool get upeAllDataLoaded => _upeAllDataLoaded.value;
  List<Event> get upeEvents => _upeEvents;

  set upeIsLoading(bool value) => _upeIsLoading.value = value;
  set upeHasError(bool value) => _upeHasError.value = value;
  set upeOldDataLoading(bool value) => _upeOldDataLoading.value = value;
  set upeAllDataLoaded(bool value) => _upeAllDataLoaded.value = value;

  addUpeEvents(List<Event> events) {
    _upeEvents.addAll(events);
    _upeEvents.refresh();
  }

  clearUpEvents() {
    _upeEvents.clear();
    _upeEvents.refresh();
  }

  getUpData() async {
    _upePage(0);
    upeIsLoading = true;
    upeHasError = false;
    clearUpEvents();

    try {
      final data = await eventService.getUserEvents(upePage);
      final list = data.data ?? [];

      addUpeEvents(list);
      upeAllDataLoaded = list.isEmpty;
      upeHasError = false;
      upeIsLoading = false;
    } catch (exception) {
      upeHasError = true;
      upeIsLoading = false;
      return Future.error(exception.toString());
    }
  }

  getUpOldData(StreamController<bool> progressStream) async {
    if (upeIsLoading ||
        upeAllDataLoaded ||
        !upeEvents.isNotEmpty ||
        upeOldDataLoading) {
      return;
    }
    _upePage(upePage + 1);
    upeOldDataLoading = true;
    progressStream.add(true);

    try {
      final data = await eventService.getUserEvents(upePage);
      final list = data.data ?? [];
      upeAllDataLoaded = list.isEmpty;
      addUpeEvents(list);
      upeOldDataLoading = false;
      progressStream.add(false);
    } catch (exception) {
      upeAllDataLoaded = true;
      upeOldDataLoading = false;
      return Future.error(exception.toString());
    }
  }
}
