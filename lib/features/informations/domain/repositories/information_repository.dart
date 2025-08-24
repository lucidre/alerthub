import 'package:alerthub/features/informations/data/model/informations/informations.dart';

abstract class InformationRepository {
  Future<Informations> getInformations(int page);
}
