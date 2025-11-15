import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/hospitals/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/driver.dart';
import 'package:alerthub/features/hospitals/data/repositorites/hospitals_repository_impl.dart';
import 'package:alerthub/features/hospitals/domain/usecases/hospital_service.dart';
import 'package:alerthub/features/hospitals/presentation/bars/healthcare_driver_information.dart';
import 'package:alerthub/features/hospitals/presentation/controller/hospital_driver_list_controller.dart'; 
import 'package:alerthub/features/user/presentation/widget/hospital_driver_item.dart';

@RoutePage()
class HealthCareDriverListScreen extends StatefulWidget {
  const HealthCareDriverListScreen({super.key});

  @override
  State<HealthCareDriverListScreen> createState() =>
      _HealthCareDriverListScreenState();
}

class _HealthCareDriverListScreenState
    extends State<HealthCareDriverListScreen> {
  final tag = UniqueKey().toString();
  final StreamController<bool> progressStream = StreamController<bool>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final controller = Get.put(
      HealthCareDriverListController(
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
        if (scrollController.position.pixels <
            scrollController.position.maxScrollExtent - 10) {
          return;
        }
        controller.getOldData(progressStream);
      });
    });
  }

  getData() async {
    try {
      final controller = Get.find<HealthCareDriverListController>(tag: tag);
      await controller.getData();
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      floatingActionButton: buildFloatingActinoButton(),
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  buildFloatingActinoButton() {
    return FloatingActionButton(
      onPressed: () => context.router.push(DriverAccountSetupRoute()),
      backgroundColor: blackShade1Color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(space4),
      ),
      child: const Icon(Icons.add_rounded),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Expanded(
          child: GetX<HealthCareDriverListController>(
              tag: tag,
              builder: (controller) {
                final refreshController = controller.refreshController;
                final isLoading = controller.isLoading;
                final hasError = controller.hasError;
                final users = controller.drivers;
                return Padding(
                  padding: const EdgeInsets.all(space12),
                  child: SmartRefresher(
                    enablePullDown: true,
                    header: const ClassicHeader(
                        refreshStyle: RefreshStyle.UnFollow),
                    onRefresh: () => controller.onRefresh(),
                    controller: refreshController,
                    child: isLoading
                        ? buildLoadingBody()
                        : hasError
                            ? context.buildErrorWidget(onRetry: () => getData())
                            : users.isEmpty
                                ? context.buildNoDataWidget()
                                : buildList(users),
                  ),
                );
              }),
        ),
        AppFetchingProgressBar(stream: progressStream.stream),
      ],
    );
  }

  buildLoadingBody() {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemBuilder: (ctx, index) {
        return HospitalDriverItem(
          user: const Driver(),
          shimmerEnabled: true,
          onPressed: () {},
        );
      },
      physics: const BouncingScrollPhysics(),
      itemCount: 10,
    );
  }

  Widget buildList(List<Driver> users) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(0),
      itemBuilder: (ctx, index) {
        final user = users[index];
        return HospitalDriverItem(
            user: user,
            shimmerEnabled: false,
            onPressed: () async {
              final result = await context.showBottomBar(
                child: HealthCareDriverInformationBar(user: user),
              );
              if (result is int && result == 1) {
                context.router.push(
                  DriverAccountSetupRoute(driver: user),
                );
              }
            });
      },
      physics: const BouncingScrollPhysics(),
      itemCount: users.length,
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      leading: BackButton(color: context.textColor),
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text('Users list', style: satoshi600S24).fadeIn(),
      actions: [
        IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {
              //
            })
      ],
    );
  }
}
