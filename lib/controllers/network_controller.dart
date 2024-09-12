import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectionStatusController extends GetxController {
  static final ConnectionStatusController instance = Get.find();

  final RxBool _hasConnection = true.obs;
  bool get hasConnection => _hasConnection.value;

  final _connectivity = Connectivity();
  ConnectionStatusController() {
    checkConnection();
    _connectivity.onConnectivityChanged.listen(connectionChangeListener);
  }

  connectionChangeListener(List<ConnectivityResult> connectivityResults) {
    final availiableNetwork = connectivityResults.firstWhereOrNull((element) =>
        element == ConnectivityResult.ethernet ||
        element == ConnectivityResult.mobile ||
        element == ConnectivityResult.wifi);

    final newStatus = availiableNetwork != null;

    if (newStatus != hasConnection) {
      _hasConnection(newStatus);
    }
  }

  checkConnection() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    connectionChangeListener(connectivityResults);
  }
}
