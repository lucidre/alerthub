import 'package:alerthub/features/event/domain/usecases/event_service.dart';
import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/common_libs.dart';

class EventsSearchController extends GetxController {
  final EventService eventService;
  EventsSearchController(this.eventService);

  final RxList<Event> _events = <Event>[].obs;
  final RxInt _page = 0.obs;
  final RxBool _isLoading = true.obs;
  final RxBool _hasError = false.obs;
  final RxBool _allDataLoaded = false.obs;
  final RxBool _oldDataLoading = false.obs;
  final RxBool _isRefreshing = false.obs;

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  final TextEditingController searchController = TextEditingController();

  // Getters
  List<Event> get events => _events;
  int get page => _page.value;
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  bool get allDataLoaded => _allDataLoaded.value;
  bool get oldDataLoading => _oldDataLoading.value;
  bool get isRefreshing => _isRefreshing.value;

  // Setters
  set events(List<Event> value) => _events.assignAll(value);
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
    _events.clear();

    try {
      final search = searchController.text.trim();
      final data = await eventService.search(search, page);
      final list = data.data ?? [];
      events = list;
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
        events.isEmpty ||
        oldDataLoading) {
      return;
    }

    page++;
    oldDataLoading = true;
    progressStream.add(true);

    try {
      final search = searchController.text.trim();
      final data = await eventService.search(search, page);
      final list = data.data ?? [];
      allDataLoaded = list.isEmpty;
      events.addAll(list);
    } catch (exception) {
      allDataLoaded = true;
    }

    oldDataLoading = false;
    progressStream.add(false);
  }
}
