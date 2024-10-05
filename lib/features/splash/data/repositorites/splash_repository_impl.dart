import 'package:alerthub/features/splash/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/splash/domain/repositories/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashRemoteDataSource remoteDataSource;

  SplashRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> wakeup() async {
    try {
      final response = await remoteDataSource.wakeUp();
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }
}
