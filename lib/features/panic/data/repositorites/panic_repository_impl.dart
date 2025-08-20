import 'package:alerthub/features/panic/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/panic/domain/repositories/panic_repository.dart';

class PanicRepositoryImpl implements PanicRepository {
  final PanicRemoteDataSource remoteDataSource;

  PanicRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> wakeup() async {
    try {
      final response = await remoteDataSource.wakeUp();
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<void> panicModeToggle({
    required double latitude,
    required double longitude,
    required bool isOnOrOff,
  }) async {
    try {
      final response = await remoteDataSource.panicModeToggle(
        latitude: latitude,
        longitude: longitude,
        isOnOrOff: isOnOrOff,
      );
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }
}
