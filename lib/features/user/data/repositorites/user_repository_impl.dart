import 'package:alerthub/features/event/data/model/event/events.dart';
import 'package:alerthub/features/user/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/user/data/model/user_data/user_data.dart';
import 'package:alerthub/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> createUser({
    required String uid,
    required String fullName,
    required String email,
    required String phoneNumber,
    required String country,
  }) async {
    try {
      final response = await remoteDataSource.createUser(
        uid: uid,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        country: country,
      );
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

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
  Future<Events> getUserEvents(int page) async {
    try {
      final response = await remoteDataSource.getUserEvents(page);
      return response;
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
  Future<void> register(
      {required String fullName,
      required String email,
      required String phoneNumber,
      required String country,
      required String password}) async {
    try {
      await remoteDataSource.register(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        country: country,
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
