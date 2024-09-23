import 'package:alerthub/common_libs.dart';
import 'package:alerthub/helpers/bottom_nav.dart';
import 'package:alerthub/models/bottom_bar.dart';
import 'package:alerthub/presentation/main/tabs/map/map_tab.dart';
import 'package:alerthub/presentation/main/tabs/home/home_tab.dart';
import 'package:alerthub/presentation/main/tabs/profile/profile_tab.dart';

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final controller = PageController();
  int index = 0;
  final pages = [
    const HomeTab(),
    const MapTab(),
    const ProfileTab(),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      enableInternetCheck: false, // TODO remove.
      floatingActionButton: buildFAB(),
      body: buildBody(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  buildBody() {
    return PageView.builder(
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) => pages[index],
    );
  }

  buildBottomBar() {
    return BottomNavBar(
      items: barItems,
      currentIndex: index,
      onTap: (index) {
        controller.animateToPage(
          index,
          duration: fastDuration,
          curve: Curves.easeIn,
        );
        setState(() {
          this.index = index;
        });
      },
    );
  }

  buildFAB() {
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
                  onPressed: () =>
                      context.router.push(const CreateEventRoute()),
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
  }
}
