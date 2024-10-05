import 'dart:io';

import 'package:alerthub/shared/api/server_method.dart';
import 'package:alerthub/features/notifications/data/model/notifications/notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart';

class NotificationRemoteDataSource {
  Future<Notifications> getNotifications() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final response = await $get('notification/get_notifications/$uid');

      if (response.isError) {
        return Future.error(response.message);
      }
      return Notifications.fromMap(response.data);
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

  Future<void> clearNotifications() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final response = await $delete('notification/clear_notifications/$uid');

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
}
