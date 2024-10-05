import 'package:alerthub/features/event/data/model/event/events.dart';
import 'package:alerthub/features/user/data/model/user_data/user_data.dart';

abstract class UserRepository {
  Future<String> updateUser({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String? country,
    required String? imageUrl,
  });

  Future<Events> getUserEvents(int page);

  Future<String> createUser({
    required String uid,
    required String fullName,
    required String email,
    required String phoneNumber,
    required String country,
  });
  Future<UserData> getUser();

  Future<String> deleteUser();

  Future<void> logIn(String email, String password);

  Future<void> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String country,
    required String password,
  });

  Future<void> forgotPassword(String email);

  Future<String> uploadProfilePicture(String filePath);
}
