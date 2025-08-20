import 'package:alerthub/features/panic/domain/repositories/panic_repository.dart';

class PanicService {
  final PanicRepository repository;

  PanicService(this.repository);

  Future<String> wakeup() => repository.wakeup();
  Future<void> panicModeToggle({
    required double latitude,
    required double longitude,
    required bool isOnOrOff,
  }) =>
      repository.panicModeToggle(
        latitude: latitude,
        longitude: longitude,
        isOnOrOff: isOnOrOff,
      );
}
