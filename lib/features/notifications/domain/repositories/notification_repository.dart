import 'package:alerthub/features/notifications/data/model/notifications/notifications.dart';

abstract class NotificationRepository {
  Future<Notifications> getNotifications();
  Future<void> clearNotifications();
}
