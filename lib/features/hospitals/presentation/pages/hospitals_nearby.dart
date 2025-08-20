import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/hospitals/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/hospital.dart';
import 'package:alerthub/features/hospitals/data/repositorites/hospitals_repository_impl.dart';
import 'package:alerthub/features/hospitals/domain/usecases/hospital_service.dart';
import 'package:alerthub/features/hospitals/presentation/controller/hospitals_nearby_controller.dart';
import 'package:alerthub/features/hospitals/presentation/widget/hospital_item.dart';

@RoutePage()
class HospitalsNearbyScreen extends StatefulWidget {
  const HospitalsNearbyScreen({super.key});

  @override
  State<HospitalsNearbyScreen> createState() => _HospitalsNearbyScreenState();
}

class _HospitalsNearbyScreenState extends State<HospitalsNearbyScreen> {
  final progressStream = StreamController<bool>();
  final scrollController = ScrollController();
  final refreshController = RefreshController(initialRefresh: false);
  final tag = UniqueKey().toString();

  @override
  void initState() {
    super.initState();
    Get.put(
      HospitalsNearbyController(
        HospitalService(
          HospitalRepositoryImpl(
            HospitalRemoteDataSource(),
          ),
        ),
      ),
      tag: tag,
    );

    Future.delayed(Duration.zero, () {
      getData();
      progressStream.add(false);

      scrollController.addListener(() {
        if (scrollController.position.pixels >
            scrollController.position.maxScrollExtent - 10) {
          final controller = Get.find<HospitalsNearbyController>(
            tag: tag,
          );
          controller.getNearbyOldData(progressStream);
        }
      });
    });
  }

  getData() async {
    try {
      final controller = Get.find<HospitalsNearbyController>(tag: tag);
      await controller.getNearbyData();
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
  }

  void onRefresh() async {
    try {
      final controller = Get.find<HospitalsNearbyController>(tag: tag);
      await controller.getNearbyData();
      refreshController.refreshCompleted();
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
      refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(space12),
        child: Column(
          children: [
            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                header:
                    const ClassicHeader(refreshStyle: RefreshStyle.UnFollow),
                onRefresh: () => onRefresh(),
                controller: refreshController,
                child: GetX<HospitalsNearbyController>(
                  tag: tag,
                  builder: (controller) {
                    final isLoading = controller.nearbyIsLoading;
                    final hasError = controller.nearbyHasError;
                    final hospitals = controller.nearbyHospitals;
                    return isLoading
                        ? buildLoadingBody()
                        : hasError
                            ? context.buildErrorWidget(onRetry: () => getData())
                            : hospitals.isEmpty
                                ? context.buildNoDataWidget(
                                    title: 'No Healthcenters',
                                    body:
                                        'There are no healthcenters within 500 meters of your current location.',
                                  )
                                : buildBody(hospitals);
                  },
                ),
              ),
            ),
            AppFetchingProgressBar(stream: progressStream.stream),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text('Nearby Healthcenters', style: satoshi600S24).fadeIn(),
    );
  }

  buildLoadingBody() {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemBuilder: (ctx, index) {
        return HospitalItem2(
          hospital: const Hospital(),
          shimmerEnabled: true,
          onPressed: () {},
        );
      },
      physics: const BouncingScrollPhysics(),
      itemCount: 10,
    );
  }

  ListView buildBody(List<Hospital> hospitals) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(0),
      itemBuilder: (ctx, index) {
        final hospital = hospitals[index];
        return HospitalItem2(
          hospital: hospital,
          shimmerEnabled: false,
          onPressed: () =>
              context.router.push(HospitalDetailsRoute(hospital: hospital)),
        );
      },
      physics: const BouncingScrollPhysics(),
      itemCount: hospitals.length,
    );
  }
}
