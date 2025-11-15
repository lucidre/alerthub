import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart';
import 'package:alerthub/features/user/presentation/controller/hospital_tab_controller.dart';
import 'package:alerthub/common_libs.dart';
import 'package:flutter/cupertino.dart';

class HospitalProfileCard extends StatefulWidget {
  const HospitalProfileCard({super.key});

  @override
  State<HospitalProfileCard> createState() => _HospitalProfileCardState();
}

class _HospitalProfileCardState extends State<HospitalProfileCard> {
  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        Get.find<HospitalTabController>().getUpcData();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(space12),
        margin: const EdgeInsets.only(
          left: space12,
          right: space12,
        ),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(space4),
          border: Border.all(color: neutral200),
        ),
        child: GetX<HospitalTabController>(builder: (controller) {
          final isLoading = controller.upcIsLoading;
          final hasError = controller.upcHasError;
          final hospital = controller.upcUserModel;
          return AppShimmer(
            shimmerEnabled: isLoading,
            child: hasError ? buildError() : buildBody(hospital),
            shimmerChild: buildShimmer(),
          );
        }),
      ),
    );
  }

  buildShimmer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: blackShade1Color,
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
                const ShimmerItem(),
                verticalSpacer8,
                const ShimmerItem(),
                verticalSpacer8,
                const ShimmerItem(),
              ],
            ),
          ),
        )
      ],
    );
  }

  buildError() {
    return Container(
      alignment: Alignment.center,
      constraints: const BoxConstraints(minHeight: 110),
      child: Column(
        children: [
          Text(
            context.localization?.errorFetchingProfile ?? '',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          AppBtn.from(
            onPressed: () {
              Get.find<HospitalTabController>().getUpcData();
            },
            text: context.localization?.refresh ?? '',
          ),
        ],
      ),
    );
  }

  buildBody(Hospital? user) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => context.router.push(const UserEditProfileRoute()),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 110,
            height: 110,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
                color: blackShade1Color.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(space4),
                border: Border.all(
                  color: neutral200,
                  strokeAlign: BorderSide.strokeAlignOutside,
                )),
            child: user?.images?.firstOrNull == null
                ? const Icon(CupertinoIcons.camera_fill, size: 40)
                : InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      context.router.push(
                        ViewImageRoute(imageUrl: user?.images?.first ?? ''),
                      );
                    },
                    child: AppImage(imageUrl: user?.images?.first)),
          ).fadeInAndMoveFromBottom(),
          horizontalSpacer12,
          Expanded(
            child: SizedBox(
              height: 110,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user?.fullName ?? '', style: satoshi600S14)
                      .fadeInAndMoveFromBottom(),
                  verticalSpacer8,
                  Row(
                    children: [
                      Text('${context.localization?.email ?? ''}:',
                          style: satoshi600S12),
                      horizontalSpacer4,
                      Expanded(
                        child: Text(user?.email ?? '', style: satoshi500S12),
                      ),
                    ],
                  ).fadeInAndMoveFromBottom(),
                  verticalSpacer8,
                  Row(
                    children: [
                      Text('${context.localization?.country ?? ''}:',
                          style: satoshi600S12),
                      horizontalSpacer4,
                      Expanded(
                        child: Text(user?.country ?? '', style: satoshi500S12),
                      ),
                    ],
                  ).fadeInAndMoveFromBottom(),
                  const Spacer(),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.edit_square,
                      color: blackShade1Color,
                    ),
                  ).fadeInAndMoveFromBottom(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
