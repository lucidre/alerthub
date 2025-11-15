import 'package:alerthub/features/hospitals/data/model/hospital/drivers.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospital_data.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospitals.dart';

abstract class HospitalRepository {
  Future<HospitalData> getHospital(String id);
  Future<Hospitals> nearbyHospitals(
      {required int radius,
      required double lat,
      required double lng,
      required int page});

  Future<Drivers> getDriversList(int page);

  Future<void> deleteDriver(String id);

  Future<String> uploadDriverImage(String filePath);

  Future<void> createDriver({
    required String fullName,
    required String email,
    required String password,
    required String image,
    required String contact,
  });

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
  }); 
}
