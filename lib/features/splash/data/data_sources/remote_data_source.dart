import 'dart:io';
import 'package:http/http.dart';
import 'package:alerthub/shared/api/server_method.dart';

class SplashRemoteDataSource {
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
}
