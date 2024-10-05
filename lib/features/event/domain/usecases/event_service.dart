import 'package:alerthub/features/event/domain/repositories/event_repository.dart';
import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/features/event/data/model/event/events.dart';

class EventService {
  final EventRepository repository;

  EventService(this.repository);

  Future<Event> getEvent(String id) => repository.getEvent(id);

  Future<Events> map({
    required double radius,
    required double lat,
    required double lng,
  }) =>
      repository.map(
        radius: radius,
        lat: lat,
        lng: lng,
      );

  Future<Events> nearby(
          {required int radius,
          required double lat,
          required double lng,
          required int page}) =>
      repository.nearby(
        radius: radius,
        lat: lat,
        lng: lng,
        page: page,
      );

  Future<Events> ongoing(int page) => repository.ongoing(page);

  Future<Events> search(String query, int page) =>
      repository.search(query, page);

  Future<String> createEvent({
    required String name,
    required String description,
    required String location,
    required double? lat,
    required double? lng,
    required List<String> images,
    required String priority,
    required int? startDate,
    required int? endDate,
  }) =>
      repository.createEvent(
        name: name,
        description: description,
        location: location,
        lat: lat,
        lng: lng,
        images: images,
        priority: priority,
        startDate: startDate,
        endDate: endDate,
      );

  Future<String> editEvent({
    required String eventId,
    required String name,
    required String description,
    required String location,
    required double? lat,
    required double? lng,
    required List<String> images,
    required String priority,
    required int? startDate,
    required int? endDate,
  }) =>
      repository.editEvent(
        eventId: eventId,
        name: name,
        description: description,
        location: location,
        lat: lat,
        lng: lng,
        images: images,
        priority: priority,
        startDate: startDate,
        endDate: endDate,
      );

  Future<String> voteEvent({
    required String eventId,
    required bool isTrue,
    required String comment,
  }) =>
      repository.voteEvent(
        eventId: eventId,
        isTrue: isTrue,
        comment: comment,
      );
  Future<String> deleteEvent(String eventId) => repository.deleteEvent(eventId);

  Future<List<String>> uploadEventImages(String eventId, List<String> paths) =>
      repository.uploadEventImages(eventId, paths);
}
