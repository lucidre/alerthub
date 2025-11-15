import 'dart:io';

import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/drivers.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospital_data.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospitals.dart';
import 'package:alerthub/shared/api/server_method.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HospitalRemoteDataSource {
  Future<HospitalData> getHospital(String id) async {
    try {
      final response = await $get('center/healthcenter/$id');
      if (response.isError) {
        return Future.error(response.message);
      }
      return HospitalData.fromMap(response.data['data']);
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

//TODO FIX ENDPOINT HERE,
  Future<Hospitals> nearbyHospitals(
      {required int radius,
      required double lat,
      required double lng,
      required int page}) async {
    try {
      final response = await $get(
        'center/healthcenter/nearby?radius=$radius&lng=$lng&lat=$lat&page=$page',
      );

      if (response.isError) {
        return Future.error(response.message);
      }
      return Hospitals.fromMap(response.data);
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

  Future<Drivers> getDriversList(int page) async {
    try {
      final id = FirebaseAuth.instance.currentUser?.uid ?? '';
      final response = await $get(
        'driver/healthcenter_list/$id?page=$page',
      );

      if (response.isError) {
        return Future.error(response.message);
      }
      return Drivers.fromMap(response.data);
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

  Future<void> deleteDriver(String id) async {
    try {
      final response = await $delete('driver/$id');

      if (response.isError) {
        return Future.error(response.message);
      }
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

  Future<void> createDriver({
    required String fullName,
    required String email,
    required String password,
    required String image,
    required String contact,
  }) async {
    try {
      final id = FirebaseAuth.instance.currentUser?.uid ?? '';

      final response = await $post('driver', body: {
        "fullName": fullName,
        "email": email,
        "password": password,
        "location": "",
        "lat": -1,
        "lng": -1,
        "image": image,
        "healthCenterId": id,
        "coontact": contact,
      });

      if (response.isError) {
        return Future.error(response.message);
      }
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

  Future<void> editDriver({
    required String id,
    required String fullName,
    required String email,
    required String password,
    required String location,
    required double lat,
    required double lng,
    required String image,
    required String contact,
  }) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final response = await $put('driver/$id', body: {
        "id": id,
        "fullName": fullName,
        "email": email,
        "password": password,
        "location": location,
        "lat": lat,
        "lng": lng,
        "image": image,
        "healthCenterId": uid,
        "coontact": contact,
      });

      if (response.isError) {
        return Future.error(response.message);
      }
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

  Future<String> uploadDriverImage(String filePath) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final id = UniqueKey().toString();
      final url = await _uploadDocument(
        filePath,
        'users/$uid/drivers',
        id,
      );
      return url;
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
