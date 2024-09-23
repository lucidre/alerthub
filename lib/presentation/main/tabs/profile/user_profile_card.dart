import 'package:alerthub/common_libs.dart';
import 'package:alerthub/models/user/user_model.dart';
import 'package:flutter/cupertino.dart';

class UserProfileCard extends StatefulWidget {
  const UserProfileCard({super.key});

  @override
  State<UserProfileCard> createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        Get.find<ProfileController>().getUpcData();
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
        child: GetX<ProfileController>(builder: (controller) {
          final isLoading = controller.upcIsLoading;
          final hasError = controller.upcHasError;
          final user = controller.userModel;
          return AppShimmer(
            shimmerEnabled: isLoading,
            child: hasError ? buildError() : buildBody(user),
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
      constraints: const BoxConstraints(minHeight: 110),
      child: Column(
        children: [
          Text(
            'An error occurred fetching your profile. Kindly refresh this page',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          AppBtn.from(
            onPressed: () {
              Get.find<ProfileController>().getUpcData();
            },
            text: 'Refresh',
          ),
        ],
      ),
    );
  }

  buildBody(UserModel? user) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => context.router.push(const EditProfileRoute()),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 110,
            height: 110,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
                color: blackShade1Color.withOpacity(.1),
                borderRadius: BorderRadius.circular(space4),
                border: Border.all(
                  color: neutral200,
                  strokeAlign: BorderSide.strokeAlignOutside,
                )),
            child: user?.imageUrl == null
                ? const Icon(CupertinoIcons.camera_fill, size: 40)
                : AppImage(imageUrl: user?.imageUrl),
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
                      Text('Email:', style: satoshi600S12),
                      horizontalSpacer4,
                      Expanded(
                        child: Text(user?.email ?? '', style: satoshi500S12),
                      ),
                    ],
                  ).fadeInAndMoveFromBottom(),
                  verticalSpacer8,
                  Row(
                    children: [
                      Text('Country:', style: satoshi600S12),
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
