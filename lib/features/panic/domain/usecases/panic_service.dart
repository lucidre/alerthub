import 'package:alerthub/features/panic/domain/repositories/panic_repository.dart';

class PanicService {
  final PanicRepository repository;

  PanicService(this.repository);

  Future<String> wakeup() => repository.wakeup();
  Future<void> panicModeToggle({
    required double latitude,
    required double longitude,
    required bool isOnOrOff,
    required bool broadcastToCommunity,
    required bool broadcastToProviders,
    required bool broadcastToContacts,
  }) =>
      repository.panicModeToggle(
        latitude: latitude,
        longitude: longitude,
        isOnOrOff: isOnOrOff,
        broadcastToCommunity: broadcastToCommunity,
        broadcastToProviders: broadcastToProviders,
        broadcastToContacts: broadcastToContacts,
      );
}
