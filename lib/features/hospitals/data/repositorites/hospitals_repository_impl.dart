import 'package:alerthub/features/hospitals/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/drivers.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospital_data.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospitals.dart';
import 'package:alerthub/features/hospitals/domain/repositories/hospital_repository.dart';

class HospitalRepositoryImpl implements HospitalRepository {
  final HospitalRemoteDataSource remoteDataSource;

  HospitalRepositoryImpl(this.remoteDataSource);

  @override
  Future<HospitalData> getHospital(String id) async {
    try {
      final response = await remoteDataSource.getHospital(id);
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<Drivers> getDriversList(int page) async {
    try {
      final response = await remoteDataSource.getDriversList(page);
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<String> uploadDriverImage(String filePath) async {
    try {
      final response = await remoteDataSource.uploadDriverImage(filePath);
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<void> deleteDriver(String id) async {
    try {
      final response = await remoteDataSource.deleteDriver(id);
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<void> createDriver({
    required String fullName,
    required String email,
    required String password,
    required String image,
    required String contact,
  }) async {
    try {
      final response = await remoteDataSource.createDriver(
        fullName: fullName,
        email: email,
        password: password,
        image: image,
        contact: contact,
      );
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
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
  }) async {
    try {
      final response = await remoteDataSource.editDriver(
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
        radius: radius,
        lat: lat,
        lng: lng,
        page: page,
      );
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }
}
