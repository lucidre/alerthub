import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:alerthub/shared/api/server_method.dart';

class PanicRemoteDataSource {
  Future<String> wakeUp() async {
    try {
      final response = await $get('wakeup');

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

//TODO REPLACE WITH ACTUAL CODEBASE.
  Future<void> panicModeToggle({
    required double latitude,
    required double longitude,
    required bool isOnOrOff,
    required bool broadcastToCommunity,
    required bool broadcastToProviders,
    required bool broadcastToContacts,
  }) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

      final response = await $post(
        'panic/$uid?latitude=$latitude&longitude=$longitude&isOnOrOff=$isOnOrOff&broadcastToCommunity=$broadcastToCommunity&broadcastToProviders=$broadcastToProviders&broadcastToContacts=$broadcastToContacts',
       
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
}
