import 'dart:io';

import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospitals.dart';
import 'package:alerthub/shared/api/server_method.dart';

import 'package:http/http.dart';

class HospitalRemoteDataSource {
  //TODO FIX ENDPOINT HERE
  Future<Hospital> getHospital(String id) async {
    try {
      final response = await $get('healthcenter/$id');
      if (response.isError) {
        return Future.error(response.message);
      }
      return Hospital.fromMap(response.data['data']);
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
        'healthcenter/nearby?radius=$radius&lng=$lng&lat=$lat&page=$page',
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
