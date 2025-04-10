// lib/src/bluetooth/bluetooth_manager.dart

import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:uuid/uuid.dart';
import '../models/peer.dart';
import '../models/message.dart';
import '../models/connection_status.dart';

/// Manages Bluetooth connections and communication
class BluetoothManager {
  // No need for an instance as FlutterBluePlus uses static methods
  
  // Device ID for this device
  late String _deviceId;
  String get deviceId => _deviceId;
  
  // Device name for this device
  String? _deviceName;
  
  // Active connections to other peers
  final Map<String, BluetoothConnection> _connections = {};
  
  // Stream controllers for exposing events
  final _peerController = StreamController<List<Peer>>.broadcast();
  final _messageController = StreamController<P2PMessage>.broadcast();
  final _connectionStatusController = StreamController<ConnectionStatus>.broadcast();
  
  // Known peers
  final List<Peer> _peers = [];
  
  // Message buffer for each connection
  final Map<String, StringBuffer> _messageBuffers = {};
  
  // Service and characteristic UUIDs for communication
  final Guid _serviceUuid = Guid('0000180f-0000-1000-8000-00805f9b34fb');
  final Guid _characteristicUuid = Guid('00002a19-0000-1000-8000-00805f9b34fb');
  
  // Stream getters
  Stream<List<Peer>> get peersStream => _peerController.stream;
  Stream<P2PMessage> get messageStream => _messageController.stream;
  Stream<ConnectionStatus> get connectionStatusStream => _connectionStatusController.stream;
  
  /// Constructor
  BluetoothManager() {
    _initializeDeviceInfo();
  }
  
  /// Initialize device info
  Future<void> _initializeDeviceInfo() async {
    // Generate a unique device ID if we don't have one stored
    // In a real implementation, you'd want to persist this
    _deviceId = const Uuid().v4();
    
    try {
      // In flutter_blue_plus, we get the local device info differently
      // We'll use the adapter name as the device name
      BluetoothAdapterState adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState == BluetoothAdapterState.on) {
        // Get the adapter name - this is platform-specific
        // For now we'll use a placeholder
        _deviceName = 'Flipper Device';
      } else {
        _deviceName = 'Unknown Device';
      }
    } catch (e) {
      _deviceName = 'Unknown Device';
      debugPrint('Error getting device name: $e');
    }
  }
  
  /// Start Bluetooth discovery and server
  Future<bool> start() async {
    try {
      // Check if Bluetooth is available and enabled
      BluetoothAdapterState adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState != BluetoothAdapterState.on) {
        // Request to turn on Bluetooth
        // Note: flutter_blue_plus doesn't have a direct method to enable Bluetooth
        // You'll need to guide the user to enable it manually
        _connectionStatusController.add(ConnectionStatus.error);
        return false;
      }
      
      // Start discovery
      _startDiscovery();
      
      // Start advertising our service
      _startAdvertising();
      
      _connectionStatusController.add(ConnectionStatus.connected);
      return true;
    } catch (e) {
      debugPrint('Error starting Bluetooth: $e');
      _connectionStatusController.add(ConnectionStatus.error);
      return false;
    }
  }
  
  /// Start discovering nearby devices
  void _startDiscovery() {
    try {
      // Start scanning for devices
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 30));
      
      // Listen for scan results
      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult result in results) {
          // Skip if device has no name
          if (result.device.platformName.isEmpty) continue;
          
          final peer = Peer(
            id: result.device.remoteId.str,
            name: result.device.platformName,
            address: result.device.remoteId.str,
            deviceType: 'mobile',
          );
          
          // Add to peers list if not already there
          if (!_peers.contains(peer)) {
            _peers.add(peer);
            _peerController.add(List.from(_peers));
          } else {
            // Update last seen time and RSSI
            final index = _peers.indexWhere((p) => p.id == peer.id);
            if (index >= 0) {
              _peers[index].lastSeen = DateTime.now();
            }
          }
        }
      });
      
      // Restart scanning periodically
      Timer.periodic(const Duration(seconds: 35), (_) {
        FlutterBluePlus.startScan(timeout: const Duration(seconds: 30));
      });
      
      // Periodically clean up old peers
      Timer.periodic(const Duration(minutes: 5), (_) {
        final now = DateTime.now();
        _peers.removeWhere((peer) => 
          now.difference(peer.lastSeen).inMinutes > 10 && !peer.isConnected);
        _peerController.add(List.from(_peers));
      });
    } catch (e) {
      debugPrint('Error starting discovery: $e');
    }
  }
  
  /// Start advertising our service for others to discover
  Future<void> _startAdvertising() async {
    // Note: flutter_blue_plus doesn't directly support peripheral mode (advertising)
    // on all platforms. This is a limitation of the library.
    // 
    // For a complete implementation, you might need to use platform-specific code
    // or a different library that supports peripheral mode.
    //
    // This is a placeholder for the functionality.
    debugPrint('Advertising not fully supported in flutter_blue_plus');
  }
  
  /// Handle connection to a device
  Future<void> _handleConnection(BluetoothDevice device) async {
    try {
      // Connect to the device
      await device.connect(autoConnect: false);
      
      // Get peer ID from device
      final peerId = device.remoteId.str;
      
      // Find or create peer
      var peer = _peers.firstWhere(
        (p) => p.id == peerId,
        orElse: () => Peer(
          id: peerId,
          name: device.platformName,
          address: peerId,
        ),
      );
      
      // Update peer status
      peer.isConnected = true;
      peer.lastSeen = DateTime.now();
      
      // Add to connections map (using a custom connection class)
      _connections[peer.id] = BluetoothConnection(device);
      
      // Initialize message buffer
      _messageBuffers[peer.id] = StringBuffer();
      
      // Update peers list
      if (!_peers.contains(peer)) {
        _peers.add(peer);
      }
      _peerController.add(List.from(_peers));
      
      // Discover services
      List<BluetoothService> services = await device.discoverServices();
      
      // Find our service and characteristic
      for (BluetoothService service in services) {
        if (service.uuid == _serviceUuid) {
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if (characteristic.uuid == _characteristicUuid) {
              // Set up notification for incoming data
              await characteristic.setNotifyValue(true);
              characteristic.onValueReceived.listen((data) {
                _handleIncomingData(peer.id, data);
              });
            }
          }
        }
      }
      
      // Listen for disconnection
      device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          _handleDisconnection(peer.id);
        }
      });
    } catch (e) {
      debugPrint('Error handling connection: $e');
    }
  }
  
  /// Handle incoming data from a connection
  void _handleIncomingData(String peerId, List<int> data) {
    try {
      // Add data to buffer
      final buffer = _messageBuffers[peerId]!;
      buffer.write(String.fromCharCodes(data));
      
      // Check if we have complete messages
      final String bufferStr = buffer.toString();
      if (bufferStr.contains('\n')) {
        // Split by newline and process complete messages
        final parts = bufferStr.split('\n');
        
        // Last part might be incomplete, keep it in buffer
        final lastPart = parts.removeLast();
        buffer.clear();
        buffer.write(lastPart);
        
        // Process complete messages
        for (var part in parts) {
          if (part.isNotEmpty) {
            try {
              final message = P2PMessage.deserialize(part);
              _messageController.add(message);
            } catch (e) {
              debugPrint('Error parsing message: $e');
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error handling incoming data: $e');
    }
  }
  
  /// Handle a disconnection
  void _handleDisconnection(String peerId) {
    // Update peer status
    final peerIndex = _peers.indexWhere((p) => p.id == peerId);
    if (peerIndex >= 0) {
      _peers[peerIndex].isConnected = false;
      _peerController.add(List.from(_peers));
    }
    
    // Clean up resources
    _connections.remove(peerId);
    _messageBuffers.remove(peerId);
  }
  
  /// Connect to a specific peer
  Future<bool> connectToPeer(Peer peer) async {
    // Skip if already connected
    if (_connections.containsKey(peer.id)) {
      return true;
    }
    
    try {
      // Try to find the device in the scan results by its ID
      BluetoothDevice? device;
      final scanResults = await FlutterBluePlus.scanResults.first;
      for (final result in scanResults) {
        if (result.device.remoteId.str == peer.id) {
          device = result.device;
          break;
        }
      }
      
      if (device == null) {
        debugPrint('Device not found in scan results');
        return false;
      }
      
      // Handle the connection
      await _handleConnection(device);
      return _connections.containsKey(peer.id);
    } catch (e) {
      debugPrint('Error connecting to peer: $e');
      return false;
    }
  }
  
  /// Disconnect from a specific peer
  Future<void> disconnectFromPeer(Peer peer) async {
    if (!_connections.containsKey(peer.id)) return;
    
    try {
      final connection = _connections[peer.id]!;
      await connection.device.disconnect();
      _handleDisconnection(peer.id);
    } catch (e) {
      debugPrint('Error disconnecting from peer: $e');
    }
  }
  
  /// Send a message to a specific peer
  Future<bool> sendMessage(Peer peer, P2PMessage message) async {
    if (!_connections.containsKey(peer.id)) return false;
    
    try {
      final connection = _connections[peer.id]!;
      final serializedMessage = message.serialize() + '\n';
      final data = Uint8List.fromList(serializedMessage.codeUnits);
      
      // Find our service and characteristic
      List<BluetoothService> services = await connection.device.discoverServices();
      for (BluetoothService service in services) {
        if (service.uuid == _serviceUuid) {
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if (characteristic.uuid == _characteristicUuid && characteristic.properties.write) {
              // Write the data in chunks if needed
              const int maxChunkSize = 20; // BLE has a limit on packet size
              for (int i = 0; i < data.length; i += maxChunkSize) {
                int end = (i + maxChunkSize < data.length) ? i + maxChunkSize : data.length;
                Uint8List chunk = data.sublist(i, end);
                await characteristic.write(chunk);
              }
              return true;
            }
          }
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error sending message: $e');
      return false;
    }
  }
  
  /// Stop Bluetooth operations
  Future<void> stop() async {
    try {
      // Stop scanning
      await FlutterBluePlus.stopScan();
      
      // Disconnect from all devices
      for (var peer in _peers.where((p) => p.isConnected)) {
        await disconnectFromPeer(peer);
      }
    } catch (e) {
      debugPrint('Error stopping Bluetooth: $e');
    }
  }
  
  /// Dispose resources
  void dispose() {
    _peerController.close();
    _messageController.close();
    _connectionStatusController.close();
    stop();
  }
}

/// Custom connection class to wrap BluetoothDevice
class BluetoothConnection {
  final BluetoothDevice device;
  
  BluetoothConnection(this.device);
}