import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/user/data/model/user_data/user.dart';

class HospitalUserItem extends StatelessWidget {
  final User user;
  final bool shimmerEnabled;
  final VoidCallback onPressed;

  const HospitalUserItem({
    super.key,
    required this.user,
    required this.shimmerEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space4),
      margin: const EdgeInsets.only(bottom: space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: AppShimmer(
        shimmerEnabled: shimmerEnabled,
        shimmerChild: buildShimmer(),
        child: buildBody(context),
      ),
    );
  }

  buildShimmer() {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: blackShade1Color,
            borderRadius: BorderRadius.circular(space4),
          ),
        ),
        horizontalSpacer12,
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerItem(),
            verticalSpacer8,
            const ShimmerItem(height: space16),
            verticalSpacer8,
            const ShimmerItem(),
            verticalSpacer8,
            const ShimmerItem(),
          ],
        )),
      ],
    );
  }

  buildBody(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => onPressed.call(),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              color: blackShade1Color.withValues(alpha: .1),
              border: Border.all(
                color: neutral200,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              borderRadius: BorderRadius.circular(space4),
            ),
            child: AppImage(imageUrl: user.imageUrl ?? ''),
          ).fadeInAndMoveFromBottom(),
          horizontalSpacer12,
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullName ?? '',
                style: satoshi600S14,
              ).fadeInAndMoveFromBottom(),
              verticalSpacer8,
              Text(
                'Email: ${user.email ?? 'Unknown'}',
                style: satoshi500S12,
                softWrap: true,
              ).fadeInAndMoveFromBottom(),
              verticalSpacer8,
              Text(
                'Phone: ${user.phoneNumber ?? 'Unknown'}',
                style: satoshi500S12,
                softWrap: true,
              ).fadeInAndMoveFromBottom(),
              verticalSpacer4,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Country: ${user.country ?? 'Unknown'}',
                      style: satoshi500S12,
                      softWrap: true,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(space6),
                    decoration: BoxDecoration(
                      color: kGoldShade1,
                      borderRadius: BorderRadius.circular(space4),
                    ),
                    child: Text(
                      'Pending Review',
                      style: satoshi500S12.copyWith(color: whiteColor),
                    ),
                  ),
                ],
              ).fadeInAndMoveFromBottom(),
            ],
          )),
        ],
      ),
    );
  }
}
