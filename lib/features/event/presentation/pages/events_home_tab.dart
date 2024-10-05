import 'package:alerthub/features/event/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/event/data/repositorites/event_repository_impl.dart';
import 'package:alerthub/features/event/domain/usecases/event_service.dart';
import 'package:alerthub/features/event/presentation/controller/events_home_tab_controller.dart';
import 'package:alerthub/features/event/presentation/widget/events_nearby_home_item.dart';
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/event/presentation/widget/events_ongoing_home_item.dart';

import 'package:flutter/services.dart';

class EventsHomeTab extends StatefulWidget {
  const EventsHomeTab({super.key});
  @override
  State<EventsHomeTab> createState() => _EventsHomeTabState();
}

class _EventsHomeTabState extends State<EventsHomeTab> {
  final refreshController = RefreshController(initialRefresh: false);
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.find<UserProfileController>().getUser();

    Get.put(
      EventsHomeTabController(
        EventService(
          EventRepositoryImpl(
            EventRemoteDataSource(),
          ),
        ),
      ),
    );
  }

  void onRefresh() async {
    final controller = Get.find<EventsHomeTabController>();

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
            '${context.localization?.hello ?? ''} ${user?.fullName},',
            style: satoshi500S14.copyWith(color: neutral300),
          );
        }),
      ).fadeInAndMoveFromBottom(),
      Padding(
        padding: const EdgeInsets.only(left: space12, right: space12),
        child: Text(
          context.localization?.discoverEvents ?? '',
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
        final controller = Get.find<EventsHomeTabController>();
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
              buildSearchField().fadeInAndMoveFromBottom(),
              verticalSpacer16,
              const EventsNearbyHomeItem(),
              verticalSpacer16,
              const EventsOngoingHomeItem(),
              verticalSpacer32 * 3
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchField() {
    return TextFormField(
      controller: searchController,
      textInputAction: TextInputAction.search,
      decoration: context.inputDecoration(
        hintText: context.localization?.searchEventNameOrLocation ?? '',
      ),
      keyboardType: TextInputType.name,
      onFieldSubmitted: (search) {
        context.router.push(EventSearchRoute(search: search));
        searchController.text = '';
        FocusScope.of(context).unfocus();
      },
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
