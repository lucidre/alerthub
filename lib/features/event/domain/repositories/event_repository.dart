import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/features/event/data/model/event/events.dart';

abstract class EventRepository {
  Future<Event> getEvent(String eventId);

  Future<Events> search(String query, int page);

  Future<Events> nearby({
    required int radius,
    required double lat,
    required double lng,
    required int page,
  });

  Future<Events> map({
    required double radius,
    required double lat,
    required double lng,
  });

  Future<Events> ongoing(int page);

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
  });
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
  });

  Future<String> voteEvent({
    required String eventId,
    required bool isTrue,
    required String comment,
  });

  Future<String> deleteEvent(String eventId);

  Future<List<String>> uploadEventImages(String eventId, List<String> paths);
}
