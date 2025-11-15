import 'package:alerthub/common_libs.dart';
import 'package:alerthub/features/panic/domain/usecases/panic_service.dart';
import 'package:alerthub/features/user/data/model/user_data/user.dart';
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
  final User? user; 

  PanicMode({
    required this.uid,
    required this.isOnOrOff,
    required this.broadcastToCommunity,
    required this.broadcastToProviders,
    required this.broadcastToContacts,
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
    this.user, 
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
      user: json['user'] == null ? null : User.fromMap(json['user']), 
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

  // Add timeout for debugging
  Timer? _connectionTimeout;

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

      _startPanicModeTimer();
  
    } else {
      _pulseAnimationController.stop();
      _pulseAnimationController.reset();

      if (pairedDevice != null) {
        _bluetoothController.write('0');
      }

      _stopPanicModeTimer();
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

    const duration = Duration(seconds: 3);
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
      final locationController = Get.find<LocationController>();
      final userPosition = locationController.userPosition;
      final latitude = userPosition?.latitude ?? -1;
      final longitude = userPosition?.longitude ?? -1;

      await service.panicModeToggle(
        latitude: latitude,
        longitude: longitude,
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
        

      debugPrint('XXXXX Test Time to send is:' +
          DateTime.now().milliSecondsSinceEpoch); 
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
  }

  void turnOffAlert() {
    toggleAlert();
  }

  // ========================= ENHANCED SSE PANIC LISTENING METHODS =========================

  /// Initialize panic listener - starts automatically when controller is created
  Future<void> _initializePanicListener() async {
    debugPrint('🔧 receiverPanic: Initializing panic listener...');
    // Wait a bit for location controller to be ready
    await Future.delayed(const Duration(milliseconds: 500));
    _startPanicListener();
  }

  /// Start listening to panic updates via SSE
  Future<void> _startPanicListener() async {
    if (isSseConnecting.value || isSseConnected.value || _isDisposed) {
      debugPrint('⚠️ receiverPanic: Already connecting/connected or disposed');
      return;
    }

    try {
      debugPrint('🚀 receiverPanic: Starting SSE connection...');
      
      // Get user location
      final locationController = Get.find<LocationController>();
      final userPosition = locationController.userPosition;

      if (userPosition == null) {
        debugPrint(
            '⚠️ receiverPanic: User position is null, retrying in 5 seconds');
        // Retry after location is available
        Timer(const Duration(seconds: 5), () {
          if (!_isDisposed) _startPanicListener();
        });
        return;
      }

      debugPrint(
          '📍 receiverPanic: User position - Lat: ${userPosition.latitude}, Lng: ${userPosition.longitude}');

      isSseConnecting.value = true;
      sseConnectionError.value = '';

      // Create HTTP client with timeout
      _sseHttpClient = http.Client();

      // Build SSE URL with parameters
      final uri =
          Uri.parse('https://alerthub-server.onrender.com/api/v1/panic/listen')
              .replace(
        queryParameters: { 
          'userLatitude': userPosition.latitude.toString(),
          'userLongitude': userPosition.longitude.toString(),
          'maxDistance': maxPanicDistance.value.toString(),
        },
      );

      debugPrint('🌐 receiverPanic: Connecting to: $uri');

      // Make SSE request with proper headers
      final request = http.Request('GET', uri);
      request.headers['Accept'] = 'text/event-stream';
      request.headers['Cache-Control'] = 'no-cache';
      request.headers['Connection'] = 'keep-alive';

      // Add timeout
      _connectionTimeout = Timer(const Duration(seconds: 30), () {
        debugPrint('⏰ receiverPanic: Connection timeout after 30 seconds');
        _handleSseConnectionError('Connection timeout');
      });

      final streamedResponse = await _sseHttpClient!.send(request);
      _connectionTimeout?.cancel();

      debugPrint(
          '📡 receiverPanic: Response status: ${streamedResponse.statusCode}');
      debugPrint(
          '📡 receiverPanic: Response headers: ${streamedResponse.headers}');

      if (streamedResponse.statusCode == 200) {
        isSseConnected.value = true;
        isSseConnecting.value = false;

        debugPrint('✅ receiverPanic: Connected successfully to SSE endpoint');

        // Listen to the SSE stream with enhanced error handling
        _sseSubscription = streamedResponse.stream
            .timeout(
              const Duration(minutes: 5), // Stream timeout
              onTimeout: (sink) {
                debugPrint(
                    '⏰ receiverPanic: Stream timeout, attempting reconnection');
                sink.close();
              },
            )
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(
              (data) {
                debugPrint('📥 receiverPanic: Raw SSE data received: "$data"');
                _handleSseData(data);
              },
              onError: (error) {
                debugPrint('❌ receiverPanic: Stream error: $error');
                _handleSseConnectionError(error);
              },
              onDone: () {
                debugPrint('🔌 receiverPanic: Stream closed by server');
                _handleSseConnectionClosed();
              },
            );

        debugPrint('👂 receiverPanic: Now listening for panic events...');
      } else {
        final responseBody = await streamedResponse.stream.bytesToString();
        debugPrint(
            '❌ receiverPanic: Server responded with ${streamedResponse.statusCode}');
        debugPrint('❌ receiverPanic: Response body: $responseBody');
        throw HttpException(
            'Failed to connect: ${streamedResponse.statusCode} - $responseBody');
      }
    } catch (e) {
      debugPrint('💥 receiverPanic: Exception during connection: $e');
      _connectionTimeout?.cancel();
      _handleSseConnectionError(e);
    }
  }

  /// Stop listening to panic updates
  void _stopPanicListener() {
    debugPrint('🛑 receiverPanic: Stopping panic listener...');
    _isDisposed = true;

    _connectionTimeout?.cancel();
    _connectionTimeout = null;

    _sseSubscription?.cancel();
    _sseSubscription = null;

    _sseHttpClient?.close();
    _sseHttpClient = null;

    isSseConnected.value = false;
    isSseConnecting.value = false;

    debugPrint('🔌 receiverPanic: Disconnected from panic SSE endpoint');
  }

  /// Handle incoming SSE data
  void _handleSseData(String data) {
    if (data.isEmpty || _isDisposed) return;
    

    debugPrint('🔍 receiverPanic: Processing data: "$data"');

    try {
      // Handle different SSE message types
      if (data.startsWith('data:')) {
        String jsonData = data.substring(6).trim(); // Remove 'data: ' prefix
        debugPrint('📄 receiverPanic: JSON data: "$jsonData"');

        if (jsonData.isEmpty || jsonData == '[object Object]') {
          debugPrint('⚠️ receiverPanic: Empty or invalid JSON data, skipping');
          return;
        }

        // Handle heartbeat or ping messages
        if (jsonData == 'ping' || jsonData == 'heartbeat') {
          debugPrint('XXXXX Test Time to send is:' +
              DateTime.now().milliSecondsSinceEpoch);
          debugPrint('💓 receiverPanic: Received heartbeat');
          return;
        }

        jsonData = data.split('data:')[1].trim();
        // Parse JSON array of panic modes
        dynamic parsedData = json.decode(jsonData);

        debugPrint('💓 receiverPanic2: $jsonData');

        if (parsedData is List) {
          final List<PanicMode> newPanics = parsedData
              .map((panicJson) => PanicMode.fromJson(panicJson))
              .toList(); 
          debugPrint('💓 receiverPanic23: $jsonData');

          debugPrint('XXXXX Test Time to receive data is:' +
              DateTime.now().milliSecondsSinceEpoch); 

          // Update the observable list
          receivedPanics.assignAll(newPanics);

          debugPrint(
              '📱 receiverPanic: Received ${newPanics.length} active panics nearby');

          // Handle panic updates
          _handleReceivedPanics(newPanics);

          if (pairedDevice != null) {
            _bluetoothController.write(receivedPanics.isEmpty ? '2' : '3');
          }
        } else if (parsedData is Map<String, dynamic>) {
          // Single panic object
          final panic = PanicMode.fromJson(parsedData);
          receivedPanics.assignAll([panic]);
          debugPrint('📱 receiverPanic: Received 1 panic nearby');
          _handleReceivedPanics([panic]);
        }
        
      } else if (data.startsWith('event: ')) {
        // Handle event type
        final eventType = data.substring(7).trim();
        debugPrint('📡 receiverPanic: SSE Event type: $eventType');
      } else if (data.startsWith('id: ')) {
        // Handle message ID
        final messageId = data.substring(4).trim();
        debugPrint('🆔 receiverPanic: Message ID: $messageId');
      } else if (data.startsWith('retry: ')) {
        // Handle retry interval
        final retryMs = data.substring(7).trim();
        debugPrint('🔄 receiverPanic: Retry interval: ${retryMs}ms');
      } else if (data.trim().isEmpty) {
        // Empty line indicates end of message
        debugPrint('📝 receiverPanic: End of SSE message');
      } else {
        debugPrint('❓ receiverPanic: Unknown SSE data format: "$data"');
      }
      
    } catch (e, stackTrace) {
      debugPrint('❌ receiverPanic: Error parsing SSE data: $e');
      debugPrint('❌ receiverPanic: Stack trace: $stackTrace');
      debugPrint('❌ receiverPanic: Raw data causing error: "$data"');
    }
  }

  /// Handle SSE connection errors
  void _handleSseConnectionError(dynamic error) {
    debugPrint('💥 receiverPanic: SSE Connection error: $error');

    sseConnectionError.value = error.toString();
    isSseConnected.value = false;
    isSseConnecting.value = false;

    _connectionTimeout?.cancel();

    if (pairedDevice != null) {
      _bluetoothController.write('2');
    }


    // Auto-reconnect after 5 seconds if not disposed
    if (!_isDisposed) {
      debugPrint('🔄 receiverPanic: Scheduling reconnection in 5 seconds...');
      Timer(const Duration(seconds: 5), () {
        if (!_isDisposed && !isSseConnected.value) {
          debugPrint('🔄 receiverPanic: Attempting to reconnect...');
          _startPanicListener();
        }
      });
    }
  }

  /// Handle SSE connection closed
  void _handleSseConnectionClosed() {
    if (pairedDevice != null) {
      _bluetoothController.write('2');
    }

    debugPrint('🔌 receiverPanic: SSE Connection closed by server');

    isSseConnected.value = false;
    isSseConnecting.value = false;

    // Auto-reconnect if not disposed
    if (!_isDisposed) {
      debugPrint('🔄 receiverPanic: Scheduling reconnection in 3 seconds...');
      Timer(const Duration(seconds: 3), () {
        if (!_isDisposed && !isSseConnected.value) {
          debugPrint(
              '🔄 receiverPanic: Reconnecting after connection closed...');
          _startPanicListener();
        }
      });
    }
  }

  /// Handle received panics - you can customize this behavior
  void _handleReceivedPanics(List<PanicMode> panics) {
    debugPrint('🚨 receiverPanic: Handling ${panics.length} received panics');

    if (panics.isNotEmpty) {
      // Show notification for nearby panics
      Get.snackbar(
        '🚨 Panic Alert',
        '${panics.length} panic(s) detected nearby',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        isDismissible: true,
      );
    }

    if (pairedDevice != null) {
      _bluetoothController.write(receivedPanics.isEmpty ? '2' : '3');
    }
  }

  /// Update max distance for receiving panics and restart connection
  void updateMaxPanicDistance(double distance) {
    debugPrint(
        '📏 receiverPanic: Updating max panic distance to ${distance}km');
    maxPanicDistance.value = distance;

    if (isSseConnected.value) {
      debugPrint('🔄 receiverPanic: Restarting connection with new distance');
      // Restart connection with new distance
      _stopPanicListener();
      _isDisposed = false; // Reset disposed flag
      _startPanicListener();
    }
  }

  /// Manually refresh panic listener connection
  Future<void> refreshPanicListener() async {
    debugPrint('🔄 receiverPanic: Manual refresh requested');
    if (!isSseConnected.value) {
      _isDisposed = false; // Reset disposed flag
      await _startPanicListener();
    } else {
      debugPrint('ℹ️ receiverPanic: Already connected, no refresh needed');
    }
  }

  /// Test the SSE endpoint manually
  Future<void> testSseEndpoint() async {
    try {
      final locationController = Get.find<LocationController>();
      final userPosition = locationController.userPosition;

      if (userPosition == null) {
        debugPrint('❌ receiverPanic: Cannot test - no user position');
        return;
      }

      final uri =
          Uri.parse('https://alerthub-server.onrender.com/api/v1/panic/listen')
              .replace(
        queryParameters: {
          'userLatitude': userPosition.latitude.toString(),
          'userLongitude': userPosition.longitude.toString(),
          'maxDistance': maxPanicDistance.value.toString(),
        },
      );

      debugPrint('🧪 receiverPanic: Testing endpoint: $uri');

      final response = await http.get(uri);
      debugPrint(
          '🧪 receiverPanic: Test response status: ${response.statusCode}');
      debugPrint(
          '🧪 receiverPanic: Test response headers: ${response.headers}');
      debugPrint('🧪 receiverPanic: Test response body: ${response.body}');
    } catch (e) {
      debugPrint('🧪 receiverPanic: Test failed: $e');
    }
  }

  /// Get count of received panics
  int get receivedPanicCount => receivedPanics.length;

  /// Check if there are any received panics
  bool get hasReceivedPanics => receivedPanics.isNotEmpty;

  // ========================= END SSE PANIC LISTENING METHODS =========================
}
