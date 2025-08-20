import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/panic/presentation/controller/panic_controller.dart';

///App Scaaffold
class AppScaffold extends StatelessWidget {
  final Widget body;
  final bool enableInternetCheck;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final List<Widget> bannerActions;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.bannerActions = const [],
    this.enableInternetCheck = true,
  });

  buildPanicItem1() {
    return GetX<PanicController>(builder: (controller) {
      final isInAlert = controller.isInAlert;

      return AnimatedBuilder(
        animation: controller
            .pulseAnimation, // You'll need to add this to PanicController
        builder: (context, child) {
          // Calculate pulsating color opacity (0.3 to 1.0)
          final pulseOpacity =
              isInAlert ? 0.3 + (0.7 * controller.pulseAnimation.value) : 1.0;

          return AnimatedContainer(
            duration: medDuration,
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(space12),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                width: isInAlert ? 1 + (pulseOpacity.clamp(0, 1) * 3) : 1,
                color: isInAlert
                    ? destructive700.withValues(alpha: pulseOpacity)
                    : neutral200,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor ?? context.backgroundColor,
      body: GetX<ConnectionStatusController>(
        builder: (controller) {
          return Stack(
            children: [
              buildPanicItem1(),
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: body,
              ),
              Positioned(
                left: 0,
                right: 0,
                top: appBar == null ? (context.top + 10) : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!controller.hasConnection && enableInternetCheck) ...[
                      buildNetworkWidget(context),
                      verticalSpaceMedium,
                    ],
                    if (bannerActions.isNotEmpty)
                      for (final banner in bannerActions) ...[
                        banner,
                        verticalSpaceMedium,
                      ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }

  Widget buildNetworkWidget(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(kDefaultPadding / 4),
        margin: const EdgeInsets.only(
          left: kDefaultMargin / 4,
          right: kDefaultMargin / 4,
        ),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(.5),
          borderRadius: BorderRadius.circular(cornersSmall),
        ),
        child: Row(
          children: [
            Text(
              context.localization?.noNetworkConnection ?? "",
              style: satoshi500S14.copyWith(
                  color: shadeWhite, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            const Icon(
              Icons.warning_rounded,
              color: shadeWhite,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
