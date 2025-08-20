import 'package:alerthub/features/event/presentation/pages/user_home_tab.dart';
import 'package:alerthub/features/event/presentation/pages/user_map_tab.dart';
import 'package:alerthub/features/informations/presentation/pages/information_tab.dart';
import 'package:alerthub/features/user/presentation/pages/user_profile_tab.dart';
import 'package:alerthub/shared/models/bottom_bar/bottom_bar.dart';
import 'package:alerthub/shared/widgets/bottom_nav.dart';
import 'package:alerthub/common_libs.dart';
import 'package:flutter/cupertino.dart';

@RoutePage()
class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  final pageController = PageController();

  final pages = [
    const UserHomeTab(),
    const UsersMapTab(),
    const InformationTab(),
    const UserProfileTab(),
  ];

  StreamSubscription<int>? positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    Get.put(UserBottomBarController());
    Future.delayed(Duration.zero, () {
      positionStreamSubscription?.cancel();
      positionStreamSubscription =
          Get.find<UserBottomBarController>().indexRx.listen((index) {
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
      BottomBarModel(title: 'Information', icon: CupertinoIcons.info_circle),
      BottomBarModel(
          title: context.localization?.profile ?? '',
          icon: CupertinoIcons.profile_circled),
    ];
    return GetX<UserBottomBarController>(builder: (controller) {
      final index = controller.index;

      return AppBottomNavigationBar(
        bottomBarModels: bottomBarModels,
        currentIndex: index,
        onTap: (index) => Get.find<UserBottomBarController>().setIndex(index),
      );
    });
  }

  buildFloatingActinoButton() {
    return GetX<UserBottomBarController>(builder: (controller) {
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
