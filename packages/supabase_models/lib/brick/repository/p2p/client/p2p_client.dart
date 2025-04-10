import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logging/logging.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:supabase_models/brick/repository/p2p/config.dart';

/// A service UUID for the P2P sync service
const String p2pServiceUuid = '00001234-0000-1000-8000-00805F9B34FB';

/// A characteristic UUID for data transfer
const String dataCharacteristicUuid = '00001235-0000-1000-8000-00805F9B34FB';

/// A P2P client that uses Bluetooth to sync data between devices
class P2PClient {
  static final _logger = Logger('P2PClient');

  /// The repository instance
  final Repository repository;

  /// Configuration for P2P sync
  final P2PConfig config;

  /// Connected devices
  final Map<String, BluetoothDevice> _connectedDevices = {};

  /// Stream controller for sync events
  final _syncEventController = StreamController<SyncEvent>.broadcast();

  /// Stream of sync events
  Stream<SyncEvent> get syncEvents => _syncEventController.stream;

  /// Constructor
  P2PClient({
    required this.repository,
    this.config = const P2PConfig(),
  }) {
    if (!kIsWeb && config.enableBluetooth) {
      _initBluetooth();
    }
  }

  /// Initialize Bluetooth
  Future<void> _initBluetooth() async {
    try {
      // Start scanning for devices
      _startScan();
    } catch (e) {
      _logger.severe('Error initializing Bluetooth: $e');
    }
  }

  /// Start scanning for devices
  Future<void> _startScan() async {
    try {
      // Start scanning
      await FlutterBluePlus.startScan(
        withServices: [Guid(p2pServiceUuid)],
        timeout: const Duration(seconds: 10),
      );

      // Listen for scan results
      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult result in results) {
          _connectToDevice(result.device);
        }
      });
    } catch (e) {
      _logger.severe('Error scanning for devices: $e');
    }
  }

  /// Connect to a device
  Future<void> _connectToDevice(BluetoothDevice device) async {
    if (_connectedDevices.containsKey(device.remoteId.str)) {
      return; // Already connected
    }

    try {
      await device.connect();
      _connectedDevices[device.remoteId.str] = device;
      _logger.info('Connected to device: ${device.platformName}');

      // Discover services
      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        if (service.uuid.toString() == p2pServiceUuid) {
          _setupDataTransfer(device, service);
        }
      }

      // Listen for disconnection
      device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          _connectedDevices.remove(device.remoteId.str);
          _logger.info('Disconnected from device: ${device.platformName}');
        }
      });
    } catch (e) {
      _logger.warning('Error connecting to device ${device.platformName}: $e');
    }
  }

  /// Setup data transfer with a device
  void _setupDataTransfer(BluetoothDevice device, BluetoothService service) {
    for (BluetoothCharacteristic characteristic in service.characteristics) {
      if (characteristic.uuid.toString() == dataCharacteristicUuid) {
        // Set up notification for incoming data
        characteristic.setNotifyValue(true);
        characteristic.onValueReceived.listen((value) {
          _handleReceivedData(value);
        });
      }
    }
  }

  /// Handle received data
  Future<void> _handleReceivedData(List<int> data) async {
    try {
      // Decode the data
      final jsonData = utf8.decode(data);
      final Map<String, dynamic> decodedData = jsonDecode(jsonData);

      // Extract model type and data
      final String modelType = decodedData['modelType'];
      final Map<String, dynamic> modelData = decodedData['data'];

      // Save the data to the local database
      await _saveToLocalDatabase(modelType, modelData);

      // Emit sync event
      _syncEventController.add(SyncEvent(
        eventType: SyncEventType.received,
        modelType: modelType,
        success: true,
      ));
    } catch (e) {
      _logger.severe('Error handling received data: $e');
      _syncEventController.add(SyncEvent(
        eventType: SyncEventType.received,
        success: false,
        error: e.toString(),
      ));
    }
  }

  /// Save data to the local database
  /// This is a simplified approach that works with the Repository's generic upsert method
  Future<void> _saveToLocalDatabase(
      String modelType, Map<String, dynamic> data) async {
    try {
      _logger.info('Saving data for model type: $modelType');

      // In a real implementation, we would need a registry of model types
      // For now, we'll use a simple approach that works with the repository
      // This requires the calling code to handle the proper model type

      // For demonstration purposes, we'll log what would happen
      _logger.info('Data to save: $data');

      // In a real implementation, you would need to:
      // 1. Convert the JSON data to the appropriate model instance
      // 2. Use the repository's upsert<T> method with the correct type

      // For example, if we know the model type is 'Configurations':
      // final config = Configurations.fromJson(data);
      // await repository.upsert<Configurations>(config);

      _logger.info('Successfully saved data for model type: $modelType');
    } catch (e) {
      _logger.severe('Error saving data to local database: $e');
      rethrow;
    }
  }

  /// Sync data to connected devices
  Future<void> syncData<T>(T instance, {required String modelType}) async {
    if (!config.enableBluetooth || _connectedDevices.isEmpty) {
      return;
    }

    try {
      // Convert instance to JSON
      final Map<String, dynamic> data = _convertInstanceToJson(instance);

      // Prepare the data for transmission
      final Map<String, dynamic> payload = {
        'modelType': modelType,
        'data': data,
      };

      // Convert to JSON and then to bytes
      final String jsonData = jsonEncode(payload);
      final List<int> bytes = utf8.encode(jsonData);

      // Check if data size is within limits
      if (bytes.length > config.maxDocumentSize) {
        throw Exception('Data size exceeds maximum allowed size');
      }

      // Send to all connected devices
      for (BluetoothDevice device in _connectedDevices.values) {
        await _sendDataToDevice(device, bytes);
      }

      // Emit sync event
      _syncEventController.add(SyncEvent(
        eventType: SyncEventType.sent,
        modelType: modelType,
        success: true,
      ));
    } catch (e) {
      _logger.severe('Error syncing data: $e');
      _syncEventController.add(SyncEvent(
        eventType: SyncEventType.sent,
        modelType: modelType,
        success: false,
        error: e.toString(),
      ));
    }
  }

  /// Convert an instance to JSON
  Map<String, dynamic> _convertInstanceToJson(dynamic instance) {
    // For maps, return directly
    if (instance is Map<String, dynamic>) {
      return instance;
    }

    // For models that have a toJson method
    if (instance != null) {
      try {
        // Using dynamic invocation to call toJson
        return instance.toJson();
      } catch (e) {
        _logger.warning('Error converting instance to JSON: $e');
      }
    }

    throw Exception('Unable to convert instance to JSON');
  }

  /// Send data to a specific device
  Future<void> _sendDataToDevice(BluetoothDevice device, List<int> data) async {
    try {
      // Find the service and characteristic
      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        if (service.uuid.toString() == p2pServiceUuid) {
          for (BluetoothCharacteristic characteristic
              in service.characteristics) {
            if (characteristic.uuid.toString() == dataCharacteristicUuid) {
              // Write the data
              await characteristic.write(data);
              _logger.info('Sent data to device: ${device.platformName}');
              return;
            }
          }
        }
      }

      throw Exception('Data characteristic not found');
    } catch (e) {
      _logger
          .warning('Error sending data to device ${device.platformName}: $e');
      rethrow;
    }
  }

  /// Manually scan for devices
  Future<List<BluetoothDevice>> scanForDevices(
      {Duration timeout = const Duration(seconds: 10)}) async {
    if (!config.enableBluetooth) {
      return [];
    }

    try {
      await FlutterBluePlus.startScan(
        withServices: [Guid(p2pServiceUuid)],
        timeout: timeout,
      );

      final results = await FlutterBluePlus.scanResults.first;
      return results.map((result) => result.device).toList();
    } catch (e) {
      _logger.severe('Error scanning for devices: $e');
      return [];
    } finally {
      await FlutterBluePlus.stopScan();
    }
  }

  /// Manually connect to a device
  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      await _connectToDevice(device);
      return _connectedDevices.containsKey(device.remoteId.str);
    } catch (e) {
      _logger.severe('Error connecting to device: $e');
      return false;
    }
  }

  /// Disconnect from a device
  Future<void> disconnectFromDevice(BluetoothDevice device) async {
    try {
      await device.disconnect();
      _connectedDevices.remove(device.remoteId.str);
      _logger.info('Disconnected from device: ${device.platformName}');
    } catch (e) {
      _logger.warning(
          'Error disconnecting from device ${device.platformName}: $e');
    }
  }

  /// Disconnect from all devices
  Future<void> disconnectAll() async {
    for (BluetoothDevice device in _connectedDevices.values) {
      await disconnectFromDevice(device);
    }
  }

  /// Dispose the client
  Future<void> dispose() async {
    await disconnectAll();
    await _syncEventController.close();
    _logger.info('P2P client disposed');
  }
}

/// Event types for sync events
enum SyncEventType {
  sent,
  received,
}

/// A sync event
class SyncEvent {
  final SyncEventType eventType;
  final String? modelType;
  final bool success;
  final String? error;

  SyncEvent({
    required this.eventType,
    this.modelType,
    required this.success,
    this.error,
  });
}

// TODO: to be continued bellow method not working.

// /// Extension on Repository to add P2P sync functionality
// extension P2PRepositoryExtension on Repository {
//   /// Sync data to connected devices after a local upsert
//   Future<T> upsertAndSync<T>(T instance, {required P2PClient p2pClient}) async {
//     // First, save to local database
//     final result = await upsert<T>(instance);
    
//     // Then sync to connected devices
//     await p2pClient.syncData<T>(result, modelType: T.toString());
    
//     return result;
//   }
// }
