import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospitals.dart';

abstract class HospitalRepository {
  Future<Hospital> getHospital(String id);
  Future<Hospitals> nearbyHospitals(
      {required int radius,
      required double lat,
      required double lng,
      required int page});
}
