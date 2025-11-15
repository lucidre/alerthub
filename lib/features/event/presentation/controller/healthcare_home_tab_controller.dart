import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/features/event/domain/usecases/event_service.dart';
import 'package:alerthub/common_libs.dart';

class HealthCareHomeTabController extends GetxController {
  final EventService eventService;

  HealthCareHomeTabController(this.eventService);
}
