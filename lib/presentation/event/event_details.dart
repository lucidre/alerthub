import 'package:alerthub/common_libs.dart';

@RoutePage()
class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(space12),
          child: Column(
            children: [
              buildImage(),
              verticalSpacer16,
              buildPriority(),
              verticalSpacer16,
              buildLocation(),
              verticalSpacer16,
              buildAvailiablility(),
              verticalSpacer16,
              buildValidity(),
              verticalSpacer16,
              buildDescription(),
              verticalSpacer32 * 3
            ],
          ),
        ),
      ),
    );
  }

  Container buildImage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 2,
            child: Container(
              decoration: BoxDecoration(
                color: blackColor.withOpacity(.1),
                borderRadius: BorderRadius.circular(space4),
                border: Border.all(color: neutral200),
              ),
            ),
          ),
          verticalSpacer12,
          Row(
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
        ],
      ),
    );
  }

  Widget buildDescription() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Text(
            loremIspidiumMassive,
            style: satoshi500S12,
          ).fadeInAndMoveFromBottom(),
        ],
      ),
    ).fadeInAndMoveFromBottom();
  }

  Widget buildLocation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Text(
            loremIspidiumTitle,
            style: satoshi500S12,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          AppBtn.from(
            onPressed: () {},
            text: 'View on map',
            expand: true,
          ),
        ],
      ),
    ).fadeInAndMoveFromBottom();
  }

  Widget buildAvailiablility() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Availiablity',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Text(
            '24 hours',
            style: satoshi500S12,
          ).fadeInAndMoveFromBottom(),
        ],
      ),
    ).fadeInAndMoveFromBottom();
  }

  Widget buildValidity() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Validity',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(space12),
                  decoration: BoxDecoration(
                    color: primary100,
                    borderRadius: BorderRadius.circular(space4),
                    border: Border.all(color: primary200),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.thumb_up_alt_rounded,
                        color: primary800,
                      ),
                      Text(
                        '20 users voted accurate',
                        style: satoshi500S12.copyWith(color: primary800),
                      ).fadeInAndMoveFromBottom(),
                    ],
                  ),
                ),
              ),
              horizontalSpacer12,
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(space12),
                  decoration: BoxDecoration(
                    color: destructive100,
                    borderRadius: BorderRadius.circular(space4),
                    border: Border.all(color: destructive200),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.thumb_down_alt_rounded,
                        color: destructive700,
                      ),
                      Text(
                        '10 users voted inaccurate',
                        style: satoshi500S12.copyWith(color: destructive700),
                      ).fadeInAndMoveFromBottom(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          verticalSpacer12,
          AppBtn.from(
            onPressed: () {},
            text: 'Vote',
            expand: true,
          ),
        ],
      ),
    ).fadeInAndMoveFromBottom();
  }

  Widget buildPriority() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: destructive100,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: destructive300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Priority (HIGH)',
            style: satoshi600S14.copyWith(color: destructive600),
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Text(
            loremIspidiumLong,
            style: satoshi500S12.copyWith(color: destructive500),
          ).fadeInAndMoveFromBottom(),
        ],
      ),
    ).fadeInAndMoveFromBottom();
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text(loremIspidiumTitle, style: satoshi600S24).fadeIn(),
    );
  }
}
