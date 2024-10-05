// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/notifications/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/notifications/data/model/notifications/notification.dart';
import 'package:alerthub/features/notifications/data/repositorites/notification_repository_impl.dart';
import 'package:alerthub/features/notifications/domain/usecases/notification_service.dart';
import 'package:alerthub/features/notifications/presentation/controller/notification_controller.dart';
import 'package:alerthub/features/notifications/presentation/widget/notification_item.dart';
import 'package:alerthub/common_libs.dart' hide Notification;
import 'package:alerthub/features/notifications/presentation/bars/notifications_clear_bar.dart';
import 'package:flutter/cupertino.dart' hide Notification;

@RoutePage()
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();

    Get.put(
      NotificationController(
        NotificationService(
          NotificationRepositoryImpl(
            NotificationRemoteDataSource(),
          ),
        ),
      ),
    );
    Future.delayed(Duration.zero, () => getData());
  }

  getData() async {
    try {
      final controller = Get.find<NotificationController>();
      await controller.getData();
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: buildAppBar(),
      body: Container(
        padding: const EdgeInsets.all(space12),
        child: GetX<NotificationController>(builder: (controller) {
          final refreshController = controller.refreshController;
          final isLoading = controller.isLoading;
          final hasError = controller.hasError;
          final notifications = controller.notifications;
          return SmartRefresher(
            enablePullDown: true,
            header: const ClassicHeader(refreshStyle: RefreshStyle.UnFollow),
            onRefresh: () => controller.onRefresh(),
            controller: refreshController,
            child: isLoading
                ? context.buildLoadingWidget()
                : hasError
                    ? context.buildErrorWidget(onRetry: () => getData())
                    : notifications.isEmpty
                        ? context.buildNoDataWidget()
                        : buildBody(notifications),
          );
        }),
      ),
    );
  }

  ListView buildBody(List<Notification> notifications) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemBuilder: (ctx, index) {
        final notification = notifications[index];
        return NotificationItem(notification: notification);
      },
      itemCount: notifications.length,
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(
        color: context.textColor,
        onPressed: () => context.router.maybePop(),
      ),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title:
          Text(context.localization?.notifications ?? '', style: satoshi600S24)
              .fadeIn(),
      actions: [
        GetX<NotificationController>(builder: (controller) {
          final notifications = controller.notifications;
          if (notifications.isNotEmpty) {
            return IconButton(
              onPressed: () async {
                final result = await context.$showGeneralDialog(
                  child: const NotificationsClearBar(),
                  barrierLabel: context.localization?.clearNotifications ?? "",
                );

                if (result is bool && result) {
                  getData();
                }
              },
              icon: const Icon(CupertinoIcons.delete),
            );
          } else {
            return const SizedBox();
          }
        })
      ],
    );
  }
}
