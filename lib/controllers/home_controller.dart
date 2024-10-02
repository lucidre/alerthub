import 'package:alerthub/api/network_utils.dart';
import 'package:alerthub/common_libs.dart';
import 'package:alerthub/models/event/event.dart';
import 'package:alerthub/models/user_data/user.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxList<Event> _ongoingEvents = <Event>[].obs;
  final RxInt _ongoingPage = 0.obs;
  final RxBool _ongoingIsLoading = true.obs;
  final RxBool _ongoingHasError = false.obs;
  final RxBool _ongoingAllDataLoaded = false.obs;
  final RxBool _ongoingOldDataLoading = false.obs;
  final RxBool _ongoingIsRefreshing = false.obs;

  List<Event> get ongoingEvents => _ongoingEvents;
  int get ongoingPage => _ongoingPage.value;
  bool get ongoingIsLoading => _ongoingIsLoading.value;
  bool get ongoingHasError => _ongoingHasError.value;
  bool get ongoingAllDataLoaded => _ongoingAllDataLoaded.value;
  bool get ongoingOldDataLoading => _ongoingOldDataLoading.value;
  bool get ongoingIsRefreshing => _ongoingIsRefreshing.value;

  setOngoingIsLoading(value) => _ongoingIsLoading(value);
  setOngoingHasError(value) => _ongoingHasError(value);
  setOngoingAllDataLoaded(value) => _ongoingAllDataLoaded(value);
  setOngoingOldDataLoading(value) => _ongoingOldDataLoading(value);
  setOngoingIsRefreshing(value) => _ongoingIsRefreshing(value);

  addOngoingEvents(List<Event> events) {
    _ongoingEvents.addAll(events);
    _ongoingEvents.refresh();
  }

  clearOngoingEvents() {
    _ongoingEvents.clear();
    _ongoingEvents.refresh();
  }

  getOngoingData() async {
    _ongoingPage(0);
    setOngoingIsLoading(true);
    setOngoingHasError(false);
    clearOngoingEvents();

    try {
      final data = await $networkUtil.ongoing(ongoingPage);
      final list = data.data ?? [];

      addOngoingEvents(list);
      setOngoingAllDataLoaded(list.isEmpty);
      setOngoingHasError(false);
      setOngoingIsLoading(false);
    } catch (exception) {
      setOngoingHasError(true);
      setOngoingIsLoading(false);
      return Future.error(exception.toString());
    }
  }

  getOngoingOldData(StreamController<bool> progressStream) async {
    if (ongoingIsLoading ||
        ongoingAllDataLoaded ||
        !ongoingEvents.isNotEmpty ||
        ongoingOldDataLoading) {
      return;
    }
    _ongoingPage(ongoingPage + 1);
    setOngoingOldDataLoading(true);
    progressStream.add(true);

    try {
      final data = await $networkUtil.ongoing(ongoingPage);
      final list = data.data ?? [];
      setOngoingAllDataLoaded(list.isEmpty);
      addOngoingEvents(list);
      setOngoingOldDataLoading(false);
      progressStream.add(false);
    } catch (exception) {
      setOngoingAllDataLoaded(true);
      setOngoingOldDataLoading(false);
      return Future.error(exception.toString());
    }
  }

  final nearByRadius = 500;
  final RxList<Event> _nearbyEvents = <Event>[].obs;
  final RxInt _nearbyPage = 0.obs;
  final RxBool _nearbyIsLoading = true.obs;
  final RxBool _nearbyHasError = false.obs;
  final RxBool _nearbyAllDataLoaded = false.obs;
  final RxBool _nearbyOldDataLoading = false.obs;
  final RxBool _nearbyIsRefreshing = false.obs;

  List<Event> get nearbyEvents => _nearbyEvents;
  int get nearbyPage => _nearbyPage.value;
  bool get nearbyIsLoading => _nearbyIsLoading.value;
  bool get nearbyHasError => _nearbyHasError.value;
  bool get nearbyAllDataLoaded => _nearbyAllDataLoaded.value;
  bool get nearbyOldDataLoading => _nearbyOldDataLoading.value;
  bool get nearbyIsRefreshing => _nearbyIsRefreshing.value;

  setNearbyIsLoading(value) => _nearbyIsLoading(value);
  setNearbyHasError(value) => _nearbyHasError(value);
  setNearbyAllDataLoaded(value) => _nearbyAllDataLoaded(value);
  setNearbyOldDataLoading(value) => _nearbyOldDataLoading(value);
  setNearbyIsRefreshing(value) => _nearbyIsRefreshing(value);

  addNearbyEvents(List<Event> events) {
    _nearbyEvents.addAll(events);
    _nearbyEvents.refresh();
  }

  clearNearbyEvents() {
    _nearbyEvents.clear();
    _nearbyEvents.refresh();
  }

  getNearbyData() async {
    _nearbyPage(0);
    setNearbyIsLoading(true);
    setNearbyHasError(false);
    clearNearbyEvents();

    try {
      final controller = Get.find<LocationController>();
      await controller.initLocationUpdate();
      final currentLocation = controller.userPosition;
      final lat = currentLocation?.latitude;
      final lng = currentLocation?.longitude;

      final data = await $networkUtil.nearby(
        radius: nearByRadius,
        lat: lat ?? -1,
        lng: lng ?? -1,
        page: nearbyPage,
      );
      final list = data.data ?? [];

      addNearbyEvents(list);
      setNearbyAllDataLoaded(list.isEmpty);
      setNearbyHasError(false);
      setNearbyIsLoading(false);
    } catch (exception) {
      setNearbyHasError(true);
      setNearbyIsLoading(false);
      return Future.error(exception.toString());
    }
  }

  getNearbyOldData(StreamController<bool> progressStream) async {
    if (nearbyIsLoading ||
        nearbyAllDataLoaded ||
        !nearbyEvents.isNotEmpty ||
        nearbyOldDataLoading) {
      return;
    }
    _nearbyPage(nearbyPage + 1);
    setNearbyOldDataLoading(true);
    progressStream.add(true);

    try {
      final controller = Get.find<LocationController>();
      await controller.initLocationUpdate();
      final currentLocation = controller.userPosition;
      final lat = currentLocation?.latitude;
      final lng = currentLocation?.longitude;

      final data = await $networkUtil.nearby(
        radius: nearByRadius,
        lat: lat ?? -1,
        lng: lng ?? -1,
        page: nearbyPage,
      );
      final list = data.data ?? [];
      setNearbyAllDataLoaded(list.isEmpty);
      addNearbyEvents(list);
      setNearbyOldDataLoading(false);
      progressStream.add(false);
    } catch (exception) {
      setNearbyAllDataLoaded(true);
      setNearbyOldDataLoading(false);
      return Future.error(exception.toString());
    }
  }

  final Rxn<User> _user = Rxn();

  User? get user => _user.value;

  deleteUserData() {
    _user.value = null;
    AppPreferences.logOutUser();
  }

  initUserData() {
    final user = AppPreferences.userData;
    if (user != null) {
      _user(user);
    }
  }

  getUser() async {
    try {
      final data = await $networkUtil.getUser();
      final user = data.data;
      if (user != null) {
        AppPreferences.setUserData(user: user);
        _user(user);
      }
    } catch (_) {}
  }
}
