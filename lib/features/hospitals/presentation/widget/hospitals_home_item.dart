import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart';
import 'package:alerthub/features/event/presentation/controller/user_home_tab_controller.dart';
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/hospitals/presentation/widget/hospital_item.dart';

class HospitalsHomeItem extends StatelessWidget {
  const HospitalsHomeItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTitle(context).fadeInAndMoveFromBottom(),
        verticalSpacer12,
        GetX<UserHomeTabController>(
          builder: (controller) {
            final isLoading = controller.hospitalsIsLoading;
            final hasError = controller.hospitalsHasError;
            final hospitals = controller.hospitals;
            return isLoading
                ? buildLoadingBody()
                : hasError
                    ? Container(
                        padding: const EdgeInsets.all(space12),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(space4),
                          border: Border.all(color: neutral200),
                        ),
                        alignment: Alignment.center,
                        child: context.buildErrorWidget(
                          isMini: true,
                          onRetry: () => controller.getHospitalsData(),
                        ),
                      )
                    : hospitals.isEmpty
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
                                title: 'No Healthcenters',
                                body:
                                    'There are no nearby healthcenters within 500 meters of your current location.'),
                          )
                        : buildBody(context, hospitals);
          },
        ),
      ],
    );
  }

  buildLoadingBody() {
    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(0),
        itemBuilder: (ctx, index) {
          return HospitalItem(
            hospital: const Hospital(),
            shimmerEnabled: true,
            onPressed: () {},
          );
        },
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
      ),
    );
  }

  buildBody(BuildContext context, List<Hospital> hospitals) {
    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(0),
        itemBuilder: (ctx, index) {
          final hospital = hospitals[index];
          return HospitalItem(
            hospital: hospital,
            shimmerEnabled: false,
            onPressed: () =>
                context.router.push(HospitalDetailsRoute(hospital: hospital)),
          );
        },
        physics: const BouncingScrollPhysics(),
        itemCount: hospitals.length,
      ),
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
              'Nearby Healthcenters',
              style: satoshi600S12,
            ),
          ),
          horizontalSpacer12,
          AppBtn.basic(
            onPressed: () => context.router.push(const HospitalsNearbyRoute()),
            child: Text(
              context.localization?.seeAll ?? '',
              style: satoshi500S12,
            ),
          )
        ],
      ),
    );
  }
}
