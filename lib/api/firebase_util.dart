import 'dart:io';

import 'package:alerthub/api/network_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseUtil $firebaseUtil = FirebaseUtil();

class FirebaseUtil {
  final _users = 'users';
  final _events = 'event';
  final sAuth = FirebaseAuth.instance;
  final sCloud = FirebaseFirestore.instance;
  final sStorage = FirebaseStorage.instance.ref();

  CollectionReference<Map<String, dynamic>> get cUsers =>
      sCloud.collection(_users);
  CollectionReference<Map<String, dynamic>> get cEvents =>
      sCloud.collection(_events);

  String generateDataId() => sCloud.collection('id').doc().id;

  Future<void> logIn(String email, String password) async {
    try {
      await sAuth.signInWithEmailAndPassword(
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
      final userCredential = await sAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      user?.sendEmailVerification();

      await $networkUtil.createUser(
        uid: sAuth.currentUser?.uid ?? '',
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        country: country,
      );
      await sAuth.signOut();
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
      await sAuth.sendPasswordResetEmail(email: email);
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<List<String>> uploadEventImages(
    String eventId,
    List<String> paths,
  ) async {
    try {
      final uid = sAuth.currentUser?.uid;
      final urls = <String>[];
      for (String path in paths) {
        final imageId = generateDataId();
        final url = await uploadDocument(
          path,
          '$_events/$uid/$eventId/images',
          imageId,
        );
        urls.add(url);
      }
      return urls;
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<String> uploadProfilePicture(String filePath) async {
    try {
      final uid = sAuth.currentUser?.uid;
      final url = await uploadDocument(
        filePath,
        '$_users/$uid',
        'profileImage',
      );
      return url;
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<String> uploadDocument(
    String filePath,
    String savePath,
    String name,
  ) async {
    Reference firebaseStorageRef = sStorage.child('$savePath/$name');
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
