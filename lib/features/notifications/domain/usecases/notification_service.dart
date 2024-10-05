import 'package:alerthub/features/notifications/data/model/notifications/notifications.dart';
import 'package:alerthub/features/notifications/domain/repositories/notification_repository.dart';

class NotificationService {
  final NotificationRepository repository;

  NotificationService(this.repository);

  Future<Notifications> getNotifications() => repository.getNotifications();
  Future<void> clearNotifications() => repository.clearNotifications();
}
