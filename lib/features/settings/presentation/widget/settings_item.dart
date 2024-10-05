import 'package:alerthub/common_libs.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? color;
  final VoidCallback? onPressed;

  const SettingsItem({
    super.key,
    required this.title,
    required this.icon,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => onPressed?.call(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(space12),
        child: Row(
          children: [
            Icon(
              icon,
              color: color ?? context.textColor,
            ),
            horizontalSpacer12,
            Expanded(
              child: Text(
                title,
                style: satoshi500S14.copyWith(color: color),
              ),
            ),
            horizontalSpacer12,
            Icon(
              Icons.arrow_right_rounded,
              color: color ?? context.textColor,
            ),
          ],
        ),
      ),
    ).fadeInAndMoveFromBottom();
  }
}
