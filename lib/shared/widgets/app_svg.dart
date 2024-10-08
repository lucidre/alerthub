import 'package:alerthub/common_libs.dart';
import 'package:flutter_svg/svg.dart';

class AppSvg extends StatelessWidget {
  final String icon;
  final String name;
  final double size;
  final Color? color;
  final bool ignoreColor;
  final VoidCallback? onPressed;

  const AppSvg(
      {required this.icon,
      required this.name,
      this.size = 24,
      this.onPressed,
      this.ignoreColor = false,
      this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        onPressed?.call();
      },
      child: ignoreColor
          ? SvgPicture.asset(
              icon,
              alignment: Alignment.center,
              semanticsLabel: name,
              height: size,
              width: size,
            )
          : SvgPicture.asset(
              icon,
              alignment: Alignment.center,
              semanticsLabel: name,
              height: size,
              width: size,
              colorFilter:
                  ColorFilter.mode(color ?? context.textColor, BlendMode.srcIn),
            ),
    );
  }
}
