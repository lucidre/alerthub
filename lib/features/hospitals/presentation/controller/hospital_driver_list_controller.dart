import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/user/data/model/user_data/user.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';

class HealthCareDriverListController extends GetxController {
  final UserService userService;
  HealthCareDriverListController(this.userService);

  final RxList<User> _users = <User>[].obs;
  final RxInt _page = 0.obs;
  final RxBool _isLoading = true.obs;
  final RxBool _hasError = false.obs;
  final RxBool _allDataLoaded = false.obs;
  final RxBool _oldDataLoading = false.obs;
  final RxBool _isRefreshing = false.obs;

  final refreshController = RefreshController(initialRefresh: false);

  // Getters
  List<User> get users => _users;
  int get page => _page.value;
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  bool get allDataLoaded => _allDataLoaded.value;
  bool get oldDataLoading => _oldDataLoading.value;
  bool get isRefreshing => _isRefreshing.value;

  // Setters
  set users(List<User> value) => _users.assignAll(value);
  set page(int value) => _page.value = value;
  set isLoading(bool value) => _isLoading.value = value;
  set hasError(bool value) => _hasError.value = value;
  set allDataLoaded(bool value) => _allDataLoaded.value = value;
  set oldDataLoading(bool value) => _oldDataLoading.value = value;
  set isRefreshing(bool value) => _isRefreshing.value = value;

  void onRefresh() async {
    isRefreshing = true;

    await getData();

    isRefreshing = false;
  }

  getData() async {
    page = 0;
    isLoading = true;
    hasError = false;
    _users.clear();

    try {
      /*   final data = await eventService.search(search, page);
      final list = data.data ?? [];
      users = list; */
      users = [
        User(
          fullName: loremIspidiumTitle,
          email: 'testx@gmail.com',
          phoneNumber: '+234 814 748 6278',
          country: 'Nigeria',
        ),
        User(
          fullName: loremIspidiumTitle,
          email: 'testx@gmail.com',
          phoneNumber: '+234 814 748 6278',
          country: 'Nigeria',
        ),
        User(
          fullName: loremIspidiumTitle,
          email: 'testx@gmail.com',
          phoneNumber: '+234 814 748 6278',
          country: 'Nigeria',
        ),
        User(
          fullName: loremIspidiumTitle,
          email: 'testx@gmail.com',
          phoneNumber: '+234 814 748 6278',
          country: 'Nigeria',
        ),
      ];
      if (isRefreshing) {
        refreshController.refreshCompleted();
      }
      // allDataLoaded = list.isEmpty;
      isLoading = false;
    } catch (exception) {
      hasError = true;
      if (isRefreshing) {
        refreshController.refreshFailed();
      }
      isLoading = false;
      return Future.error(exception.toString());
    }
  }

  getOldData(StreamController<bool> progressStream) async {
    if (isLoading ||
        allDataLoaded ||
        isRefreshing ||
        users.isEmpty ||
        oldDataLoading) {
      return;
    }

    page++;
    oldDataLoading = true;
    progressStream.add(true);

    try {
      // final data = await eventService.search(search, page);
      // final list = data.data ?? [];
      // allDataLoaded = list.isEmpty;
      // users.addAll(list);
    } catch (exception) {
      allDataLoaded = true;
    }

    oldDataLoading = false;
    progressStream.add(false);
  }
}
