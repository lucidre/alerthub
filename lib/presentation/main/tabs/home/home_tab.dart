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
                    'Near You',
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
                eventCard2(),
                eventCard2(),
                eventCard2(),
                eventCard2(),
                eventCard2(),
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
                    'Ongoing Events',
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
                buildFilter('All Locations'),
                buildFilter('Ojota'),
                buildFilter('Costain'),
                buildFilter('Maryland'),
                buildFilter('Ketu'),
                buildFilter('Mile 12'),
              ],
            ),
          ),
          verticalSpacer12,
          eventCard().fadeInAndMoveFromBottom(),
          verticalSpacer12,
          eventCard().fadeInAndMoveFromBottom(),
          verticalSpacer12,
          eventCard().fadeInAndMoveFromBottom(),
          verticalSpacer12,
          eventCard().fadeInAndMoveFromBottom(),
          verticalSpacer12,
          eventCard().fadeInAndMoveFromBottom(),
          verticalSpacer12,
          verticalSpacer12,
          verticalSpacer32 * 3
        ],
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

  Container eventCard2() {
    return Container(
      padding: const EdgeInsets.all(space12),
      margin: const EdgeInsets.only(right: space12),
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 300,
            height: 150,
            decoration: BoxDecoration(
              color: blackShade1Color.withOpacity(.1),
              borderRadius: BorderRadius.circular(space4),
            ),
          ),
          verticalSpacer12,
          Text(loremIspidiumTitle, style: satoshi600S14),
          verticalSpacer8,
          Expanded(
            child: Text(
              loremIspidiumLong,
              style: satoshi500S12,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          verticalSpacer8,
          Text(
            'Ojota Axis',
            style: satoshi500S12,
            overflow: TextOverflow.ellipsis,
          ),
          verticalSpacer8,
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'High Priority',
              style: satoshi600S12.copyWith(color: destructive600),
            ),
          ),
        ],
      ),
    );
  }

  Widget eventCard() {
    return InkWell(
      onTap: () {
        // context.router.push(const EventDetailsRoute());
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(space12),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(space4),
          border: Border.all(color: neutral200),
        ),
        child: Row(
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: blackShade1Color.withOpacity(.1),
                borderRadius: BorderRadius.circular(space4),
              ),
            ),
            horizontalSpacer12,
            Expanded(
                child: SizedBox(
              height: 110,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loremIspidiumTitle, style: satoshi600S14),
                  verticalSpacer8,
                  Text(
                    loremIspidiumLong,
                    style: satoshi500S12,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  verticalSpacer8,
                  Expanded(
                    child: Text(
                      'Ojota Axis',
                      style: satoshi500S12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  verticalSpacer8,
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'High Priority',
                      style: satoshi600S12.copyWith(color: destructive600),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
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
            Color(0xFF333333),
            Color(0xFF2C2929),
          ],
        ),
      ),
    );
  }
}
