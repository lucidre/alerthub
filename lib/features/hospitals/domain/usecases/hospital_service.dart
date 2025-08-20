import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospitals.dart';
import 'package:alerthub/features/hospitals/domain/repositories/hospital_repository.dart';

class HospitalService {
  final HospitalRepository repository;

  HospitalService(this.repository);

  Future<Hospital> getHospital(String id) => repository.getHospital(id);
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
}
