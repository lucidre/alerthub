import 'package:alerthub/features/event/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/event/domain/repositories/event_repository.dart';
import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/features/event/data/model/event/events.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl(this.remoteDataSource);

  @override
  Future<Event> getEvent(String id) async {
    try {
      final response = await remoteDataSource.getEvent(id);
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<Events> map({
    required double radius,
    required double lat,
    required double lng,
  }) async {
    try {
      final response = await remoteDataSource.map(
        radius: radius,
        lat: lat,
        lng: lng,
      );
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<Events> nearby(
      {required int radius,
      required double lat,
      required double lng,
      required int page}) async {
    try {
      final response = await remoteDataSource.nearby(
        radius: radius,
        lat: lat,
        lng: lng,
        page: page,
      );
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<Events> ongoing(int page) async {
    try {
      final response = await remoteDataSource.ongoing(page);
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<Events> search(String query, int page) async {
    try {
      final response = await remoteDataSource.search(query, page);
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
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
  }) async {
    try {
      final response = await remoteDataSource.createEvent(
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
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
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
  }) async {
    try {
      final response = await remoteDataSource.editEvent(
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
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<String> deleteEvent(String eventId) async {
    try {
      final response = await remoteDataSource.deleteEvent(eventId);
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<String> voteEvent(
      {required String eventId,
      required bool isTrue,
      required String comment}) async {
    try {
      final response = await remoteDataSource.voteEvent(
        eventId: eventId,
        isTrue: isTrue,
        comment: comment,
      );
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<List<String>> uploadEventImages(
      String eventId, List<String> paths) async {
    try {
      final response = await remoteDataSource.uploadEventImages(eventId, paths);
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }
}
