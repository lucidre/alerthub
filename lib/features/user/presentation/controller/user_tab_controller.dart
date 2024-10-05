import 'package:alerthub/features/event/data/model/event/event.dart';
import 'package:alerthub/features/user/data/model/user_data/user.dart';
import 'package:alerthub/features/user/domain/usecases/user_service.dart';
import 'package:alerthub/common_libs.dart';

class UserTabController extends GetxController {
  final UserService userService;
  UserTabController(this.userService);

  /// user profile events (upe)
  final RxInt _upePage = 0.obs;
  final RxBool _upeIsLoading = true.obs;
  final RxBool _upeHasError = false.obs;
  final RxBool _upeOldDataLoading = false.obs;
  final RxBool _upeAllDataLoaded = false.obs;

  final RxList<Event> _upeEvents = <Event>[].obs;

  int get upePage => _upePage.value;
  bool get upeIsLoading => _upeIsLoading.value;
  bool get upeHasError => _upeHasError.value;
  bool get upeOldDataLoading => _upeOldDataLoading.value;
  bool get upeAllDataLoaded => _upeAllDataLoaded.value;
  List<Event> get upeEvents => _upeEvents;

  set upeIsLoading(bool value) => _upeIsLoading.value = value;
  set upeHasError(bool value) => _upeHasError.value = value;
  set upeOldDataLoading(bool value) => _upeOldDataLoading.value = value;
  set upeAllDataLoaded(bool value) => _upeAllDataLoaded.value = value;

  /// user profile card (upc)
  final RxBool _upcIsLoading = true.obs;
  final RxBool _upcHasError = false.obs;
  final Rxn<User> _upcUserModel = Rxn();

  bool get upcIsLoading => _upcIsLoading.value;
  bool get upcHasError => _upcHasError.value;
  User? get upcUserModel => _upcUserModel.value;

  set upcIsLoading(bool value) => _upcIsLoading.value = value;
  set upcHasError(bool value) => _upcHasError.value = value;
  set upcUserModel(User? profile) => _upcUserModel.value = profile;

  addUpeEvents(List<Event> events) {
    _upeEvents.addAll(events);
    _upeEvents.refresh();
  }

  clearUpEvents() {
    _upeEvents.clear();
    _upeEvents.refresh();
  }

  getUpData() async {
    _upePage(0);
    upeIsLoading = true;
    upeHasError = false;
    clearUpEvents();

    try {
      final data = await userService.getUserEvents(upePage);
      final list = data.data ?? [];

      addUpeEvents(list);
      upeAllDataLoaded = list.isEmpty;
      upeHasError = false;
      upeIsLoading = false;
    } catch (exception) {
      upeHasError = true;
      upeIsLoading = false;
      return Future.error(exception.toString());
    }
  }

  getUpOldData(StreamController<bool> progressStream) async {
    if (upeIsLoading ||
        upeAllDataLoaded ||
        !upeEvents.isNotEmpty ||
        upeOldDataLoading) {
      return;
    }
    _upePage(upePage + 1);
    upeOldDataLoading = true;
    progressStream.add(true);

    try {
      final data = await userService.getUserEvents(upePage);
      final list = data.data ?? [];
      upeAllDataLoaded = list.isEmpty;
      addUpeEvents(list);
      upeOldDataLoading = false;
      progressStream.add(false);
    } catch (exception) {
      upeAllDataLoaded = true;
      upeOldDataLoading = false;
      return Future.error(exception.toString());
    }
  }

  Future<void> getUpcData() async {
    upcIsLoading = true;
    upcHasError = false;
    upcUserModel = null;

    try {
      final user = await userService.getUser();
      upcUserModel = user.data;
      upcHasError = false;
      upcIsLoading = false;
    } catch (exception) {
      upcHasError = true;
      upcIsLoading = false;
      return Future.error(exception.toString());
    }
  }
}
