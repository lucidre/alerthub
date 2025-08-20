import 'package:alerthub/features/event/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/event/data/repositorites/event_repository_impl.dart';
import 'package:alerthub/features/event/domain/usecases/event_service.dart';
import 'package:alerthub/features/event/presentation/controller/healthcare_home_tab_controller.dart';
import 'package:alerthub/common_libs.dart';

import 'package:flutter/services.dart';

class HealthCareHomeTab extends StatefulWidget {
  const HealthCareHomeTab({super.key});
  @override
  State<HealthCareHomeTab> createState() => _HealthCareHomeTabState();
}

class _HealthCareHomeTabState extends State<HealthCareHomeTab> {
  final refreshController = RefreshController(initialRefresh: false);
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.find<UserProfileController>().getUser();

    Get.put(
      HealthCareHomeTabController(
        EventService(
          EventRepositoryImpl(
            EventRemoteDataSource(),
          ),
        ),
      ),
    );
  }

  void onRefresh() async {
    final controller = Get.find<HealthCareHomeTabController>();

    await Future.wait<dynamic>(
      [controller.getNearbyData(), controller.getOngoingData()],
    );
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildBackgroundColor(),
        buildDecore(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAppBar(),
            verticalSpacer16,
            ...buildHeader(),
            verticalSpacer16,
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(space4),
                    topRight: Radius.circular(space4),
                  ),
                ),
                padding: const EdgeInsets.all(space12),
                child: buildBody(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  buildHeader() {
    return [
      Padding(
        padding: const EdgeInsets.only(left: space12, right: space12),
        child: GetX<UserProfileController>(builder: (controller) {
          final user = controller.user;
          return Text(
            'Welcome back ${user?.fullName},',
            style: satoshi500S14.copyWith(color: neutral300),
          );
        }),
      ).fadeInAndMoveFromBottom(),
      Padding(
        padding: const EdgeInsets.only(left: space12, right: space12),
        child: Text(
          'What would you like to do today?',
          style: satoshi600S20.copyWith(color: whiteColor),
        ),
      ).fadeInAndMoveFromBottom(),
    ];
  }

  buildFab() {
    return Positioned(
      bottom: space12,
      right: space12,
      child: FloatingActionButton(
        onPressed: () => context.router.push(CreateEventRoute()),
        backgroundColor: blackShade1Color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(space4),
        ),
        child: const Icon(Icons.add_rounded),
      ).fadeInAndMoveFromBottom(),
    );
  }

  buildBody() {
    return FocusDetector(
      onFocusGained: () {
        final controller = Get.find<HealthCareHomeTabController>();
        controller.getOngoingData();
        controller.getNearbyData();
      },
      child: SmartRefresher(
        enablePullDown: true,
        header: const ClassicHeader(refreshStyle: RefreshStyle.UnFollow),
        onRefresh: () => onRefresh(),
        controller: refreshController,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              buildItem("View users", 'url',
                  () => context.router.push(const HealthCareUserListRoute())),
              verticalSpacer16,
              buildItem("View drivers", 'url',
                  () => context.router.push(const HealthCareDriverListRoute())),
              verticalSpacer16,
              buildItem("View ongoing events", 'url',
                  () => context.router.push(const EventsOngoingRoute())),
              verticalSpacer32 * 3,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(
    String title,
    String url,
    VoidCallback onPressed,
  ) {
    return Container(
      padding: const EdgeInsets.all(space4),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () => onPressed.call(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: blackColor,
                borderRadius: BorderRadius.circular(space4),
                border: Border.all(color: neutral200),
              ),
              child: AppImage(
                imageUrl: url,
              ),
            ),

            //

            Container(
              padding: const EdgeInsets.all(space4),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(space4),
                border: Border.all(color: neutral200),
              ),
              child: Text(title, style: satoshi600S14),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: null,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text(context.localization?.alertHub ?? '',
              style: satoshi600S24.copyWith(color: whiteColor))
          .fadeIn(),
      actions: [
        GetX<UserProfileController>(builder: (controller) {
          final user = controller.user;
          return InkWell(
            splashColor: Colors.transparent,
            onTap: () => Get.find<UserBottomBarController>().goToProfile(),
            child: Container(
              width: 35,
              height: 35,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                  color: blackShade1Color.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(space4),
                  border: Border.all(
                    color: whiteColor,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  )),
              child: user?.imageUrl == null
                  ? null
                  : AppImage(imageUrl: user?.imageUrl),
            ),
          ).fadeInAndMoveFromBottom();
        }),
        horizontalSpacer12,
      ],
    );
  }

  Positioned buildDecore() {
    return Positioned(
      top: -30,
      right: -30,
      child: Opacity(
        opacity: .07,
        child: Image.asset(
          decore,
          height: context.height * .4,
          width: context.height * .4,
        ),
      ).fadeInAndMoveFromTop(),
    );
  }

  Container buildBackgroundColor() {
    return Container(
      width: double.infinity,
      height: context.screenHeight * .7,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            blackShade1Color,
            blackShade1Color,
            blackColor,
          ],
        ),
      ),
    );
  }
}
