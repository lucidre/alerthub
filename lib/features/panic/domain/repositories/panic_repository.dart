abstract class PanicRepository {
  Future<String> wakeup();
  Future<void> panicModeToggle({
    required double latitude,
    required double longitude,
    required bool isOnOrOff,
    required bool broadcastToCommunity,
    required bool broadcastToProviders,
    required bool broadcastToContacts,
  });
}
