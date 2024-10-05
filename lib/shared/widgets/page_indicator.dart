import 'package:alerthub/common_libs.dart';
import 'package:alerthub/shared/constants/package.dart';

class AppPageIndicator extends StatefulWidget {
  final int count;
  final PageController controller;

  final double? opacity;

  const AppPageIndicator({
    super.key,
    required this.count,
    required this.controller,
    this.opacity,
  });

  @override
  State<AppPageIndicator> createState() => _AppPageIndicatorState();
}

class _AppPageIndicatorState extends State<AppPageIndicator> {
  final currentPage = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handlePageChanged);
  }

  void _handlePageChanged() {
    currentPage.value = widget.controller.page?.round() ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final data = [];
    for (var i = 0; i < widget.count; i++) {
      data.add(i);
    }
    return ValueListenableBuilder<int>(
      valueListenable: currentPage,
      builder: (_, value, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: data
              .map(
                (item) => buildIndicator(
                  data.indexOf(item) == (value),
                ),
              )
              .toList(),
        );
      },
    ).fadeIn();
  }

  Widget buildIndicator(bool isSelected) {
    return TweenAnimationBuilder<double>(
        tween: Tween(end: isSelected ? 1 : 0),
        curve: Curves.easeIn,
        duration: fastDuration,
        builder: (context, value, _) {
          return AnimatedContainer(
            duration: fastDuration,
            width: 5 + (value * 45),
            height: 5,
            margin: const EdgeInsets.only(
              left: 2,
              right: 2,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: blackShade1Color),
              color: Color.lerp(
                whiteColor.withOpacity(widget.opacity ?? .3),
                whiteColor,
                value,
              ),
              borderRadius: BorderRadius.circular(cornersMedium),
            ),
          );
        });
  }
}
