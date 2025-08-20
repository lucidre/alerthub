import 'package:alerthub/features/informations/data/model/informations/informations.dart';
import 'package:alerthub/features/informations/domain/repositories/information_repository.dart';

class InformationService {
  final InformationRepository repository;

  InformationService(this.repository);

  Future<Informations> getInformations() => repository.getInformations();
}
