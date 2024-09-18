import 'dart:io';

import 'package:alerthub/models/event/event.dart';
import 'package:alerthub/models/user/user_model.dart';
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

      await setUserData(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        country: country,
        password: password,
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

  Future<void> setUserData({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? country,
    String? password,
    String? imageUrl,
  }) async {
    try {
      final user = sAuth.currentUser;
      String userId = user?.uid ?? "";
      UserModel model = UserModel(
          fullName: fullName,
          uid: userId,
          email: email,
          phoneNumber: phoneNumber,
          country: country,
          imageUrl: imageUrl);
      await cUsers.doc(userId).set(model.toMap(), SetOptions(merge: true));
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

  Future<UserModel> getUserProfile() async {
    try {
      final uid = sAuth.currentUser?.uid;
      final data = await cUsers.doc(uid).get();
      if (data.exists) {
        final mapData = data.data() ?? {};
        final userData = UserModel.fromMap(mapData);
        return userData;
      } else {
        return Future.error('An error occurred getting your profile');
      }
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }

  Future<List<EventModel>> getEvents() async {
    try {
      final qwerySnapshot =
          await cEvents.limit(30).orderBy('updated_at', descending: true).get();
      final eventList = qwerySnapshot.docs.map(
        (data) {
          return EventModel.fromMap(data.data());
        },
      ).toList();
      return eventList;
    } catch (exception) {
      return Future.error(exception.toString());
    }
  }
}
