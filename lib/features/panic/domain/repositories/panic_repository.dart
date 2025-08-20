abstract class PanicRepository {
  Future<String> wakeup();
  Future<void> panicModeToggle({
    required double latitude,
    required double longitude,
    required bool isOnOrOff,
  });
}
