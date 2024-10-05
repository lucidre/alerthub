import 'package:alerthub/features/event/data/model/event/events.dart';
import 'package:alerthub/features/user/data/model/user_data/user_data.dart';
import 'package:alerthub/features/user/domain/repositories/user_repository.dart';

class UserService {
  final UserRepository repository;

  UserService(this.repository);

  Future<Events> getUserEvents(int page) => repository.getUserEvents(page);

  Future<String> createUser({
    required String uid,
    required String fullName,
    required String email,
    required String phoneNumber,
    required String country,
  }) =>
      repository.createUser(
        uid: uid,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        country: country,
      );

  Future<String> deleteUser() => repository.deleteUser();

  Future<UserData> getUser() => repository.getUser();

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

  Future<void> forgotPassword(String email) => repository.forgotPassword(email);

  Future<void> logIn(String email, String password) =>
      repository.logIn(email, password);

  Future<void> register(
          {required String fullName,
          required String email,
          required String phoneNumber,
          required String country,
          required String password}) =>
      repository.register(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        country: country,
        password: password,
      );

  Future<String> uploadProfilePicture(String filePath) =>
      repository.uploadProfilePicture(filePath);
}
