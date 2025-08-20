import 'package:alerthub/features/hospitals/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospitals.dart';
import 'package:alerthub/features/hospitals/domain/repositories/hospital_repository.dart';

class HospitalRepositoryImpl implements HospitalRepository {
  final HospitalRemoteDataSource remoteDataSource;

  HospitalRepositoryImpl(this.remoteDataSource);

  @override
  Future<Hospital> getHospital(String id) async {
    try {
      final response = await remoteDataSource.getHospital(id);
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<Hospitals> nearbyHospitals(
      {required int radius,
      required double lat,
      required double lng,
      required int page}) async {
    try {
      final response = await remoteDataSource.nearbyHospitals(
          radius: radius, lat: lat, lng: lng, page: page);
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }
}
