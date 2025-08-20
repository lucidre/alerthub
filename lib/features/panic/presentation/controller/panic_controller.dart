import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/panic/domain/usecases/panic_service.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:flutter/services.dart';

class PanicController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final PanicService service;
  Timer? _timer;

  PanicController(this.service);

  final _isInAlert = false.obs;
  bool get isInAlert => _isInAlert.value;
  set isInAlert(bool value) => _isInAlert.value = value;

  final _broadcastToCommunity = false.obs;
  bool get broadcastToCommunity => _broadcastToCommunity.value;
  set broadcastToCommunity(bool value) => _broadcastToCommunity.value = value;

  final _broadcastToProviders = false.obs;
  bool get broadcastToProviders => _broadcastToProviders.value;
  set broadcastToProviders(bool value) => _broadcastToProviders.value = value;

  final _broadcastToFamily = false.obs;
  bool get broadcastToFamily => _broadcastToFamily.value;
  set broadcastToFamily(bool value) => _broadcastToFamily.value = value;

  late AnimationController _pulseAnimationController;
  late Animation<double> pulseAnimation;

  final _bluetoothController = BluetoothClassic();

  final _deviceStatus = Device.disconnected.obs;
  int get deviceStatus => _deviceStatus.value;
  set deviceStatus(int value) => _deviceStatus.value = value;

  final _data = Uint8List(0).obs;
  Uint8List get data => _data.value;
  set data(Uint8List value) => _data.value = value;

  final _devices = RxList<Device>();
  List<Device> get devices => _devices;
  set devices(List<Device> list) => _devices.assignAll(list);

  final _discoveredDevices = RxList<Device>();
  List<Device> get discoveredDevices => _discoveredDevices;
  set discoveredDevices(List<Device> devices) =>
      _discoveredDevices.assignAll(devices);

  final _scanning = false.obs;
  bool get scanning => _scanning.value;
  set scanning(bool value) => _scanning.value = value;

  final _deviceString = RxnString();
  String? get deviceString => _deviceString.value;
  set deviceString(String? value) => _deviceString.value = value;

  final _discoveredString = RxnString();
  String? get discoveredString => _discoveredString.value;
  set discoveredString(String? value) => _discoveredString.value = value;

  final Rxn<Device> _pairedDevice = Rxn<Device>();

  Device? get pairedDevice => _pairedDevice.value;
  set pairedDevice(Device? device) => _pairedDevice.value = device;

  @override
  void onInit() {
    super.onInit();

    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000), // 1 second pulse
      vsync: this,
    );

    pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    _initializeBluetooth();
  }

  Future<void> _initializeBluetooth() async {
    try {
      await _bluetoothController.initPermissions();
    } catch (_) {}

    getDevices();
    scan();
    _bluetoothController
        .onDeviceStatusChanged()
        .listen((event) => deviceStatus = event);

    _bluetoothController.onDeviceDataReceived().listen((event) {
      data = Uint8List.fromList([...data, ...event]);
      debugPrint("statement");
      debugPrint(String.fromCharCodes(event));
      final value = String.fromCharCodes(event);

      if (value.trim() == 'ALERT LED OFF!' && isInAlert) {
        toggleAlert();
      } else if (value.trim() == 'ALERT LED ON!' && !isInAlert) {
        toggleAlert();
      }
    });
  }

  Future<void> getDevices() async {
    final list = await _bluetoothController.getPairedDevices();
    devices = list;
    deviceString = UniqueKey().toString();
  }

  Future<void> scan() async {
    if (scanning) {
      await _bluetoothController.stopScan();
      scanning = false;
    } else {
      await _bluetoothController.startScan();
      _bluetoothController.onDeviceDiscovered().listen(
        (event) {
          discoveredDevices = [...discoveredDevices, event];
        },
      );

      scanning = true;
    }
    discoveredString = UniqueKey().toString();
  }

  disconnect() => _bluetoothController.disconnect();

  onTapDevice(Device device) async {
    try {
      await _bluetoothController.disconnect();
    } catch (_) {}

    final value = await _bluetoothController.connect(
        device.address, "00001101-0000-1000-8000-00805f9b34fb");

    if (value) {
      pairedDevice = device;
      deviceStatus = Device.connected;
    }
  }

  void toggleAlert() {
    isInAlert = !isInAlert;

    if (isInAlert) {
      _pulseAnimationController.repeat(reverse: true);

      if (pairedDevice != null) {
        _bluetoothController.write('1');
      }
    } else {
      _pulseAnimationController.stop();
      _pulseAnimationController.reset();

      if (pairedDevice != null) {
        _bluetoothController.write('0');
      }
    }

    update();
  }

  @override
  void onClose() {
    _pulseAnimationController.dispose();
    _stopPanicModeTimer();
    super.onClose();
  }

  void _startPanicModeTimer() {
    _stopPanicModeTimer();
    _callPanicModeToggle();

    const duration = Duration(minutes: 1);
    _timer = Timer.periodic(duration, (_) {
      if (isInAlert) {
        _callPanicModeToggle();
      } else {
        _stopPanicModeTimer();
      }
    });
  }

  void _stopPanicModeTimer() async {
    _timer?.cancel();
    _timer = null;

    try {
      await service.panicModeToggle(
        latitude: -1,
        longitude: -1,
        isOnOrOff: false,
      );
    } catch (exception) {
      //
    }
  }

  void _callPanicModeToggle() async {
    try {
      final locationController = Get.find<LocationController>();
      final userPosition = locationController.userPosition;
      final latitude = userPosition?.latitude ?? -1;
      final longitude = userPosition?.longitude ?? -1;

      await service.panicModeToggle(
        latitude: latitude,
        longitude: longitude,
        isOnOrOff: true,
      );
    } catch (exception) {
      // Handle exception - you might want to add logging here
    }
  }

  void turnOnAlert() async {
    toggleAlert();
    _startPanicModeTimer();
  }

  void turnOffAlert() {
    toggleAlert();
    _stopPanicModeTimer();
  }

  //TODO FIGURE OUT A WAY TO RECEIVE THE PANIC IN YOUR ENVIROMENT.
}
