import 'package:alerthub/features/splash/domain/repositories/splash_repository.dart';

class SplashService {
  final SplashRepository repository;

  SplashService(this.repository);

  Future<String> wakeup() => repository.wakeup();
}
