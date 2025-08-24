import 'package:alerthub/features/hospitals/presentation/pages/healthcare_home_tab.dart';
import 'package:alerthub/features/hospitals/presentation/pages/healthcare_map_tab.dart';
import 'package:alerthub/features/user/presentation/pages/user_profile_tab.dart';
import 'package:alerthub/shared/models/bottom_bar/bottom_bar.dart';
import 'package:alerthub/shared/widgets/bottom_nav.dart';
import 'package:alerthub/common_libs.dart';
import 'package:flutter/cupertino.dart';

@RoutePage()
class HealthCareMainScreen extends StatefulWidget {
  const HealthCareMainScreen({super.key});

  @override
  State<HealthCareMainScreen> createState() => _HealthCareMainScreenState();
}

class _HealthCareMainScreenState extends State<HealthCareMainScreen> {
  final pageController = PageController();

  final pages = [
    const HealthCareHomeTab(),
    const HealthCareMapTab(),
    const UserProfileTab(),
  ];

  StreamSubscription<int>? positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    Get.put(HealthCareBottomBarController());
    Future.delayed(Duration.zero, () {
      positionStreamSubscription?.cancel();
      positionStreamSubscription =
          Get.find<HealthCareBottomBarController>().indexRx.listen((index) {
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
    positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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

    return GetX<HealthCareBottomBarController>(builder: (controller) {
      final index = controller.index;
      return AppBottomNavigationBar(
        bottomBarModels: bottomBarModels,
        currentIndex: index,
        onTap: (index) =>
            Get.find<HealthCareBottomBarController>().setIndex(index),
      );
    });
  }
}
