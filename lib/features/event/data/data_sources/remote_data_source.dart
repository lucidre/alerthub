import 'dart:io';

import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospitals.dart';
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

  Future<Hospitals> nearbyHospitals(
      {required int radius,
      required double lat,
      required double lng,
      required int page}) async {
    try {
      /*      final response = await $get(
          'event/nearby?radius=$radius&lng=$lng&lat=$lng&page=$page');

      if (response.isError) {
        return Future.error(response.message);
      }
      return Hospitals.fromMap(response.data); */

      return const Hospitals(message: null, data: sampleHospitals);
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

const sampleHospitals = [
  Hospital(
    id: 'lagos‑001',
    creatorId: 'user123',
    name: 'Lagos University Teaching Hospital',
    description:
        'The largest teaching hospital in Nigeria, serving around 25 million people. '
        'With over 950 beds, 46 clinical departments and a broad mix of tertiary services including cancer care, neurosurgery, renal dialysis, IVF services, cardiothoracic surgery, and ophthalmology. It also hosts a VIP clinic and small‑incision cataract surgery training centre.',
    location: 'Idi‑Araba, Mainland Lagos, Nigeria',
    lat: 6.4953,
    lng: 3.3480,
    images: ['https://picsum.photos/200'],
    country: 'Nigeria',
    helpline: '+2348070591395',
    drivers: ['driverA', 'driverB'],
  ),
  Hospital(
    id: 'lagos‑002',
    creatorId: 'user456',
    name: 'Federal Neuro‑Psychiatric Hospital, Yaba',
    description:
        'The first psychiatric hospital in Nigeria (est. 1907). Known as “Yaba Left”, it offers comprehensive mental health services including adult and child/adolescent psychiatry, counseling, occupational therapy, inpatient and outpatient care. It has expanded via its Oshodi Annex, home to Nigeria’s largest Child and Adolescent Mental Health Centre.',
    location: 'Yaba, Mainland Lagos, Nigeria',
    lat: 6.5120,
    lng: 3.3840,
    images: ['https://picsum.photos/400'],
    country: 'Nigeria',
    helpline: '+2348155170000',
    drivers: ['driverD', 'driverE'],
  ),
  Hospital(
    id: 'lagos‑003',
    creatorId: 'user789',
    name: 'Lagos State University Teaching Hospital (LASUTH)',
    description:
        'State‑owned tertiary hospital in Ikeja, upgraded from a general hospital in 2001. '
        'It offers a wide range of specialties—neurosurgery, cardiothoracic surgery, pediatric surgery, fertility medicine, endocrinology, rheumatology, dermatology, nephrology and more. It also runs advanced neonatal studies and community health programs.',
    location: 'Ikeja, Lagos State, Nigeria',
    lat: 6.6010,
    lng: 3.3450,
    images: ['https://picsum.photos/200/300'],
    country: 'Nigeria',
    helpline: '+2349091481560',
    drivers: ['driverX', 'driverY'],
  ),
  Hospital(
    id: 'osun‑001',
    creatorId: 'user234',
    name: 'UNIOSUN Teaching Hospital',
    description:
        'State‑owned tertiary teaching and research hospital in Osogbo, formerly LAUTECH. Established as a colonial-era African Hospital in 1928 and elevated to teaching status in the late 1990s. '
        'It offers 24/7 emergency care, general surgery, obstetrics & gynaecology, radiology, dental surgery, laboratory medicine, pharmacy, physiotherapy and a full suite of clinical and administrative departments.',
    location: 'Osogbo, Osun State, Nigeria',
    lat: 7.7680,
    lng: 4.5410,
    images: ['https://picsum.photos/200'],
    country: 'Nigeria',
    helpline: '+2347033328615',
    drivers: ['driverF'],
  ),
  Hospital(
    id: 'osun‑002',
    creatorId: 'user345',
    name: 'Morning Star Medical Centre',
    description:
        'Private general hospital in Alekuwodo, Osogbo offering outpatient clinics, in‑patient care, maternal services, routine diagnostics and minor surgery. Known for attentive private care in the Osogbo community.',
    location: 'Alekuwodo, Osogbo, Osun State, Nigeria',
    lat: 7.7665,
    lng: 4.5415,
    images: ['https://picsum.photos/300/300'],
    country: 'Nigeria',
    helpline: '+2348056789123',
    drivers: ['driverG'],
  ),
  Hospital(
    id: 'osun‑003',
    creatorId: 'user456',
    name: 'Anu Oluwa Hospital (Ilobu)',
    description:
        'Private hospital in Ilobu, Osun State providing general medical services, maternity care, outpatient consultations and minor surgeries. Serves Ilobu and nearby towns in rural Osun State.',
    location: 'Ilobu, Osun State, Nigeria',
    lat: 7.6520,
    lng: 4.4650,
    images: ['https://picsum.photos/200/400'],
    country: 'Nigeria',
    helpline: '+2348056789234',
    drivers: ['driverH'],
  ),
];
