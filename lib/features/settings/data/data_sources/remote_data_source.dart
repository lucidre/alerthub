import 'dart:io';

import 'package:alerthub/shared/api/server_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';

class SettingRemoteDataSource {
  Future<String> deleteUser() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final response = await $delete('user/delete_user/$uid');

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

  Future<void> changePassword() async {
    try {
      final email = FirebaseAuth.instance.currentUser?.email ?? '';
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
