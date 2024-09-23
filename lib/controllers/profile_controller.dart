import 'package:alerthub/api/firebase_util.dart';
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/models/event/event.dart';
import 'package:alerthub/models/user/user_model.dart';

class ProfileController extends GetxController {
  final RxBool _upIsLoading = true.obs;
  final RxBool _upHasError = false.obs;
  final RxBool _upOldDataLoading = false.obs;
  final RxBool _upAllDataLoaded = false.obs;

  final RxList<EventModel> _upEvents = <EventModel>[].obs;

  bool get upIsLoading => _upIsLoading.value;
  bool get upHasError => _upHasError.value;
  bool get upOldDataLoading => _upOldDataLoading.value;
  bool get upAllDataLoaded => _upAllDataLoaded.value;
  List<EventModel> get upEvents => _upEvents;

  setUpIsLoading(value) => _upIsLoading(value);
  setUpHasError(value) => _upHasError(value);
  setUpOldDataLoading(value) => _upOldDataLoading(value);
  setUpAllDataLoaded(value) => _upAllDataLoaded(value);

  addUpEvents(List<EventModel> events) {
    _upEvents.addAll(events);
    _upEvents.refresh();
  }

  clearUpEvents() {
    _upEvents.clear();
    _upEvents.refresh();
  }

  getUpData() async {
    setUpIsLoading(true);
    setUpHasError(false);
    clearUpEvents();

    try {
      final data = await $firebaseUtil.getUserEvents();
      addUpEvents(data);
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

    setUpOldDataLoading(true);
    progressStream.add(true);

    try {
      final data = await $firebaseUtil.getUserEvents(upEvents.last.updatedAt);
      setUpAllDataLoaded(data.isEmpty);
      addUpEvents(data);
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
  final Rxn<UserModel> _userModel = Rxn();

  bool get upcIsLoading => _upcIsLoading.value;
  bool get upcHasError => _upcHasError.value;
  UserModel? get userModel => _userModel.value;

  setUpcIsLoading(value) => _upcIsLoading(value);
  setUpcHasError(value) => _upcHasError(value);
  setUserProfile(profile) => _userModel.value = profile;

  getUpcData() async {
    setUpcIsLoading(true);
    setUpcHasError(false);
    setUserProfile(null);

    try {
      final user = await $firebaseUtil.getUserProfile();

      setUserProfile(user);
      setUpcHasError(false);
      setUpcIsLoading(false);
    } catch (exception) {
      setUpcHasError(true);
      setUpcIsLoading(false);
      return Future.error(exception.toString());
    }
  }
}
