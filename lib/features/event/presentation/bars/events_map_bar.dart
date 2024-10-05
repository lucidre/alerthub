import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/shared/widgets/page_indicator.dart';

class EventsMapBar extends StatefulWidget {
  final Event event;
  const EventsMapBar({super.key, required this.event});

  @override
  State<EventsMapBar> createState() => _EventsMapBarState();
}

class _EventsMapBarState extends State<EventsMapBar> {
  final pageController = PageController();

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
      child: buildBody(),
    );
  }

  Column buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildFirstSection(),
        verticalSpacer12,
        buildSecondSection(),
        verticalSpacer12,
        buildViewEventButton(),
      ],
    );
  }

  AppBtn buildViewEventButton() {
    return AppBtn.from(
      onPressed: () =>
          context.router.push(EventDetailsRoute(event: widget.event)),
      text: context.localization?.viewEvent ?? '',
    );
  }

  Container buildSecondSection() {
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
          Text(widget.event.name ?? '', style: satoshi600S14)
              .fadeInAndMoveFromBottom(delay: slowDuration),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Text(
            widget.event.description ?? '',
            style: satoshi500S12,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ).fadeInAndMoveFromBottom(delay: slowDuration),
          verticalSpacer12,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.localization?.location ?? '',
                style: satoshi600S12,
              ),
              horizontalSpacer12,
              Expanded(
                child: Text(
                  widget.event.location ?? '',
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
                context.localization?.startDate ?? '',
                style: satoshi600S12,
              ),
              horizontalSpacer12,
              Expanded(
                child: Text(
                  widget.event.startDate == null
                      ? (context.localization?.notSpecified ?? '')
                      : $appUtil.formattedDateFull(widget.event.startDate!),
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
                context.localization?.endDate ?? '',
                style: satoshi600S12,
              ),
              horizontalSpacer12,
              Expanded(
                child: Text(
                  widget.event.endDate == null
                      ? (context.localization?.notSpecified ?? '')
                      : $appUtil.formattedDateFull(widget.event.endDate!),
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
                context.localization?.communityValidification ?? '',
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
                '(${widget.event.upVote ?? 0})',
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
                '(${widget.event.downVote ?? 0})',
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
      padding: const EdgeInsets.all(space4),
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
              bottom: space12,
              child: Center(
                child: AppPageIndicator(
                    count: (widget.event.images ?? []).length,
                    controller: pageController),
              ).fadeIn(delay: slowDuration),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    final images = widget.event.images ?? [];

    return PageView.builder(
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
    );
  }

  Container buildPriority() {
    return Container(
      padding: const EdgeInsets.all(space6),
      decoration: BoxDecoration(
        color: widget.event.priority?.backgroundColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(
          color: widget.event.priority?.borderColor ?? neutral300,
        ),
      ),
      child: Text(
        '${widget.event.priority?.displayName.toUpperCase()} ${context.localization?.priority.toUpperCase() ?? ''}',
        style: satoshi600S12.copyWith(color: widget.event.priority?.textColor),
      ),
    );
  }
}
