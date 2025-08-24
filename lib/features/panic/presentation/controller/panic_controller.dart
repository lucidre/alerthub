import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/panic/domain/usecases/panic_service.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:flutter/services.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

// PanicMode model for received panics
class PanicMode {
  final String uid;
  final bool isOnOrOff;
  final bool broadcastToCommunity;
  final bool broadcastToProviders;
  final bool broadcastToContacts;
  final double latitude;
  final double longitude;
  final int updatedAt;

  PanicMode({
    required this.uid,
    required this.isOnOrOff,
    required this.broadcastToCommunity,
    required this.broadcastToProviders,
    required this.broadcastToContacts,
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
  });

  factory PanicMode.fromJson(Map<String, dynamic> json) {
    return PanicMode(
      uid: json['uid'] ?? '',
      isOnOrOff: json['isOnOrOff'] ?? false,
      broadcastToCommunity: json['broadcastToCommunity'] ?? false,
      broadcastToProviders: json['broadcastToProviders'] ?? false,
      broadcastToContacts: json['broadcastToContacts'] ?? false,
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      updatedAt: json['updatedAt'] ?? 0,
    );
  }
}

class PanicController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final PanicService service;
  Timer? _timer;

  PanicController(this.service);

  final _isInAlert = false.obs;
  bool get isInAlert => _isInAlert.value;
  set isInAlert(bool value) => _isInAlert.value = value;

  final _broadcastToCommunity = true.obs;
  bool get broadcastToCommunity => _broadcastToCommunity.value;
  set broadcastToCommunity(bool value) {
    _broadcastToCommunity.value = value;
    _startPanicModeTimer();
  }

  final _broadcastToProviders = true.obs;
  bool get broadcastToProviders => _broadcastToProviders.value;
  set broadcastToProviders(bool value) {
    _broadcastToProviders.value = value;
    _startPanicModeTimer();
  }

  final _broadcastToContacts = true.obs;
  bool get broadcastToContacts => _broadcastToContacts.value;
  set broadcastToContacts(bool value) {
    _broadcastToContacts.value = value;
    _startPanicModeTimer();
  }

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

  // ========================= SSE PANIC LISTENING FUNCTIONALITY =========================

  // Base URL for your Spring Boot API
  static const String baseUrl =
      'http://your-server-url.com'; // Replace with your actual URL

  // Observable list of received panics from other users
  final RxList<PanicMode> receivedPanics = <PanicMode>[].obs;

  // SSE connection status
  final RxBool isSseConnected = false.obs;
  final RxBool isSseConnecting = false.obs;
  final RxString sseConnectionError = ''.obs;

  // User preferences for receiving panics
  final RxDouble maxPanicDistance = 10.0.obs; // Default 10km range

  // Private SSE variables
  http.Client? _sseHttpClient;
  StreamSubscription<String>? _sseSubscription;
  bool _isDisposed = false;

  // ========================= END SSE VARIABLES =========================

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

    // Initialize SSE panic listening
    _initializePanicListener();
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

    // Stop SSE connection
    _stopPanicListener();

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
        broadcastToCommunity: broadcastToCommunity,
        broadcastToProviders: broadcastToProviders,
        broadcastToContacts: broadcastToContacts,
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
        broadcastToCommunity: broadcastToCommunity,
        broadcastToProviders: broadcastToProviders,
        broadcastToContacts: broadcastToContacts,
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

  // ========================= SSE PANIC LISTENING METHODS =========================

  /// Initialize panic listener - starts automatically when controller is created
  Future<void> _initializePanicListener() async {
    // Wait a bit for location controller to be ready
    await Future.delayed(const Duration(milliseconds: 500));
    _startPanicListener();
  }

  /// Start listening to panic updates via SSE
  Future<void> _startPanicListener() async {
    if (isSseConnecting.value || isSseConnected.value || _isDisposed) {
      return;
    }

    try {
      // Get user location
      final locationController = Get.find<LocationController>();
      final userPosition = locationController.userPosition;

      if (userPosition == null) {
        // Retry after location is available
        Timer(const Duration(seconds: 5), () {
          if (!_isDisposed) _startPanicListener();
        });
        return;
      }

      isSseConnecting.value = true;
      sseConnectionError.value = '';

      // Create HTTP client
      _sseHttpClient = http.Client();

      // Build SSE URL with parameters
      final uri = Uri.parse('$baseUrl/api/v1/panic/listen').replace(
        queryParameters: {
          'userLatitude': userPosition.latitude.toString(),
          'userLongitude': userPosition.longitude.toString(),
          'maxDistance': maxPanicDistance.value.toString(),
        },
      );

      // Make SSE request
      final request = http.Request('GET', uri);
      request.headers['Accept'] = 'text/event-stream';
      request.headers['Cache-Control'] = 'no-cache';

      final streamedResponse = await _sseHttpClient!.send(request);

      if (streamedResponse.statusCode == 200) {
        isSseConnected.value = true;
        isSseConnecting.value = false;

        // Listen to the SSE stream
        _sseSubscription = streamedResponse.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(
              _handleSseData,
              onError: _handleSseConnectionError,
              onDone: _handleSseConnectionClosed,
            );

        debugPrint('✅ Connected to panic SSE endpoint');
      } else {
        throw HttpException(
            'Failed to connect: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      _handleSseConnectionError(e);
    }
  }

  /// Stop listening to panic updates
  void _stopPanicListener() {
    _isDisposed = true;

    _sseSubscription?.cancel();
    _sseSubscription = null;

    _sseHttpClient?.close();
    _sseHttpClient = null;

    isSseConnected.value = false;
    isSseConnecting.value = false;

    debugPrint('🔌 Disconnected from panic SSE endpoint');
  }

  /// Handle incoming SSE data
  void _handleSseData(String data) {
    if (data.isEmpty || _isDisposed) return;

    try {
      // Parse SSE format
      if (data.startsWith('data: ')) {
        final jsonData = data.substring(6); // Remove 'data: ' prefix

        if (jsonData.trim().isEmpty || jsonData.trim() == '[object Object]') {
          return;
        }

        // Parse JSON array of panic modes
        final List<dynamic> panicList = json.decode(jsonData);
        final List<PanicMode> newPanics = panicList
            .map((panicJson) => PanicMode.fromJson(panicJson))
            .toList();

        // Update the observable list
        receivedPanics.assignAll(newPanics);

        debugPrint('📱 Received ${newPanics.length} active panics nearby');

        // Handle panic updates
        _handleReceivedPanics(newPanics);
      } else if (data.startsWith('event: ')) {
        // Handle event type if needed
        final eventType = data.substring(7);
        debugPrint('📡 SSE Event: $eventType');
      }
    } catch (e) {
      debugPrint('❌ Error parsing SSE data: $e');
      debugPrint('Raw data: $data');
    }
  }

  /// Handle SSE connection errors
  void _handleSseConnectionError(dynamic error) {
    debugPrint('❌ SSE Connection error: $error');

    sseConnectionError.value = error.toString();
    isSseConnected.value = false;
    isSseConnecting.value = false;

    // Auto-reconnect after 5 seconds if not disposed
    if (!_isDisposed) {
      Timer(const Duration(seconds: 5), () {
        if (!_isDisposed && !isSseConnected.value) {
          debugPrint('🔄 Attempting to reconnect...');
          _startPanicListener();
        }
      });
    }
  }

  /// Handle SSE connection closed
  void _handleSseConnectionClosed() {
    debugPrint('🔌 SSE Connection closed');

    isSseConnected.value = false;
    isSseConnecting.value = false;

    // Auto-reconnect if not disposed
    if (!_isDisposed) {
      Timer(const Duration(seconds: 3), () {
        if (!_isDisposed && !isSseConnected.value) {
          debugPrint('🔄 Reconnecting after connection closed...');
          _startPanicListener();
        }
      });
    }
  }

  /// Handle received panics - you can customize this behavior
  void _handleReceivedPanics(List<PanicMode> panics) {
    if (panics.isNotEmpty) {
      // Show notification for nearby panics
      Get.snackbar(
        '🚨 Panic Alert',
        '${panics.length} panic(s) detected nearby',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(opacity: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        isDismissible: true,
      );

      // You can add additional logic here:
      // - Play alert sound
      // - Send push notification
      // - Update UI indicators
      // - Log to analytics
    }
  }

  /// Update max distance for receiving panics and restart connection
  void updateMaxPanicDistance(double distance) {
    maxPanicDistance.value = distance;

    if (isSseConnected.value) {
      // Restart connection with new distance
      _stopPanicListener();
      _isDisposed = false; // Reset disposed flag
      _startPanicListener();
    }
  }

  /// Manually refresh panic listener connection
  Future<void> refreshPanicListener() async {
    if (!isSseConnected.value) {
      _isDisposed = false; // Reset disposed flag
      await _startPanicListener();
    }
  }

  /// Get count of received panics
  int get receivedPanicCount => receivedPanics.length;

  /// Check if there are any received panics
  bool get hasReceivedPanics => receivedPanics.isNotEmpty;

  // ========================= END SSE PANIC LISTENING METHODS =========================
}

/* class PanicController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final PanicService service;
  Timer? _timer;

  PanicController(this.service);

  final _isInAlert = false.obs;
  bool get isInAlert => _isInAlert.value;
  set isInAlert(bool value) => _isInAlert.value = value;

  final _broadcastToCommunity = true.obs;
  bool get broadcastToCommunity => _broadcastToCommunity.value;
  set broadcastToCommunity(bool value) {
    _broadcastToCommunity.value = value;
    _startPanicModeTimer();
  }

  final _broadcastToProviders = true.obs;
  bool get broadcastToProviders => _broadcastToProviders.value;
  set broadcastToProviders(bool value) {
    _broadcastToProviders.value = value;
    _startPanicModeTimer();
  }

  final _broadcastToContacts = true.obs;
  bool get broadcastToContacts => _broadcastToContacts.value;
  set broadcastToContacts(bool value) {
    _broadcastToContacts.value = value;
    _startPanicModeTimer();
  }

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
        broadcastToCommunity: broadcastToCommunity,
        broadcastToProviders: broadcastToProviders,
        broadcastToContacts: broadcastToContacts,
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
        broadcastToCommunity: broadcastToCommunity,
        broadcastToProviders: broadcastToProviders,
        broadcastToContacts: broadcastToContacts,
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
 */

class PanicMode {
  final String uid;
  final bool isOnOrOff;
  final bool broadcastToCommunity;
  final bool broadcastToProviders;
  final bool broadcastToContacts;
  final double latitude;
  final double longitude;
  final int updatedAt;

  PanicMode({
    required this.uid,
    required this.isOnOrOff,
    required this.broadcastToCommunity,
    required this.broadcastToProviders,
    required this.broadcastToContacts,
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
  });

  factory PanicMode.fromJson(Map<String, dynamic> json) {
    return PanicMode(
      uid: json['uid'] ?? '',
      isOnOrOff: json['isOnOrOff'] ?? false,
      broadcastToCommunity: json['broadcastToCommunity'] ?? false,
      broadcastToProviders: json['broadcastToProviders'] ?? false,
      broadcastToContacts: json['broadcastToContacts'] ?? false,
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      updatedAt: json['updatedAt'] ?? 0,
    );
  }
}
