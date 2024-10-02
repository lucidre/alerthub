import 'package:alerthub/common_libs.dart';
import 'package:alerthub/helpers/page_indicator.dart';
import 'package:alerthub/models/event/event.dart';

@RoutePage()
class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final pageController = PageController();
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
              buildDescription(),
              verticalSpacer16,
              buildPriority(),
              verticalSpacer16,
              buildLocation(),
              verticalSpacer16,
              buildAvailiablility(),
              verticalSpacer16,
              buildValidity(),
              verticalSpacer32 * 3
            ],
          ),
        ),
      ),
    );
  }

  Container buildImage() {
    final images = widget.event.images ?? [];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space4),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: AspectRatio(
        aspectRatio: 2,
        child: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: images.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (ctx, index) {
                return Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: const EdgeInsets.all(space4),
                    decoration: BoxDecoration(
                      color: blackColor.withOpacity(.1),
                      borderRadius: BorderRadius.circular(space4),
                      border: Border.all(
                        color: neutral200,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                    child: AppImage(
                      imageUrl: images[index],
                      fit: BoxFit.cover,
                    ));
              },
            ),
            Positioned(
              right: space6,
              left: space6,
              bottom: space12,
              child: Center(
                child: AppPageIndicator(
                    count: (widget.event.images ?? []).length,
                    controller: pageController,
                    color: blackShade1Color),
              ).fadeIn(delay: slowDuration),
            ),
          ],
        ),
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
            widget.event.description ?? '',
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
            widget.event.location ?? '',
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
            widget.event.availiablity ?? '',
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
                        '${widget.event.upVote ?? 0} users voted accurate',
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
                        '${widget.event.downVote ?? 0} users voted inaccurate',
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
        color: widget.event.priority?.backgroundColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(
          color: widget.event.priority?.borderColor ?? neutral300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Priority (${widget.event.priority?.name.toUpperCase()})',
            style:
                satoshi600S14.copyWith(color: widget.event.priority?.textColor),
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Text(
            widget.event.priority?.userDescription ?? '',
            style: satoshi500S12.copyWith(color: widget.event.priority?.color2),
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
      title: Text(widget.event.name ?? '', style: satoshi600S24).fadeIn(),
    );
  }
}
