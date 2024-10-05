import 'dart:io';

import 'package:alerthub/features/event/data/model/event/events.dart';
import 'package:alerthub/shared/api/server_method.dart';
import 'package:alerthub/features/user/data/model/user_data/user_data.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

class UserRemoteDataSource {
  Future<String> updateUser({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String? country,
    required String? imageUrl,
  }) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
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

  Future<UserData> getUser() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final response = await $get('user/get_user/$uid');

      if (response.isError) {
        return Future.error(response.message);
      }
      return UserData.fromMap(response.data);
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

  Future<void> logIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on SocketException {
      return Future.error('No internet connection.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Future.error('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return Future.error('Wrong password provided for that user.');
      } else {
        return Future.error(e.message.toString());
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String country,
    required String password,
  }) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      user?.sendEmailVerification();

      await UserRemoteDataSource().createUser(
        uid: FirebaseAuth.instance.currentUser?.uid ?? '',
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        country: country,
      );
      await FirebaseAuth.instance.signOut();
    } on SocketException {
      throw 'No internet connection.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'An account already exists for that email.';
      } else {
        throw e.message.toString();
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<String> uploadProfilePicture(String filePath) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final url = await _uploadDocument(
        filePath,
        'users/$uid',
        'profileImage',
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

  Future<Events> getUserEvents(int page) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      final response = await $get('event/user_events?uid=$uid&page=$page');
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
}
