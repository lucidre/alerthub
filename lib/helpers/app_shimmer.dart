import 'package:shimmer/shimmer.dart';
import 'package:alerthub/common_libs.dart';

class AppShimmer extends StatelessWidget {
  final bool shimmerEnabled;
  final Color? shimmerColor;
  final Widget child;

  const AppShimmer(
      {Key? key,
      required this.shimmerEnabled,
      required this.child,
      this.shimmerColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return shimmerEnabled
        ? Shimmer.fromColors(
            baseColor: shimmerColor?.withOpacity(.9) ??
                context.textColor.withOpacity(0.1),
            highlightColor: shimmerColor?.withOpacity(.4) ??
                context.textColor.withOpacity(0.2),
            child: child,
          )
        : child;
  }
}

class ShimmerItem extends StatelessWidget {
  final double? width;
  final double? height;
  final double? radius;
  const ShimmerItem({super.key, this.width, this.height, this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? space12,
      decoration: BoxDecoration(
          color: primary600,
          borderRadius: BorderRadius.circular(radius ?? space4)),
    );
  }
}
