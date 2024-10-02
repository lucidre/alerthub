import 'package:alerthub/api/network_utils.dart';
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/models/event/event.dart';
import 'package:alerthub/models/user_data/user.dart';

class ProfileController extends GetxController {
  final RxInt _upPage = 0.obs;
  final RxBool _upIsLoading = true.obs;
  final RxBool _upHasError = false.obs;
  final RxBool _upOldDataLoading = false.obs;
  final RxBool _upAllDataLoaded = false.obs;

  final RxList<Event> _upEvents = <Event>[].obs;

  int get upPage => _upPage.value;
  bool get upIsLoading => _upIsLoading.value;
  bool get upHasError => _upHasError.value;
  bool get upOldDataLoading => _upOldDataLoading.value;
  bool get upAllDataLoaded => _upAllDataLoaded.value;
  List<Event> get upEvents => _upEvents;

  setUpIsLoading(value) => _upIsLoading(value);
  setUpHasError(value) => _upHasError(value);
  setUpOldDataLoading(value) => _upOldDataLoading(value);
  setUpAllDataLoaded(value) => _upAllDataLoaded(value);

  addUpEvents(List<Event> events) {
    _upEvents.addAll(events);
    _upEvents.refresh();
  }

  clearUpEvents() {
    _upEvents.clear();
    _upEvents.refresh();
  }

  getUpData() async {
    _upPage(0);
    setUpIsLoading(true);
    setUpHasError(false);
    clearUpEvents();

    try {
      final data = await $networkUtil.getUserEvents(upPage);
      final list = data.data ?? [];

      addUpEvents(list);
      setUpAllDataLoaded(list.isEmpty);
      setUpHasError(false);
      setUpIsLoading(false);
    } catch (exception) {
      setUpHasError(true);
      setUpIsLoading(false);
      return Future.error(exception.toString());
    }
  }

  getUpOldData(StreamController<bool> progressStream) async {
    if (upIsLoading ||
        upAllDataLoaded ||
        !upEvents.isNotEmpty ||
        upOldDataLoading) {
      return;
    }
    _upPage(upPage + 1);
    setUpOldDataLoading(true);
    progressStream.add(true);

    try {
      final data = await $networkUtil.getUserEvents(upPage);
      final list = data.data ?? [];
      setUpAllDataLoaded(list.isEmpty);
      addUpEvents(list);
      setUpOldDataLoading(false);
      progressStream.add(false);
    } catch (exception) {
      setUpAllDataLoaded(true);
      setUpOldDataLoading(false);
      return Future.error(exception.toString());
    }
  }

  /// user profile card
  final RxBool _upcIsLoading = true.obs;
  final RxBool _upcHasError = false.obs;
  final Rxn<User> _userModel = Rxn();

  bool get upcIsLoading => _upcIsLoading.value;
  bool get upcHasError => _upcHasError.value;
  User? get userModel => _userModel.value;

  setUpcIsLoading(value) => _upcIsLoading(value);
  setUpcHasError(value) => _upcHasError(value);
  setUserProfile(profile) => _userModel.value = profile;

  getUpcData() async {
    setUpcIsLoading(true);
    setUpcHasError(false);
    setUserProfile(null);

    try {
      final user = await $networkUtil.getUser();
      setUserProfile(user.data);
      setUpcHasError(false);
      setUpcIsLoading(false);
    } catch (exception) {
      setUpcHasError(true);
      setUpcIsLoading(false);
      return Future.error(exception.toString());
    }
  }
}
