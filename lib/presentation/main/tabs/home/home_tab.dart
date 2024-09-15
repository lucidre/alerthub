import 'package:alerthub/common_libs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
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
            GestureDetector(
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
            ),
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

  buildHeader() {
    return [
      Padding(
        padding: const EdgeInsets.only(left: space12, right: space12),
        child: Text(
          'Hello Oti Temiitope,',
          style: satoshi500S14.copyWith(color: neutral300),
        ),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          buildSearchField().fadeInAndMoveFromBottom(),
          verticalSpacer16,
          Container(
            padding: const EdgeInsets.all(space12),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(space4),
              border: Border.all(color: neutral200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Happening Now',
                    style: satoshi600S12,
                  ),
                ),
                horizontalSpacer12,
                AppBtn.basic(
                  onPressed: () {},
                  child: Text(
                    'See all',
                    style: satoshi500S12,
                  ),
                )
              ],
            ),
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(space12),
                  margin: const EdgeInsets.only(right: space12),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(space4),
                    border: Border.all(color: neutral200),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(space12),
                  margin: const EdgeInsets.only(right: space12),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(space4),
                    border: Border.all(color: neutral200),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(space12),
                  margin: const EdgeInsets.only(right: space12),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(space4),
                    border: Border.all(color: neutral200),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(space12),
                  margin: const EdgeInsets.only(right: space12),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(space4),
                    border: Border.all(color: neutral200),
                  ),
                ),
              ],
            ),
          ).fadeInAndMoveFromBottom(),
          verticalSpacer16,
          Container(
            padding: const EdgeInsets.all(space12),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(space4),
              border: Border.all(color: neutral200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Happening Now',
                    style: satoshi600S12,
                  ),
                ),
                horizontalSpacer12,
                AppBtn.basic(
                  onPressed: () {},
                  child: Text(
                    'See all',
                    style: satoshi500S12,
                  ),
                )
              ],
            ),
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(space12),
                  margin: const EdgeInsets.only(right: space12),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(space4),
                    border: Border.all(color: neutral200),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(space12),
                  margin: const EdgeInsets.only(right: space12),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(space4),
                    border: Border.all(color: neutral200),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(space12),
                  margin: const EdgeInsets.only(right: space12),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(space4),
                    border: Border.all(color: neutral200),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(space12),
                  margin: const EdgeInsets.only(right: space12),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(space4),
                    border: Border.all(color: neutral200),
                  ),
                ),
              ],
            ),
          ).fadeInAndMoveFromBottom(),
          verticalSpacer16,
          Container(
            padding: const EdgeInsets.all(space12),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(space4),
              border: Border.all(color: neutral200),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Happening Now',
                        style: satoshi600S12,
                      ),
                    ),
                    horizontalSpacer12,
                    AppBtn.basic(
                      onPressed: () {},
                      child: Text(
                        'See all',
                        style: satoshi500S12,
                      ),
                    )
                  ],
                ),
                verticalSpacer16,
                context.divider,
                verticalSpacer16,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(space12),
                        margin: const EdgeInsets.only(right: space12),
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(space4),
                          border: Border.all(color: neutral200),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(space12),
                        margin: const EdgeInsets.only(right: space12),
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(space4),
                          border: Border.all(color: neutral200),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(space12),
                        margin: const EdgeInsets.only(right: space12),
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(space4),
                          border: Border.all(color: neutral200),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(space12),
                        margin: const EdgeInsets.only(right: space12),
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(space4),
                          border: Border.all(color: neutral200),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).fadeInAndMoveFromBottom(),
        ],
      ),
    );
  }

  Widget buildSearchField() {
    return InkWell(
      onTap: () {
        context.router.push(const SearchRoute());
      },
      child: IgnorePointer(
        ignoring: true,
        child: TextFormField(
          textInputAction: TextInputAction.search,
          decoration:
              context.inputDecoration(hintText: "Search event or location"),
          keyboardType: TextInputType.name,
          // controller: searchController,
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
      title: Text('AlertHub', style: satoshi600S24.copyWith(color: whiteColor))
          .fadeIn(),
      actions: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: whiteColor,
          ),
        ),
        horizontalSpacer12,
      ],
    );
  }

  Container buildBackgroundColor() {
    return Container(
      width: double.infinity,
      height: context.screenHeight * .6,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFF333333),
            Color(0xFF2C2929),
          ],
        ),
      ),
    );
  }
}
