import 'package:alerthub/common_libs.dart';
import 'package:flutter/cupertino.dart';

class EventTab extends StatefulWidget {
  const EventTab({super.key});

  @override
  State<EventTab> createState() => _EventTabState();
}

class _EventTabState extends State<EventTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(space12),
      child: Column(
        children: [
          buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildLiveView(),
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
            ),
          ),
        ],
      ),
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
        context.router.push(const EventDetailsRoute());
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

  Widget buildLiveView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        border: Border.all(color: neutral200),
        color: shadeWhite,
        borderRadius: BorderRadius.circular(cornersSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Live View', style: satoshi600S14),
              const Spacer(),
              const Icon(
                Icons.open_in_new_rounded,
                size: 18,
              )
            ],
          ),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: neutral200),
              color: shadeWhite,
              borderRadius: BorderRadius.circular(cornersSmall),
            ),
            child: Image.asset(
              'assets/images/map.jpeg',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ).fadeInAndMoveFromBottom(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: null,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text('Events', style: satoshi600S24).fadeIn(),
    );
  }
}
