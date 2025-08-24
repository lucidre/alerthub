// ignore_for_file: use_build_context_synchronously

import 'package:alerthub/features/informations/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/informations/data/model/informations/information.dart';
import 'package:alerthub/features/informations/data/repositorites/information_repository_impl.dart';
import 'package:alerthub/features/informations/domain/usecases/information_service.dart';
import 'package:alerthub/features/informations/presentation/controller/information_controller.dart';
import 'package:alerthub/features/informations/presentation/widget/information_item.dart';
import 'package:alerthub/common_libs.dart';

class InformationTab extends StatefulWidget {
  const InformationTab({super.key});

  @override
  State<InformationTab> createState() => _InformationTabState();
}

class _InformationTabState extends State<InformationTab> {
  final tag = UniqueKey().toString();
  final StreamController<bool> progressStream = StreamController<bool>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final controller = Get.put(
      InformationController(
        InformationService(
          InformationRepositoryImpl(
            InformationRemoteDataSource(),
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
      final controller = Get.find<InformationController>(tag: tag);
      await controller.getData();
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: buildAppBar(),
      body: Container(
        padding: const EdgeInsets.all(space12),
        child: Column(
          children: [
            Expanded(
              child: GetX<InformationController>(
                  tag: tag,
                  builder: (controller) {
                    final refreshController = controller.refreshController;
                    final isLoading = controller.isLoading;
                    final hasError = controller.hasError;
                    final informations = controller.informations;

                    return SmartRefresher(
                      enablePullDown: true,
                      header: const ClassicHeader(
                          refreshStyle: RefreshStyle.UnFollow),
                      onRefresh: () => controller.onRefresh(),
                      controller: refreshController,
                      child: isLoading
                          ? context.buildLoadingWidget()
                          : hasError
                              ? context.buildErrorWidget(
                                  onRetry: () => getData())
                              : informations.isEmpty
                                  ? context.buildNoDataWidget()
                                  : buildBody(informations),
                    );
                  }),
            ),
            AppFetchingProgressBar(stream: progressStream.stream),
          ],
        ),
      ),
    );
  }

  ListView buildBody(List<Information> informations) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(0),
      controller: scrollController,
      itemBuilder: (ctx, index) {
        final information = informations[index];
        return InformationItem(
          model: information,
          shimmerEnabled: false,
          onPressed: () => context.router.push(
            InformationDetailsRoute(
              information: information,
            ),
          ),
        );
      },
      itemCount: informations.length,
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      forceMaterialTransparency: true,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: false,
      backgroundColor: context.backgroundColor,
      title: Text('Firstaid Information', style: satoshi600S24).fadeIn(),
    );
  }
}
