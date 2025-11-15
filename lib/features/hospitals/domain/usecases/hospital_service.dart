import 'package:alerthub/features/hospitals/data/model/hospital/drivers.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospital_data.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospitals.dart';
import 'package:alerthub/features/hospitals/domain/repositories/hospital_repository.dart';

class HospitalService {
  final HospitalRepository repository;

  HospitalService(this.repository);

  Future<HospitalData> getHospital(String id) => repository.getHospital(id);

  Future<String> uploadDriverImage(String filePath) =>
      repository.uploadDriverImage(filePath);

  Future<Hospitals> nearbyHospitals(
          {required int radius,
          required double lat,
          required double lng,
          required int page}) =>
      repository.nearbyHospitals(
        radius: radius,
        lat: lat,
        lng: lng,
        page: page,
      );

  Future<Drivers> getDriversList(int page) => repository.getDriversList(page);

  Future<void> deleteDriver(String id) => repository.deleteDriver(id);

  Future<void> createDriver({
    required String fullName,
    required String email,
    required String password,
    required String image,
    required String contact,
  }) =>
      repository.createDriver(
        fullName: fullName,
        email: email,
        password: password,
        image: image,
        contact: contact,
      );

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
  }) =>
      repository.editDriver(
        id: id,
        fullName: fullName,
        email: email,
        password: password,
        location: location,
        lat: lat,
        lng: lng,
        image: image,
        contact: contact,
      );
}
