import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/hospitals/data/model/hospital/driver.dart';
import 'package:alerthub/features/hospitals/domain/usecases/hospital_service.dart';

class HealthCareDriverListController extends GetxController {
  final HospitalService service;
  HealthCareDriverListController(this.service);

  final RxList<Driver> _drivers = <Driver>[].obs;
  final RxInt _page = 0.obs;
  final RxBool _isLoading = true.obs;
  final RxBool _hasError = false.obs;
  final RxBool _allDataLoaded = false.obs;
  final RxBool _oldDataLoading = false.obs;
  final RxBool _isRefreshing = false.obs;

  final refreshController = RefreshController(initialRefresh: false);

  // Getters

  List<Driver> get drivers => _drivers;
  int get page => _page.value;
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  bool get allDataLoaded => _allDataLoaded.value;
  bool get oldDataLoading => _oldDataLoading.value;
  bool get isRefreshing => _isRefreshing.value;

  // Setters
  set drivers(List<Driver> value) => _drivers.assignAll(value);
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
    _drivers.clear();

    try {
      final data = await service.getDriversList(page);
      final list = data.data ?? [];
      drivers = list; 
      
      if (isRefreshing) {
        refreshController.refreshCompleted();
      }
      allDataLoaded = list.isEmpty;
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
        drivers.isEmpty ||
        oldDataLoading) {
      return;
    }

    page++;
    oldDataLoading = true;
    progressStream.add(true);

    try {
      final data = await service.getDriversList(page);
      final list = data.data ?? [];
      allDataLoaded = list.isEmpty;
      drivers.addAll(list);
    } catch (exception) {
      allDataLoaded = true;
    }

    oldDataLoading = false;
    progressStream.add(false);
  }
}
