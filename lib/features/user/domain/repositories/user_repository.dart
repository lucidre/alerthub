import 'package:alerthub/features/user/data/model/contacts/contacts.dart';
import 'package:alerthub/features/user/data/model/user_data/user_data.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospital_data.dart';
import 'package:alerthub/features/user/data/model/account_types.dart';

abstract class UserRepository {
  Future<String> updateUser({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String? country,
    required String? imageUrl,
  });

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
  });

  Future<UserData> getUser();

  Future<HospitalData> getHospital();

  Future<String> deleteUser();

  Future<String> getEmergencyInformation();

  Future<void> updateEmergencyInformation(String description);

  Future<ContactData> getEmergencyContact();

  Future<void> deleteEmergencyContact(String id);

  Future<void> addEmergencyContact({
    required String fullName,
    required String phoneNumber,
    required String country,
  });

  Future<void> updateEmergencyContact({
    required String id,
    required String fullName,
    required String phoneNumber,
    required String country,
  });

  Future<void> logIn(String email, String password);

  Future<void> register({
    required String email,
    required String password,
    required AccountType type,
  });

  Future<void> forgotPassword(String email);

  Future<String> uploadProfilePicture(String filePath);
}
