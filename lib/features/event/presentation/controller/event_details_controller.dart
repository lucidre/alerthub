import 'package:alerthub/features/event/domain/usecases/event_service.dart';
import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:get/get.dart';

class EventDetailsController extends GetxController {
  final EventService eventService;

  EventDetailsController(this.eventService);
  final RxBool _isLoading = true.obs;
  final RxBool _hasError = false.obs;
  final Rxn<Event> _event = Rxn<Event>();

  // Getters
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  Event? get event => _event.value;

  // Setters
  set isLoading(bool value) => _isLoading.value = value;
  set hasError(bool value) => _hasError.value = value;
  set event(Event? value) => _event.value = value;

  getData(String eventId) async {
    isLoading = true;
    hasError = false;

    try {
      event = await eventService.getEvent(eventId);
      hasError = false;
      isLoading = false;
    } catch (exception) {
      hasError = true;
      isLoading = false;
      return Future.error(exception.toString());
    }
  }

  deleteEvent() async {
    try {
      await eventService.deleteEvent(event?.id ?? '');
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<void> voteEvent(bool isTrue, String comment) async {
    try {
      await eventService.voteEvent(
        eventId: event?.id ?? '',
        isTrue: isTrue,
        comment: comment,
      );
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
