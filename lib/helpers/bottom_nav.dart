import 'package:alerthub/common_libs.dart';
import 'package:alerthub/models/bottom_bar.dart';

class BottomNavBar extends StatelessWidget {
  final List<BottomBarModel> items;
  final int currentIndex;
  final Function(int)? onTap;

  const BottomNavBar({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border.all(color: neutral300),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(space4),
          topRight: Radius.circular(space4),
        ),
      ),
      padding: const EdgeInsets.only(
        left: space12,
        right: space12,
        top: space12,
        bottom: space6,
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: items.length <= 2
              ? MainAxisAlignment.spaceEvenly
              : MainAxisAlignment.spaceBetween,
          children: [for (final item in items) buildItem(item)],
        ),
      ),
    );
  }

  buildItem(BottomBarModel item) {
    return TweenAnimationBuilder<double>(
      tween: Tween(
        end: items.indexOf(item) == currentIndex ? 1.0 : 0.0,
      ),
      curve: Curves.easeIn,
      duration: fastDuration,
      builder: (context, value, _) {
        final selectedColor = context.textColor;
        final unselectedColor = context.backgroundColor;
        final selectedColorWithOpacity = selectedColor.withOpacity(0.1);
        return Material(
          color: Color.lerp(
            selectedColor.withOpacity(0.0),
            selectedColor,
            value,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(space4),
          ),
          child: InkWell(
            onTap: () => onTap?.call(items.indexOf(item)),
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(space4),
            ),
            focusColor: selectedColorWithOpacity,
            highlightColor: selectedColorWithOpacity,
            splashColor: selectedColorWithOpacity,
            hoverColor: selectedColorWithOpacity,
            child: Padding(
              padding: const EdgeInsets.only(
                left: space16,
                right: space16,
                top: space8,
                bottom: space8,
              ),
              child: Row(
                children: [
                  IconTheme(
                    data: IconThemeData(
                      color: Color.lerp(
                        selectedColor,
                        unselectedColor,
                        value,
                      ),
                      size: 24,
                    ),
                    child: Icon(
                      item.icon,
                      size: 24,
                    ),
                  ),
                  ClipRect(
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      height: 25,
                      padding: const EdgeInsets.only(left: space8),
                      child: Align(
                        alignment: const Alignment(-0.2, 0.0),
                        widthFactor: value,
                        child: Text(
                          item.title,
                          style: satoshi600S14.copyWith(
                            color: Color.lerp(
                              unselectedColor.withOpacity(0.0),
                              unselectedColor,
                              value,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
