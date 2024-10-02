import 'dart:io';
import 'package:alerthub/api/firebase_util.dart';
import 'package:alerthub/models/event/events.dart';
import 'package:alerthub/models/user_data/user_data.dart';
import 'package:http/http.dart' as http;

import 'network_method.dart';

NetworkUtil $networkUtil = NetworkUtil();

class NetworkUtil {
  static final NetworkUtil _singleton = NetworkUtil._internal();

  factory NetworkUtil() {
    return _singleton;
  }

  NetworkUtil._internal();

  Future<String> wakeUp() async {
    try {
      final response = await $get('event/wakeup');

      if (response.isError) {
        return Future.error(response.message);
      }
      return response.message;
    } on SocketException {
      return Future.error('No network connection.');
    } on http.ClientException {
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
    required String availablity,
  }) async {
    try {
      final uid = $firebaseUtil.sAuth.currentUser?.uid ?? '';
      final response = await $put(
        'event/edit_event/$eventId?uid=$uid',
        body: {
          "id": eventId,
          "name": name,
          "description": description,
          "creatorId": uid,
          "location": location,
          "lat": lat,
          "lng": lat,
          "images": images,
          "priority": priority,
          "availiablity": availablity,
        },
      );

      if (response.isError) {
        return Future.error(response.message);
      }
      return response.message;
    } on SocketException {
      return Future.error('No network connection.');
    } on http.ClientException {
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
    required String availablity,
  }) async {
    try {
      final uid = $firebaseUtil.sAuth.currentUser?.uid ?? '';
      final response = await $post(
        'event/create_event?uid=$uid',
        body: {
          "name": name,
          "description": description,
          "creatorId": uid,
          "location": location,
          "lat": lat,
          "lng": lat,
          "images": images,
          "priority": priority,
          "availiablity": availablity,
        },
      );

      if (response.isError) {
        return Future.error(response.message);
      }
      return response.message;
    } on SocketException {
      return Future.error('No network connection.');
    } on http.ClientException {
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

  Future<Events> getUserEvents(int page) async {
    try {
      final uid = $firebaseUtil.sAuth.currentUser?.uid ?? '';
      final response = await $get('event/user_events?uid=$uid&page=$page');

      if (response.isError) {
        return Future.error(response.message);
      }
      return Events.fromMap(response.data);
    } on SocketException {
      return Future.error('No network connection.');
    } on http.ClientException {
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
    } on http.ClientException {
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
    } on http.ClientException {
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
    } on http.ClientException {
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
    } on http.ClientException {
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
      final uid = $firebaseUtil.sAuth.currentUser?.uid ?? '';
      final response =
          await $delete('event/delete_event?eventId=$eventId&uid=$uid');

      if (response.isError) {
        return Future.error(response.message);
      }
      return response.message;
    } on SocketException {
      return Future.error('No network connection.');
    } on http.ClientException {
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

  Future<String> updateUser({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String? country,
    required String? imageUrl,
  }) async {
    try {
      final uid = $firebaseUtil.sAuth.currentUser?.uid ?? '';
      final response = await $put('user/update_user/$uid', body: {
        "userId": uid,
        "fullName": fullName,
        "email": email,
        "phoneNumber": phoneNumber,
        "country": country,
        "imageUrl": imageUrl,
      });

      if (response.isError) {
        return Future.error(response.message);
      }
      return response.message;
    } on SocketException {
      return Future.error('No network connection.');
    } on http.ClientException {
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

  Future<String> createUser({
    required String uid,
    required String fullName,
    required String email,
    required String phoneNumber,
    required String country,
  }) async {
    try {
      final response = await $post('user/create_user', body: {
        "mongoId": "string",
        "userId": uid,
        "fullName": fullName,
        "email": email,
        "phoneNumber": phoneNumber,
        "country": country,
        "imageUrl": null,
      });

      if (response.isError) {
        return Future.error(response.message);
      }
      return response.message;
    } on SocketException {
      return Future.error('No network connection.');
    } on http.ClientException {
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

  Future<UserData> getUser() async {
    try {
      final uid = $firebaseUtil.sAuth.currentUser?.uid ?? '';
      final response = await $get('user/get_user/$uid');

      if (response.isError) {
        return Future.error(response.message);
      }
      return UserData.fromMap(response.data);
    } on SocketException {
      return Future.error('No network connection.');
    } on http.ClientException {
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

  Future<String> deleteUser() async {
    try {
      final uid = $firebaseUtil.sAuth.currentUser?.uid ?? '';
      final response = await $get('user/delete_user/$uid');

      if (response.isError) {
        return Future.error(response.message);
      }
      return response.message;
    } on SocketException {
      return Future.error('No network connection.');
    } on http.ClientException {
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
}
