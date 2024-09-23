import 'package:alerthub/common_libs.dart';

class MapEventItem extends StatelessWidget {
  const MapEventItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      margin: const EdgeInsets.only(
        left: space12,
        right: space12,
        bottom: space32 + space12,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: neutral200),
        color: context.backgroundColor,
        borderRadius: BorderRadius.circular(cornersSmall),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildFirstSection(),
          verticalSpacer12,
          buildSecondSection(context),
          verticalSpacer12,
          AppBtn.from(
            onPressed: () {
              // context.router.push(const EventDetailsRoute());
            },
            text: 'View Event',
          ),
        ],
      ),
    );
  }

  Container buildSecondSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        border: Border.all(color: neutral200),
        color: whiteColor,
        borderRadius: BorderRadius.circular(cornersSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loremIspidiumTitle, style: satoshi600S14)
              .fadeInAndMoveFromBottom(delay: slowDuration),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Text(
            loremIspidiumMassive,
            style: satoshi500S12,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ).fadeInAndMoveFromBottom(delay: slowDuration),
          verticalSpacer12,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Location",
                style: satoshi600S12,
              ),
              horizontalSpacer12,
              Expanded(
                child: Text(
                  loremIspidiumTitle,
                  style: satoshi500S12,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ).fadeInAndMoveFromBottom(delay: slowDuration),
          verticalSpacer12,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Timeline",
                style: satoshi600S12,
              ),
              horizontalSpacer12,
              Expanded(
                child: Text(
                  "24 hours",
                  style: satoshi500S12,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ).fadeInAndMoveFromBottom(delay: slowDuration),
          verticalSpacer12,
          Row(
            children: [
              Text(
                "Community Validification",
                style: satoshi600S12,
              ),
              horizontalSpacer12,
              const Spacer(),
              const Icon(
                Icons.thumb_up_alt_rounded,
                color: primary800,
                size: 14,
              ),
              horizontalSpacer4,
              Text(
                '(20)',
                style: satoshi500S12.copyWith(color: primary800),
              ),
              horizontalSpacer8,
              const Icon(
                Icons.thumb_down_alt_rounded,
                color: destructive700,
                size: 14,
              ),
              horizontalSpacer4,
              Text(
                '(15)',
                style: satoshi500S12.copyWith(color: destructive700),
              ),
            ],
          ).fadeInAndMoveFromBottom(delay: slowDuration),
        ],
      ),
    );
  }

  Container buildFirstSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: neutral300),
        color: whiteColor,
        borderRadius: BorderRadius.circular(cornersSmall),
      ),
      child: AspectRatio(
        aspectRatio: 2,
        child: Stack(
          children: [
            buildImage().fadeIn(delay: slowDuration),
            Positioned(
              right: space6,
              top: space6,
              child: buildPriority().fadeIn(delay: slowDuration),
            ),
            Positioned(
              right: space6,
              left: space6,
              bottom: space6,
              child: buildIndicator().fadeIn(delay: slowDuration),
            ),
          ],
        ),
      ),
    );
  }

  Container buildImage() {
    return Container(
      decoration: BoxDecoration(
        color: blackColor.withOpacity(.1),
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
    );
  }

  Container buildPriority() {
    return Container(
      padding: const EdgeInsets.all(space6),
      decoration: BoxDecoration(
        color: destructive100,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: destructive300),
      ),
      child: Text(
        'HIGH PRIORITY',
        style: satoshi600S12.copyWith(color: destructive600),
      ),
    );
  }

  Center buildIndicator() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: blackColor.withOpacity(.3),
              borderRadius: BorderRadius.circular(space4),
            ),
          ),
          horizontalSpacer4,
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: blackColor.withOpacity(.8),
              borderRadius: BorderRadius.circular(space4),
            ),
          ),
          horizontalSpacer4,
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: blackColor.withOpacity(.3),
              borderRadius: BorderRadius.circular(space4),
            ),
          ),
          horizontalSpacer4,
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: blackColor.withOpacity(.3),
              borderRadius: BorderRadius.circular(space4),
            ),
          ),
          horizontalSpacer4,
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: blackColor.withOpacity(.3),
              borderRadius: BorderRadius.circular(space4),
            ),
          ),
        ],
      ),
    );
  }
}
