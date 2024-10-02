import 'package:alerthub/common_libs.dart';
import 'package:alerthub/models/event/event.dart';

class EventItem extends StatelessWidget {
  final Event event;
  final bool shimmerEnabled;
  final VoidCallback onPressed;

  const EventItem({
    super.key,
    required this.event,
    required this.shimmerEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(space12),
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
              const ShimmerItem(height: space16),
              verticalSpacer8,
              const ShimmerItem(),
              verticalSpacer8,
              const ShimmerItem(),
            ],
          ),
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
            width: 110,
            height: 110,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              color: blackShade1Color.withOpacity(.1),
              border: Border.all(
                color: neutral200,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              borderRadius: BorderRadius.circular(space4),
            ),
            child: AppImage(imageUrl: event.images?.first),
          ).fadeInAndMoveFromBottom(),
          horizontalSpacer12,
          Expanded(
              child: SizedBox(
            height: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.name ?? '',
                  style: satoshi600S14,
                ).fadeInAndMoveFromBottom(),
                verticalSpacer8,
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    event.description ?? '',
                    style: satoshi500S12,
                    softWrap: true,
                  ).fadeInAndMoveFromBottom(),
                ),
                verticalSpacer8,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: 'Location: ', style: satoshi600S12),
                      TextSpan(
                        text: event.location ?? '',
                        style: satoshi500S12,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                  textScaler: MediaQuery.of(context).textScaler,
                ).fadeInAndMoveFromBottom(),
                verticalSpacer8,
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${event.priority?.displayName} Priority',
                    style: satoshi600S12.copyWith(
                      color: event.priority?.textColor,
                    ),
                  ),
                ).fadeInAndMoveFromBottom(),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
