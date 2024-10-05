import 'package:alerthub/features/notifications/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/notifications/data/model/notifications/notifications.dart';
import 'package:alerthub/features/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Notifications> getNotifications() async {
    try {
      final response = await remoteDataSource.getNotifications();
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }

  @override
  Future<void> clearNotifications() async {
    try {
      final response = await remoteDataSource.clearNotifications();
      return response;
    } catch (exception) {
      return Future.error(exception);
    }
  }
}
