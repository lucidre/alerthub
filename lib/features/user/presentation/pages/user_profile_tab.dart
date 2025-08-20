import 'package:alerthub/features/user/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/user/data/repositorites/user_repository_impl.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/features/user/presentation/bars/emergency_information_bar.dart';
import 'package:alerthub/features/user/presentation/controller/user_tab_controller.dart';
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/user/presentation/widget/user_profile_card.dart';

class UserProfileTab extends StatefulWidget {
  const UserProfileTab({super.key});

  @override
  State<UserProfileTab> createState() => _UserProfileTabState();
}

class _UserProfileTabState extends State<UserProfileTab> {
  final refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    Get.put(
      UserTabController(
        UserService(
          UserRepositoryImpl(
            UserRemoteDataSource(),
          ),
        ),
      ),
    );
  }

  void onRefresh() async {
    final controller = Get.find<UserTabController>();
    await controller.getUpcData();
    refreshController.refreshCompleted();
  }

  buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: null,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Text(context.localization?.profile ?? '', style: satoshi600S24)
          .fadeIn(),
      centerTitle: false,
      backgroundColor: context.backgroundColor,
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
            child: ListView(
              padding: const EdgeInsets.all(0),
              physics: const BouncingScrollPhysics(),
              children: [
                const UserProfileCard().fadeInAndMoveFromBottom(),
                verticalSpacer12,
                buildItem(
                  icon: Icons.info_rounded,
                  title: 'Emergency information',
                  onPressed: () => context.showBottomBar(
                    child: const EmergencyInformationBar(),
                  ),
                ),
                buildItem(
                  icon: Icons.sos_rounded,
                  title: 'Emergency contact',
                  onPressed: () => context.router.push(
                    const UserEmergencyContactRoute(),
                  ),
                ),
                buildItem(
                    icon: Icons.local_hospital_rounded,
                    title: 'Registered healthcare',
                    onPressed: () {}),
                buildItem(
                  icon: Icons.event_rounded,
                  title: 'Posted events',
                  onPressed: () => context.router.push(
                    const UserPostedEventsRoute(),
                  ),
                ),
                buildItem(
                  icon: Icons.notifications_active_outlined,
                  title: 'Notifications',
                  onPressed: () =>
                      context.router.push(const NotificationsRoute()),
                ),
                buildItem(
                  icon: Icons.settings_rounded,
                  title: 'Settings',
                  onPressed: () => context.router.push(const SettingsRoute()),
                ),
                //TODO REMOVE.
                buildItem(
                  icon: Icons.settings_rounded,
                  title: 'HealthCare',
                  onPressed: () =>
                      context.router.push(const HealthCareMainRoute()),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildItem({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: space12,
        right: space12,
        left: space12,
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () => onPressed.call(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(space12),
          decoration: BoxDecoration(
            border: Border.all(color: neutral200),
            color: shadeWhite,
            borderRadius: BorderRadius.circular(cornersSmall),
          ),
          child: Row(
            children: [
              Icon(icon),
              horizontalSpacer12,
              Expanded(
                child: Text(
                  title,
                  style: satoshi500S14,
                ),
              ),
              horizontalSpacer12,
              const Icon(Icons.arrow_right_rounded),
            ],
          ),
        ),
      ).fadeInAndMoveFromBottom(),
    );
  }
}
