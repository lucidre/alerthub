import 'dart:async';

import 'package:alerthub/features/informations/data/model/informations/information.dart';
import 'package:alerthub/features/informations/domain/usecases/information_service.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class InformationController extends GetxController {
  final InformationService informationService;
  InformationController(this.informationService);

  final RxInt _page = 0.obs;
  final RxBool _isLoading = true.obs;
  final RxBool _hasError = false.obs;
  final RxBool _allDataLoaded = false.obs;
  final RxBool _oldDataLoading = false.obs;
  final RxList<Information> _informations = <Information>[].obs;
  final RxBool _isRefreshing = false.obs;
  final refreshController = RefreshController(initialRefresh: false);

  // Getters
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  List<Information> get informations => _informations;
  bool get isRefreshing => _isRefreshing.value;
  int get page => _page.value;
  bool get allDataLoaded => _allDataLoaded.value;
  bool get oldDataLoading => _oldDataLoading.value;

  // Setters
  set isLoading(bool value) => _isLoading.value = value;
  set hasError(bool value) => _hasError.value = value;
  set informations(List<Information> value) => _informations.assignAll(value);
  set isRefreshing(bool value) => _isRefreshing.value = value;
  set page(int value) => _page.value = value;
  set allDataLoaded(bool value) => _allDataLoaded.value = value;
  set oldDataLoading(bool value) => _oldDataLoading.value = value;

  void onRefresh() async {
    isRefreshing = true;

    await getData();

    isRefreshing = false;
  }

  getData() async {
    page = 0;
    isLoading = true;
    hasError = false;
    _informations.clear();

    try {
      final data = await informationService.getInformations(page);
      informations = data.data ?? [];
      hasError = false;
      allDataLoaded = informations.isEmpty;
      if (isRefreshing) {
        refreshController.refreshCompleted();
      }
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
        informations.isEmpty ||
        oldDataLoading) {
      return;
    }

    page++;
    oldDataLoading = true;
    progressStream.add(true);

    try {
      final data = await informationService.getInformations(page);

      final list = data.data ?? [];
      allDataLoaded = list.isEmpty;
      informations.addAll(list);
    } catch (exception) {
      allDataLoaded = true;
    }

    oldDataLoading = false;
    progressStream.add(false);
  }
}
