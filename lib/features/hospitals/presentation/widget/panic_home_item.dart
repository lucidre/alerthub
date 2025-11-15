import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/hospitals/presentation/widget/panic_item.dart';
import 'package:alerthub/features/panic/presentation/controller/panic_controller.dart';

class PanicHomeItem extends StatelessWidget {
  const PanicHomeItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTitle(context).fadeInAndMoveFromBottom(),
        verticalSpacer12,
        GetX<PanicController>(
          builder: (controller) {
            final panics = controller.receivedPanics;

            return panics.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(space12),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(space4),
                      border: Border.all(color: neutral200),
                    ),
                    alignment: Alignment.center,
                    child: context.buildNoDataWidget(
                        isMini: true,
                        title: 'No Emergencies',
                        body:
                            'There are no nearby emergencies within your current location.'),
                  )
                : SizedBox(
                    height: 270,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (ctx, index) {
                        final item = panics[index];
                        return PanicItem(
                          model: item,
                          shimmerEnabled: false,
                          onPressed: () {
                            //
                            //
                          },
                        );
                      },
                      physics: const BouncingScrollPhysics(),
                      itemCount: panics.length,
                    ),
                  );
          },
        ),
      ],
    );
  }

  Container buildTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(space12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(space4),
        border: Border.all(color: neutral200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Nearby Emergencies',
              style: satoshi600S12,
            ),
          ),
          horizontalSpacer12,
          /*   AppBtn.basic(
            onPressed: () => context.router.push(const HospitalsNearbyRoute()),
            child: Text(
              context.localization?.seeAll ?? '',
              style: satoshi500S12,
            ),
          ) */
        ],
      ),
    );
  }
}
