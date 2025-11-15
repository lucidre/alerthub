import 'package:alerthub/features/user/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/user/data/model/account_types.dart';
import 'package:alerthub/features/user/data/model/contacts/contacts.dart';
import 'package:alerthub/features/user/data/model/user_data/user_data.dart';
import 'package:alerthub/features/user/domain/repositories/user_repository.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospital_data.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);
 
  @override
  Future<String> deleteUser() async {
    try {
      final response = await remoteDataSource.deleteUser();
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<String> getEmergencyInformation() async {
    try {
      final response = await remoteDataSource.getEmergencyInformation();
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<void> updateEmergencyInformation(String description) async {
    try {
      final response =
          await remoteDataSource.updateEmergencyInformation(description);
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<ContactData> getEmergencyContact() async {
    try {
      final response = await remoteDataSource.getEmergencyContact();
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<void> addEmergencyContact({
    required String fullName,
    required String phoneNumber,
    required String country,
  }) async {
    try {
      final response = await remoteDataSource.addEmergencyContact(
          fullName: fullName, phoneNumber: phoneNumber, country: country);
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<void> updateEmergencyContact({
    required String id,
    required String fullName,
    required String phoneNumber,
    required String country,
  }) async {
    try {
      final response = await remoteDataSource.updateEmergencyContact(
        id: id,
        fullName: fullName,
        phoneNumber: phoneNumber,
        country: country,
      );

      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<void> deleteEmergencyContact(String id) async {
    try {
      await remoteDataSource.deleteEmergencyContact(id);
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<UserData> getUser() async {
    try {
      final response = await remoteDataSource.getUser();
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<HospitalData> getHospital() async {
    try {
      final response = await remoteDataSource.getHospital();
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<String> updateUser({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String? country,
    required String? imageUrl,
  }) async {
    try {
      final response = await remoteDataSource.updateUser(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        country: country,
        imageUrl: imageUrl,
      );
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<void> updateHealthCenter({
    required String hospitalName,
    required String email,
    required String? helpline,
    required String? description,
    required String? country,
    required String? imageUrl,
    required double? latitude,
    required double? longitude,
    required String? location,
    required List<String>? drivers,
  }) async {
    try {
      final response = await remoteDataSource.updateHealthCenter(
        hospitalName: hospitalName,
        email: email,
        helpline: helpline,
        description: description,
        longitude: longitude,
        country: country,
        imageUrl: imageUrl,
        latitude: latitude,
        location: location,
        drivers: drivers,
      );
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<void> logIn(String email, String password) async {
    try {
      await remoteDataSource.logIn(email, password);
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required AccountType type,
  }) async {
    try {
      await remoteDataSource.register(
        email: email,
        type: type,
        password: password,
      );
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<String> uploadProfilePicture(String filePath) async {
    try {
      final response = await remoteDataSource.uploadProfilePicture(filePath);
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  //
}
