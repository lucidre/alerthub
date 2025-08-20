import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/hospitals/presentation/bars/healthcare_user_information.dart';
import 'package:alerthub/features/hospitals/presentation/controller/hospital_user_list_controller.dart';
import 'package:alerthub/features/user/data/data_sources/remote_data_source.dart';
import 'package:alerthub/features/user/data/model/user_data/user.dart';
import 'package:alerthub/features/user/data/repositorites/user_repository_impl.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/features/user/presentation/widget/hospital_user_item.dart';

@RoutePage()
class HealthCareUserListScreen extends StatefulWidget {
  const HealthCareUserListScreen({super.key});

  @override
  State<HealthCareUserListScreen> createState() =>
      _HealthCareUserListScreenState();
}

class _HealthCareUserListScreenState extends State<HealthCareUserListScreen> {
  final tag = UniqueKey().toString();
  final StreamController<bool> progressStream = StreamController<bool>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final controller = Get.put(
      HealthCareUserListController(
        UserService(
          UserRepositoryImpl(
            UserRemoteDataSource(),
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
      final controller = Get.find<HealthCareUserListController>(tag: tag);
      await controller.getData();
    } catch (exception) {
      context.showErrorSnackBar(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Expanded(
          child: GetX<HealthCareUserListController>(
              tag: tag,
              builder: (controller) {
                final refreshController = controller.refreshController;
                final isLoading = controller.isLoading;
                final hasError = controller.hasError;
                final users = controller.users;
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
        final user = User();
        return HospitalUserItem(
          user: user,
          shimmerEnabled: true,
          onPressed: () {},
        );
      },
      physics: const BouncingScrollPhysics(),
      itemCount: 10,
    );
  }

  Widget buildList(List<User> users) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(0),
      itemBuilder: (ctx, index) {
        final user = users[index];
        return HospitalUserItem(
            user: user,
            shimmerEnabled: false,
            onPressed: () => context.showBottomBar(
                  child: HealthCareUserInformationBar(user: user),
                ));
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
