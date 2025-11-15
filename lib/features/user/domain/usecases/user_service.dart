import 'package:alerthub/features/user/data/model/contacts/contacts.dart';
import 'package:alerthub/features/user/data/model/user_data/user_data.dart';
import 'package:alerthub/features/user/domain/repositories/user_repository.dart';
import 'package:alerthub/features/user/data/model/account_types.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospital_data.dart';

class UserService {
  final UserRepository repository;

  UserService(this.repository);

  Future<String> deleteUser() => repository.deleteUser();

  Future<UserData> getUser() => repository.getUser();

  Future<HospitalData> getHospital() => repository.getHospital();

  Future<String> getEmergencyInformation() =>
      repository.getEmergencyInformation();

  Future<void> updateEmergencyInformation(String description) =>
      repository.updateEmergencyInformation(description);

  Future<ContactData> getEmergencyContact() => repository.getEmergencyContact();

  Future<void> addEmergencyContact({
    required String fullName,
    required String phoneNumber,
    required String country,
  }) =>
      repository.addEmergencyContact(
        fullName: fullName,
        phoneNumber: phoneNumber,
        country: country,
      );

  Future<void> updateEmergencyContact({
    required String id,
    required String fullName,
    required String phoneNumber,
    required String country,
  }) =>
      repository.updateEmergencyContact(
        id: id,
        fullName: fullName,
        phoneNumber: phoneNumber,
        country: country,
      );

  Future<void> deleteEmergencyContact(String id) =>
      repository.deleteEmergencyContact(id);

  Future<String> updateUser({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String? country,
    required String? imageUrl,
  }) =>
      repository.updateUser(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        country: country,
        imageUrl: imageUrl,
      );

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
  }) =>
      repository.updateHealthCenter(
        hospitalName: hospitalName,
        email: email,
        helpline: helpline,
        description: description,
        country: country,
        imageUrl: imageUrl,
        latitude: latitude,
        longitude: longitude,
        location: location,
        drivers: drivers,
      );

  Future<void> forgotPassword(String email) => repository.forgotPassword(email);

  Future<void> logIn(String email, String password) =>
      repository.logIn(email, password);

  Future<void> register({
    required String email,
    required AccountType type,
    required String password,
  }) =>
      repository.register(
        email: email,
        type: type,
        password: password,
      );

  Future<String> uploadProfilePicture(String filePath) =>
      repository.uploadProfilePicture(filePath);

  Future getEmergencyInfo() async {}
}
