import 'package:alerthub/common_libs.dart';
import 'package:alerthub/presentation/main/tabs/profile/user_posted_events.dart';
import 'package:alerthub/presentation/main/tabs/profile/user_profile_card.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final refreshController = RefreshController(initialRefresh: false);

  void onRefresh() async {
    final controller = Get.find<ProfileController>();

    await Future.wait<dynamic>(
      [
        controller.getUpData(),
        controller.getUpcData(),
      ],
    );
    refreshController.refreshCompleted();
  }

  buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: null,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Text('Profile', style: satoshi600S24).fadeIn(),
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_active_outlined,
          ),
        ),
        IconButton(
          onPressed: () => context.router.push(const SettingsRoute()),
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildAppBar(),
        Expanded(
          child: SmartRefresher(
            enablePullDown: true,
            header: const ClassicHeader(refreshStyle: RefreshStyle.UnFollow),
            onRefresh: () => onRefresh(),
            controller: refreshController,
            child: Column(
              children: [
                const UserProfileCard().fadeInAndMoveFromBottom(),
                verticalSpacer16,
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: space12,
                      right: space12,
                    ),
                    child: UserPostedEvents(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
