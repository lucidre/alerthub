import 'package:alerthub/features/user/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/user/data/repositorites/user_repository_impl.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/features/user/presentation/controller/user_tab_controller.dart';
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/user/presentation/widget/user_posted_events.dart';
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
    await Future.wait<dynamic>(
      [
        controller.getUpcData(),
        controller.getUpData(),
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
      title: Text(context.localization?.profile ?? '', style: satoshi600S24)
          .fadeIn(),
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      actions: [
        IconButton(
          onPressed: () {
            context.router.push(const NotificationsRoute());
          },
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
