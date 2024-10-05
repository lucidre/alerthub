import 'package:alerthub/features/notifications/data/model/notifications/notification.dart';
import 'package:alerthub/features/notifications/domain/usecases/notification_service.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationController extends GetxController {
  final NotificationService notificationService;
  NotificationController(this.notificationService);

  final RxBool _isLoading = true.obs;
  final RxBool _hasError = false.obs;
  final RxList<Notification> _notifications = <Notification>[].obs;
  final RxBool _isRefreshing = false.obs;
  final refreshController = RefreshController(initialRefresh: false);

  // Getters
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  List<Notification> get notifications => _notifications;
  bool get isRefreshing => _isRefreshing.value;

  // Setters
  set isLoading(bool value) => _isLoading.value = value;
  set hasError(bool value) => _hasError.value = value;
  set notifications(List<Notification> value) =>
      _notifications.assignAll(value);
  set isRefreshing(bool value) => _isRefreshing.value = value;

  void onRefresh() async {
    isRefreshing = true;

    await getData();

    isRefreshing = false;
  }

  getData() async {
    isLoading = true;
    hasError = false;
    _notifications.clear();

    try {
      final data = await notificationService.getNotifications();
      notifications = data.data?.notifications ?? [];
      hasError = false;
      if (isRefreshing) {
        refreshController.refreshCompleted();
      }
       isLoading = false;
    } catch (exception) {
      hasError = true;
      if (isRefreshing) {
        refreshController.refreshFailed();
      }
       isLoading = false;
      return Future.error(exception.toString());
    }
   
  }

  clearNotifications() async {
    try {
      await notificationService.clearNotifications();
    } catch (exception) {
      return Future.error(exception);
    }
  }
}
