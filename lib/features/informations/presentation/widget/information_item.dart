// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/informations/data/model/informations/information.dart';
import 'package:alerthub/common_libs.dart';

class InformationItem extends StatelessWidget {
  final Information model;
  final bool shimmerEnabled;
  final VoidCallback onPressed;

  const InformationItem({
    super.key,
    required this.model,
    required this.shimmerEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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

  buildShimmer() => const Padding(
        padding: EdgeInsets.all(space12),
        child: ShimmerItem(),
      );

  buildBody(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => onPressed.call(),
      child: Padding(
        padding: const EdgeInsets.all(space12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                model.title ?? '',
                style: satoshi600S14,
              ),
            ),
            horizontalSpacer12,
            const Icon(
              Icons.info_rounded,
              color: blackShade1Color,
            )
          ],
        ).fadeInAndMoveFromBottom(),
      ),
    );
  }
}
