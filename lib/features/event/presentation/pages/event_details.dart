// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/event/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/event/data/repositorites/event_repository_impl.dart';
import 'package:alerthub/features/event/domain/usecases/event_service.dart';

import 'package:alerthub/features/event/presentation/bars/events_comments_bar.dart';
import 'package:alerthub/features/event/presentation/bars/events_delete_bar.dart';
import 'package:alerthub/features/event/presentation/bars/events_vote_bar.dart';
import 'package:alerthub/features/event/presentation/controller/event_details_controller.dart';

import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/shared/widgets/page_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  void initState() {
    super.initState();
    Get.put(EventDetailsController(
      EventService(
        EventRepositoryImpl(
          EventRemoteDataSource(),
        ),
      ),
    ));
    Future.delayed(Duration.zero, () => getData());
  }

  getData() async {
    try {
      final controller = Get.find<EventDetailsController>();
      await controller.getData(widget.event.id ?? '');
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<EventDetailsController>(builder: (controller) {
      final isLoading = controller.isLoading;
      final hasError = controller.hasError;
      final event = controller.event;

      return AppScaffold(
        appBar: buildAppBar(event),
        body: Padding(
          padding: const EdgeInsets.all(space12),
          child: isLoading
              ? context.buildLoadingWidget()
              : hasError
                  ? context.buildErrorWidget(onRetry: () => getData())
                  : buildBody(event),
        ),
      );
    });
  }

  SingleChildScrollView buildBody(Event? event) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          buildImage(event),
          verticalSpacer16,
          buildDescription(event),
          verticalSpacer16,
          buildPriority(event),
          verticalSpacer16,
          buildLocation(event),
          verticalSpacer16,
          buildDate(event),
          verticalSpacer16,
          buildValidity(event),
          verticalSpacer16,
          buildCreatorInfo(event),
          verticalSpacer16,
          buildComments(event),
          if (FirebaseAuth.instance.currentUser?.uid ==
              widget.event.creatorId) ...[
            verticalSpacer24,
            AppBtn.from(
              onPressed: () => editEvent(),
              text: context.localization?.editEvent ?? '',
            ),
            verticalSpacer16,
            AppBtn.from(
              onPressed: () => deleteEvent(),
              text: context.localization?.deleteEvent ?? '',
              bgColor: destructive600,
            ),
          ],
          verticalSpacer32 * 3
        ],
      ),
    );
  }

  editEvent() async {
    final result = await context.router.push(
      CreateEventRoute(
        event: Get.find<EventDetailsController>().event,
      ),
    );
    if (result != null && result is bool) {
      getData();
    }
  }

  deleteEvent() async {
    final result = await context.$showGeneralDialog(
      child: const EventsDeleteBar(),
      barrierLabel: context.localization?.description ?? '',
    );
    if (result != null && result) {
      context.router.maybePop();
    }
  }

  Container buildImage(Event? event) {
    final images = event?.images ?? [];

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
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        context.router
                            .push(ViewImageRoute(imageUrl: images[index]));
                      },
                      child: AppImage(
                        imageUrl: images[index],
                        fit: BoxFit.cover,
                      ),
                    ));
              },
            ),
            Positioned(
              right: space6,
              left: space6,
              bottom: space12,
              child: Center(
                child: AppPageIndicator(
                    count: images.length, controller: pageController),
              ).fadeIn(delay: slowDuration),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDescription(Event? event) {
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
            context.localization?.description ?? '',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Text(
            event?.description ?? '',
            style: satoshi500S12,
          ).fadeInAndMoveFromBottom(),
        ],
      ),
    );
  }

  Widget buildCreatorInfo(Event? event) {
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
            context.localization?.creatorInformation ?? '',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    color: blackShade1Color.withOpacity(.1),
                    borderRadius: BorderRadius.circular(space4),
                    border: Border.all(
                      color: neutral200,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    )),
                child: InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    context.router.push(
                      ViewImageRoute(imageUrl: event?.creatorImage ?? ''),
                    );
                  },
                  child: AppImage(imageUrl: event?.creatorImage),
                ),
              ).fadeInAndMoveFromBottom(),
              horizontalSpacer12,
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          context.localization?.fullName ?? '',
                          style: satoshi600S12,
                        ),
                        horizontalSpacer4,
                        Expanded(
                          child: Text(
                            event?.creatorName ?? '',
                            style: satoshi500S12,
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),
                    verticalSpacer12,
                    Row(
                      children: [
                        Text(
                          context.localization?.email ?? '',
                          style: satoshi600S12,
                        ),
                        horizontalSpacer4,
                        Expanded(
                          child: Text(
                            event?.creatorEmail ?? '',
                            style: satoshi500S12,
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),
                    verticalSpacer12,
                    Row(
                      children: [
                        Text(
                          context.localization?.country ?? '',
                          style: satoshi600S12,
                        ),
                        horizontalSpacer4,
                        Expanded(
                          child: Text(
                            event?.creatorCountry ?? '',
                            style: satoshi500S12,
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),
                  ],
                ).fadeInAndMoveFromBottom(),
              ),
            ],
          )
        ],
      ),
    ).fadeInAndMoveFromBottom();
  }

  Widget buildLocation(Event? event) {
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
            context.localization?.location ?? '',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Text(
            event?.location ?? '',
            style: satoshi500S12,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          AppBtn.from(
            onPressed: () {
              context.router.push(EventDetailsMapRoute(event: event!));
            },
            text: context.localization?.viewOnMap ?? '',
            expand: true,
          ),
        ],
      ),
    );
  }

  Widget buildDate(Event? event) {
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
            context.localization?.eventDate ?? '',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
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
                  event?.startDate == null
                      ? (context.localization?.notSpecified ?? '')
                      : $appUtil.formattedDateFull(event!.startDate!),
                  style: satoshi500S12,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ).fadeInAndMoveFromBottom(),
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
                  event?.endDate == null
                      ? (context.localization?.notSpecified ?? '')
                      : $appUtil.formattedDateFull(event!.endDate!),
                  style: satoshi500S12,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ).fadeInAndMoveFromBottom(),
        ],
      ),
    );
  }

  Widget buildValidity(Event? event) {
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
            context.localization?.validity ?? '',
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
                        '${event?.upVote ?? 0} ${context.localization?.usersVotedAccurate ?? ''}',
                        style: satoshi500S12.copyWith(color: primary800),
                      ).fadeInAndMoveFromBottom(),
                    ],
                  ),
                ).fadeInAndMoveFromBottom(),
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
                        '${event?.downVote ?? 0} ${context.localization?.usersVotedInaccurate ?? ''}',
                        style: satoshi500S12.copyWith(color: destructive700),
                      ).fadeInAndMoveFromBottom(),
                    ],
                  ),
                ).fadeInAndMoveFromBottom(),
              ),
            ],
          ),
          verticalSpacer12,
          AppBtn.from(
            onPressed: () async {
              final result =
                  await context.showBottomBar(child: const EventsVoteBar());
              if (result is bool && result) {
                getData();
              }
            },
            text: context.localization?.voteAndComment ?? '',
            expand: true,
          ),
        ],
      ),
    );
  }

  Widget buildComments(Event? event) {
    List<String> comments = event?.comments ?? [];

    if (comments.length > 10) {
      comments = comments.getRange(0, 10).toList();
    }
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
          Row(
            children: [
              Expanded(
                child: Text(
                  context.localization?.comments ?? '',
                  style: satoshi600S14,
                ).fadeInAndMoveFromBottom(),
              ),
              horizontalSpacer12,
              AppBtn.basic(
                onPressed: () =>
                    context.showBottomBar(child: const EventCommentsBar()),
                child: Text(
                  context.localization?.viewAll ?? '',
                  style: satoshi500S12,
                ),
              ),
            ],
          ),
          verticalSpacer12,
          context.divider,
          comments.isEmpty
              ? context.buildNoDataWidget(isMini: true)
              : ListView.separated(
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    final comment = comments[index];
                    return Padding(
                      padding: const EdgeInsets.all(space12),
                      child: Text(
                        comment,
                        style: satoshi500S12,
                      ).fadeInAndMoveFromBottom(),
                    );
                  },
                  separatorBuilder: (_, __) =>
                      context.divider.fadeInAndMoveFromBottom(),
                  itemCount: comments.length,
                )
        ],
      ),
    );
  }

  Widget buildPriority(Event? event) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: event?.priority?.backgroundColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(
          color: event?.priority?.borderColor ?? neutral300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${context.localization?.priority ?? ''} (${event?.priority?.name.toUpperCase()})',
            style: satoshi600S14.copyWith(color: event?.priority?.textColor),
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Text(
            event?.priority?.userDescription ?? '',
            style: satoshi500S12.copyWith(color: event?.priority?.color2),
          ).fadeInAndMoveFromBottom(),
        ],
      ),
    );
  }

  AppBar buildAppBar(Event? event) {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text(event?.name ?? '', style: satoshi600S24).fadeIn(),
      actions: [
        if (FirebaseAuth.instance.currentUser?.uid == event?.creatorId)
          PopupMenuButton<int>(
            onSelected: (int position) {
              if (position == 0) {
                editEvent();
              } else if (position == 1) {
                deleteEvent();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              PopupMenuItem(
                value: 0,
                child: Text(
                  context.localization?.editEvent ?? '',
                  style: satoshi500S14,
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Text(
                  context.localization?.deleteEvent ?? '',
                  style: satoshi500S14,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
