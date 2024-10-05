import 'package:alerthub/features/settings/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/settings/domain/repositories/setting_repository.dart';

class SettingRepositoryImpl implements SettingRepository {
  final SettingRemoteDataSource remoteDataSource;

  SettingRepositoryImpl(this.remoteDataSource);

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
  Future<void> changePassword() async {
    try {
      await remoteDataSource.changePassword();
    } catch (exception) {
      return Future.error(exception);
    }
  }
}
