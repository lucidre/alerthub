import 'dart:io';

import 'package:alerthub/shared/api/server_method.dart';
import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/features/event/data/model/event/events.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

class EventRemoteDataSource {
  Future<Event> getEvent(String eventId) async {
    try {
      final response = await $get('event/$eventId');
      if (response.isError) {
        return Future.error(response.message);
      }
      return Event.fromMap(response.data['data']);
    } on SocketException {
      return Future.error('No network connection.');
    } on ClientException {
      return Future.error('No network connection.');
    } catch (exception) {
      if (exception
          .toString()
          .contains('ClientException with SocketException')) {
        return Future.error('No network connection.');
      }
      return Future.error(exception.toString());
    }
  }

  Future<Events> search(String query, int page) async {
    try {
      final response = await $get('event/search/$query?page=$page');

      if (response.isError) {
        return Future.error(response.message);
      }
      return Events.fromMap(response.data);
    } on SocketException {
      return Future.error('No network connection.');
    } on ClientException {
      return Future.error('No network connection.');
    } catch (exception) {
      if (exception
          .toString()
          .contains('ClientException with SocketException')) {
        return Future.error('No network connection.');
      }
      return Future.error(exception.toString());
    }
  }

  Future<Events> nearby(
      {required int radius,
      required double lat,
      required double lng,
      required int page}) async {
    try {
      final response = await $get(
          'event/nearby?radius=$radius&lng=$lng&lat=$lng&page=$page');

      if (response.isError) {
        return Future.error(response.message);
      }
      return Events.fromMap(response.data);
    } on SocketException {
      return Future.error('No network connection.');
    } on ClientException {
      return Future.error('No network connection.');
    } catch (exception) {
      if (exception
          .toString()
          .contains('ClientException with SocketException')) {
        return Future.error('No network connection.');
      }
      return Future.error(exception.toString());
    }
  }

  Future<Events> map(
      {required double radius,
      required double lat,
      required double lng}) async {
    try {
      final response = await $get('event/map?radius=$radius&lng=$lng&lat=$lng');

      if (response.isError) {
        return Future.error(response.message);
      }
      return Events.fromMap(response.data);
    } on SocketException {
      return Future.error('No network connection.');
    } on ClientException {
      return Future.error('No network connection.');
    } catch (exception) {
      if (exception
          .toString()
          .contains('ClientException with SocketException')) {
        return Future.error('No network connection.');
      }
      return Future.error(exception.toString());
    }
  }

  Future<Events> ongoing(int page) async {
    try {
      final response = await $get('event/home?page=$page');

      if (response.isError) {
        return Future.error(response.message);
      }
      return Events.fromMap(response.data);
    } on SocketException {
      return Future.error('No network connection.');
    } on ClientException {
      return Future.error('No network connection.');
    } catch (exception) {
      if (exception
          .toString()
          .contains('ClientException with SocketException')) {
        return Future.error('No network connection.');
      }
      return Future.error(exception.toString());
    }
  }

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
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final response = await $post(
        'event/create_event?uid=$uid',
        body: {
          "name": name,
          "description": description,
          "creatorId": uid,
          "location": location,
          "lat": lat,
          "lng": lng,
          "images": images,
          "priority": priority,
          "startDate": startDate,
          "endDate": endDate,
        },
      );

      if (response.isError) {
        return Future.error(response.message);
      }
      return response.message;
    } on SocketException {
      return Future.error('No network connection.');
    } on ClientException {
      return Future.error('No network connection.');
    } catch (exception) {
      if (exception
          .toString()
          .contains('ClientException with SocketException')) {
        return Future.error('No network connection.');
      }
      return Future.error(exception.toString());
    }
  }

  Future<String> voteEvent({
    required String eventId,
    required bool isTrue,
    required String comment,
  }) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final response = await $post(
          'event/vote_event/$eventId?isEventTrue=$isTrue&comment=$comment&userId=$uid');

      if (response.isError) {
        return Future.error(response.message);
      }
      return response.message;
    } on SocketException {
      return Future.error('No network connection.');
    } on ClientException {
      return Future.error('No network connection.');
    } catch (exception) {
      if (exception
          .toString()
          .contains('ClientException with SocketException')) {
        return Future.error('No network connection.');
      }
      return Future.error(exception.toString());
    }
  }

  Future<String> deleteEvent(String eventId) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final response =
          await $delete('event/delete_event?eventId=$eventId&uid=$uid');

      if (response.isError) {
        return Future.error(response.message);
      }
      return response.message;
    } on SocketException {
      return Future.error('No network connection.');
    } on ClientException {
      return Future.error('No network connection.');
    } catch (exception) {
      if (exception
          .toString()
          .contains('ClientException with SocketException')) {
        return Future.error('No network connection.');
      }
      return Future.error(exception.toString());
    }
  }

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
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final response = await $put(
        'event/edit_event/$eventId?uid=$uid',
        body: {
          "id": eventId,
          "name": name,
          "description": description,
          "creatorId": uid,
          "location": location,
          "lat": lat,
          "lng": lng,
          "images": images,
          "priority": priority,
          "startDate": startDate,
          "endDate": endDate,
        },
      );

      if (response.isError) {
        return Future.error(response.message);
      }
      return response.message;
    } on SocketException {
      return Future.error('No network connection.');
    } on ClientException {
      return Future.error('No network connection.');
    } catch (exception) {
      if (exception
          .toString()
          .contains('ClientException with SocketException')) {
        return Future.error('No network connection.');
      }
      return Future.error(exception.toString());
    }
  }

  Future<List<String>> uploadEventImages(
      String eventId, List<String> paths) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final urls = <String>[];
      for (String path in paths) {
        final imageId = FirebaseFirestore.instance.collection('id').doc().id;
        final url = await _uploadDocument(
          path,
          'event/$uid/$eventId/images',
          imageId,
        );
        urls.add(url);
      }
      return urls;
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<String> _uploadDocument(
    String filePath,
    String savePath,
    String name,
  ) async {
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('$savePath/$name');
    try {
      UploadTask uploadTask = firebaseStorageRef.putFile(File(filePath));
      final TaskSnapshot taskSnapshot = await uploadTask;
      String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
