// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/notifications/data/model/notifications/notification.dart';
import 'package:alerthub/common_libs.dart' hide Notification;

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notification,
  });

  final Notification notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: space6,
        bottom: space6,
      ),
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              notification.description ?? '',
              style: satoshi600S12,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              $appUtil.detailedFormattedDate(
                notification.createdAt ?? 0,
              ),
              style: satoshi500S12,
            ),
          ),
        ],
      ),
    );
  }
}
