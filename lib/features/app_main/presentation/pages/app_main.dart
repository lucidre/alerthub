import 'package:alerthub/features/event/presentation/pages/events_home_tab.dart';
import 'package:alerthub/features/event/presentation/pages/events_map_tab.dart';
import 'package:alerthub/features/user/presentation/pages/user_profile_tab.dart';
import 'package:alerthub/shared/models/bottom_bar/bottom_bar.dart';
import 'package:alerthub/shared/widgets/bottom_nav.dart';
import 'package:alerthub/common_libs.dart';
import 'package:flutter/cupertino.dart';

@RoutePage()
class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  final pageController = PageController();

  final pages = [
    const EventsHomeTab(),
    const EventsMapTab(),
    const UserProfileTab(),
  ];

  StreamSubscription<int>? positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    Get.put(BottomBarController());
    Future.delayed(Duration.zero, () {
      positionStreamSubscription?.cancel();
      positionStreamSubscription =
          Get.find<BottomBarController>().indexRx.listen((index) {
        pageController.animateToPage(
          index,
          duration: fastDuration,
          curve: Curves.easeIn,
        );
      });
    });
  }

  @override
  void dispose() {
    //closing stream to prevent it from firing when the screen has been disposed.
    positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      floatingActionButton: buildFloatingActinoButton(),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  buildBody() {
    return PageView.builder(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) => pages[index],
    );
  }

  buildBottomBar() {
    final bottomBarModels = [
      BottomBarModel(
          title: context.localization?.home ?? '', icon: CupertinoIcons.home),
      BottomBarModel(
          title: context.localization?.map ?? '', icon: CupertinoIcons.map),
      BottomBarModel(
          title: context.localization?.profile ?? '',
          icon: CupertinoIcons.profile_circled),
    ];
    return GetX<BottomBarController>(builder: (controller) {
      final index = controller.index;

      return AppBottomNavigationBar(
        bottomBarModels: bottomBarModels,
        currentIndex: index,
        onTap: (index) {
          Get.find<BottomBarController>().setIndex(index);
        },
      );
    });
  }

  buildFloatingActinoButton() {
    return GetX<BottomBarController>(builder: (controller) {
      final index = controller.index;
      return TweenAnimationBuilder<double>(
          tween: Tween(
            end: index == 0 ? 1.0 : 0.0,
          ),
          curve: Curves.easeIn,
          duration: medDuration,
          builder: (context, value, _) {
            return Transform.translate(
              offset: Offset(0, (1 - value) * 15),
              child: IgnorePointer(
                ignoring: index != 0,
                child: Opacity(
                  opacity: value > .5 ? 1 : value,
                  child: FloatingActionButton(
                    onPressed: () => context.router.push(CreateEventRoute()),
                    backgroundColor: blackShade1Color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(space4),
                    ),
                    child: const Icon(Icons.add_rounded),
                  ),
                ),
              ),
            );
          });
    });
  }
}
