import 'package:alerthub/features/informations/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/informations/data/model/informations/informations.dart';
import 'package:alerthub/features/informations/domain/repositories/information_repository.dart';

class InformationRepositoryImpl implements InformationRepository {
  final InformationRemoteDataSource remoteDataSource;

  InformationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Informations> getInformations(int page) async {
    try {
      final response = await remoteDataSource.getInformations(page);
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }
}
