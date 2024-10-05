import 'package:alerthub/features/settings/domain/repositories/setting_repository.dart';

class SettingService {
  final SettingRepository repository;

  SettingService(this.repository);

  Future<String> deleteUser() => repository.deleteUser();
  Future<void> changePassword() => repository.changePassword();
}
