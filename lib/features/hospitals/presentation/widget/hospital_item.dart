import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart';

class HospitalItem extends StatelessWidget {
  final Hospital hospital;
  final bool shimmerEnabled;
  final VoidCallback onPressed;

  const HospitalItem({
    super.key,
    required this.hospital,
    required this.shimmerEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(space12),
      margin: const EdgeInsets.only(right: space12),
      width: 300,
      height: 270,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: blackShade1Color,
            borderRadius: BorderRadius.circular(space4),
          ),
        ),
        verticalSpacer12,
        const ShimmerItem(),
        verticalSpacer8,
        const ShimmerItem(
          height: space24,
        ),
        verticalSpacer8,
        const ShimmerItem(),
      ],
    );
  }

  buildBody(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => onPressed.call(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 300,
            height: 150,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              color: blackShade1Color.withValues(alpha: .1),
              border: Border.all(
                color: neutral200,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              borderRadius: BorderRadius.circular(space4),
            ),
            child: AppImage(imageUrl: hospital.images?.first),
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          Text(
            hospital.name ?? '',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer8,
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: '${context.localization?.location ?? ''}: ',
                    style: satoshi600S12),
                TextSpan(
                  text: hospital.location ?? '',
                  style: satoshi500S12,
                ),
              ],
            ),
            textAlign: TextAlign.start,
            textScaler: MediaQuery.of(context).textScaler,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer8,
          Text('Helpline: ${hospital.helpline}', style: satoshi600S12)
              .fadeInAndMoveFromBottom(),
        ],
      ),
    );
  }
}

class HospitalItem2 extends StatelessWidget {
  final Hospital hospital;
  final bool shimmerEnabled;
  final VoidCallback onPressed;

  const HospitalItem2({
    super.key,
    required this.hospital,
    required this.shimmerEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(space12),
      margin: const EdgeInsets.only(bottom: space12),
      width: double.infinity,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: blackShade1Color,
            borderRadius: BorderRadius.circular(space4),
          ),
        ),
        verticalSpacer12,
        const ShimmerItem(),
        verticalSpacer8,
        const ShimmerItem(
          height: space24,
        ),
        verticalSpacer8,
        const ShimmerItem(),
      ],
    );
  }

  buildBody(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => onPressed.call(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 150,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              color: blackShade1Color.withValues(alpha: .1),
              border: Border.all(
                color: neutral200,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              borderRadius: BorderRadius.circular(space4),
            ),
            child: AppImage(imageUrl: hospital.images?.first),
          ).fadeInAndMoveFromBottom(),
          verticalSpacer12,
          Text(
            hospital.name ?? '',
            style: satoshi600S14,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer8,
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: '${context.localization?.location ?? ''}: ',
                    style: satoshi600S12),
                TextSpan(
                  text: hospital.location ?? '',
                  style: satoshi500S12,
                ),
              ],
            ),
            textAlign: TextAlign.start,
            textScaler: MediaQuery.of(context).textScaler,
          ).fadeInAndMoveFromBottom(),
          verticalSpacer8,
          Text('Helpline: ${hospital.helpline}', style: satoshi600S12)
              .fadeInAndMoveFromBottom(),
        ],
      ),
    );
  }
}
