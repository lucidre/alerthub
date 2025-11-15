// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/hospitals/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart';
import 'package:alerthub/features/hospitals/data/repositorites/hospitals_repository_impl.dart';
import 'package:alerthub/features/hospitals/domain/usecases/hospital_service.dart';
import 'package:alerthub/features/hospitals/presentation/controller/hosptial_details_controller.dart';
import 'package:alerthub/shared/widgets/page_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';

@RoutePage()
class HospitalDetailsScreen extends StatefulWidget {
  final Hospital hospital;

  const HospitalDetailsScreen({super.key, required this.hospital});

  @override
  State<HospitalDetailsScreen> createState() => _HospitalDetailsScreenState();
}

class _HospitalDetailsScreenState extends State<HospitalDetailsScreen> {
  final pageController = PageController();
  final tag = UniqueKey().toString();

  @override
  void initState() {
    super.initState();

    Get.put(
      HospitalDetailsController(
        HospitalService(
          HospitalRepositoryImpl(
            HospitalRemoteDataSource(),
          ),
        ),
      ),
      tag: tag,
    );

    Future.delayed(Duration.zero, () => getData());
  }

  getData() async {
    try {
      final controller = Get.find<HospitalDetailsController>(tag: tag);
      await controller.getData(widget.hospital.id ?? '');
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<HospitalDetailsController>(
        tag: tag,
        builder: (controller) {
          final isLoading = controller.isLoading;
          final hasError = controller.hasError;
          final hospital = controller.hospital;

          return AppScaffold(
            appBar: buildAppBar(hospital),
            body: Padding(
              padding: const EdgeInsets.all(space12),
              child: isLoading
                  ? context.buildLoadingWidget()
                  : hasError
                      ? context.buildErrorWidget(onRetry: () => getData())
                      : buildBody(hospital),
            ),
          );
        });
  }

  SingleChildScrollView buildBody(Hospital? hospital) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpacer12,
          Text(hospital?.fullName ?? '', style: satoshi700S16)
              .fadeInAndMoveFromBottom(),
          verticalSpacer16,
          buildImage(hospital),
          verticalSpacer16,
          buildDescription(hospital),
          verticalSpacer16,
          buildHelpline(hospital),
          verticalSpacer16,
          buildLocation(hospital),
          /*    if (FirebaseAuth.instance.currentUser?.uid ==
              widget.hospital.userId) ...[
            verticalSpacer24,
            AppBtn.from(
              onPressed: () => editHospital(),
              text: 'Edit Healthcenters',
            ),
            verticalSpacer16,
            AppBtn.from(
              onPressed: () => deleteHospital(),
              text: 'Delete Healthcenters',
              bgColor: destructive600,
            ),
          ], */
          verticalSpacer32 * 3
        ],
      ),
    );
  }

  editHospital() async {
    /*    final result = await context.router.push(
      CreateHospitalRoute(
        hospital: Get.find<HospitalDetailsController>(tag: tag).hospital,
      ),
    );
    if (result != null && result is bool) {
      getData();
    } */
  }

  deleteHospital() async {
    /*    final result = await context.$showGeneralDialog(
      child: const HospitalsDeleteBar(),
      barrierLabel: context.localization?.description ?? '',
    );
    if (result != null && result) {
      context.router.maybePop();
    } */
  }

  Container buildImage(Hospital? hospital) {
    final images = hospital?.images ?? [];

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
                      color: blackColor.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(space4),
                      border: Border.all(
                        color: neutral200,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => context.router
                          .push(ViewImageRoute(imageUrl: images[index])),
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
                  count: images.length,
                  controller: pageController,
                ),
              ).fadeIn(delay: slowDuration),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDescription(Hospital? hospital) {
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
            hospital?.description ?? '',
            style: satoshi500S12,
          ).fadeInAndMoveFromBottom(),
        ],
      ),
    );
  }

  Widget buildHelpline(Hospital? hospital) {
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
            'Helpline',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          context.divider,
          verticalSpacer12,
          Text(
            hospital?.helpline ?? '',
            style: satoshi500S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          AppBtn.from(
            onPressed: () => $appUtil.onPhoneClicked(hospital?.helpline ?? ''),
            text: 'Call helpline',
          ),
        ],
      ),
    );
  }

  Widget buildLocation(Hospital? hospital) {
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
            hospital?.location ?? '',
            style: satoshi500S12,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          AppBtn.from(
            onPressed: () => context.router
                .push(HospitalDetailsMapRoute(hospital: hospital!)),
            text: context.localization?.viewOnMap ?? '',
            expand: true,
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(Hospital? hospital) {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      actions: [
        if (FirebaseAuth.instance.currentUser?.uid == hospital?.userId)
          PopupMenuButton<int>(
            onSelected: (int position) {
              if (position == 0) {
                editHospital();
              } else if (position == 1) {
                deleteHospital();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              PopupMenuItem(
                value: 0,
                child: Text(
                  'Edit Healthcenter',
                  style: satoshi500S14,
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Text(
                  'Delete Healthcenter',
                  style: satoshi500S14,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
