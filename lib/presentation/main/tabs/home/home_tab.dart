import 'package:alerthub/common_libs.dart';
import 'package:alerthub/presentation/main/tabs/home/home_nearby_section.dart';
import 'package:alerthub/presentation/main/tabs/home/home_ongoing_events_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    Get.find<HomeController>().getUser();
  }

  void onRefresh() async {
    final controller = Get.find<HomeController>();

    await Future.wait<dynamic>(
      [
        controller.getNearbyData(),
        controller.getOngoingData(),
      ],
    );
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildBackgroundColor(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAppBar(),
            verticalSpacer16,
            ...buildHeader(),
            verticalSpacer16,
            buildAlertModeButton(),
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
        // buildFab()
      ],
    );
  }

  GestureDetector buildAlertModeButton() {
    return GestureDetector(
      onTap: () => context.router.push(const AlertModeRoute()),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(space12),
        margin: const EdgeInsets.only(left: space12, right: space12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(space4),
          border: Border.all(
            color: destructive600,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'ALERT MODE',
              style: satoshi600S14.copyWith(color: destructive600),
            ),
            horizontalSpacer8,
            const Icon(
              CupertinoIcons.exclamationmark_triangle_fill,
              color: destructive600,
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  buildHeader() {
    return [
      Padding(
        padding: const EdgeInsets.only(left: space12, right: space12),
        child: GetX<HomeController>(builder: (controller) {
          final user = controller.user;
          return Text(
            'Hello ${user?.fullName},',
            style: satoshi500S14.copyWith(color: neutral300),
          );
        }),
      ).fadeInAndMoveFromBottom(),
      Padding(
        padding: const EdgeInsets.only(left: space12, right: space12),
        child: Text(
          'Discover events around you.',
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
        onPressed: () => context.router.push(const CreateEventRoute()),
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
        Get.find<HomeController>().getOngoingData();
        Get.find<HomeController>().getNearbyData();
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
              buildSearchField().fadeInAndMoveFromBottom(),
              verticalSpacer16,
              const HomeNearBySection(),
              verticalSpacer16,
              const HomeOngoingEventsSection(),
              verticalSpacer32 * 3
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchField() {
    return TextFormField(
      textInputAction: TextInputAction.search,
      decoration: context.inputDecoration(
        hintText: "Search event name or location",
      ),
      keyboardType: TextInputType.name,
      onFieldSubmitted: (search) {
        context.router.push(SearchRoute(search: search));
      },

      // controller: searchController,
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
      title: Text('AlertHub', style: satoshi600S24.copyWith(color: whiteColor))
          .fadeIn(),
      actions: [
        GetX<HomeController>(builder: (controller) {
          final user = controller.user;
          return InkWell(
            splashColor: Colors.transparent,
            onTap: () => Get.find<BottomBarController>().goToProfile(),
            child: Container(
              width: 35,
              height: 35,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                  color: blackShade1Color.withOpacity(.1),
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

  buildFilter(String text) {
    return Container(
      margin: const EdgeInsets.only(right: space8),
      padding: const EdgeInsets.all(space8),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: Text(
        text,
        style: satoshi500S14,
      ),
    );
  }

  Container buildBackgroundColor() {
    return Container(
      width: double.infinity,
      height: context.screenHeight * .6,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFF2C2929),
            Color(0xFF333333),
            blackColor,
          ],
        ),
      ),
    );
  }
}
