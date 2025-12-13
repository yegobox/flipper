import 'dart:async';
import 'package:ditto_live/ditto_live.dart';
import 'package:flutter/foundation.dart';

/// Singleton manager for Ditto instances to prevent file lock conflicts
class DittoSingleton {
  static DittoSingleton? _instance;
  static Ditto? _ditto;
  static bool _isInitializing = false;

  DittoSingleton._();

  static DittoSingleton get instance {
    _instance ??= DittoSingleton._();
    return _instance!;
  }

  /// Get existing Ditto instance or null if not initialized
  Ditto? get ditto => _ditto;

  /// Check if Ditto is ready
  bool get isReady => _ditto != null;

  /// Initialize Ditto with proper singleton handling
  Future<Ditto?> initialize({
    required String appId,
    required String token,
    required String persistenceDir,
    bool enableCloudSync = true,
  }) async {
    // Prevent multiple simultaneous initializations
    if (_isInitializing) {
      print('⏳ Ditto initialization already in progress, waiting...');
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return _ditto;
    }

    // Return existing instance if available
    if (_ditto != null) {
      print('✅ Using existing Ditto instance');
      return _ditto;
    }

    _isInitializing = true;

    try {
      await Ditto.init();

      final identity = OnlinePlaygroundIdentity(
        appID: appId,
        token: token,
        enableDittoCloudSync: enableCloudSync,
      );

      print('📁 Using Ditto directory: $persistenceDir');

      _ditto = await Ditto.open(
        identity: identity,
        persistenceDirectory: persistenceDir,
      );

      // Configure transport
      _ditto!.updateTransportConfig((config) {
        // Enable cloud sync by setting the proper WebSocket URL
        config.connect.webSocketUrls.clear();
        config.connect.webSocketUrls.add("wss://$appId.cloud.ditto.live");

        if (kIsWeb) {
          // On web, only use cloud sync
          config.setAllPeerToPeerEnabled(false);
        } else {
          // On mobile/desktop, enable both cloud sync and peer-to-peer
          config.setAllPeerToPeerEnabled(true);
        }
      });

      await _ditto!.store.execute("ALTER SYSTEM SET DQL_STRICT_MODE = false");

      // Start sync to connect to Ditto cloud
      _ditto!.startSync();

      print('✅ Ditto singleton initialized successfully');
      return _ditto;
    } catch (e) {
      print('❌ Ditto singleton initialization failed: $e');
      _ditto = null;
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  /// Dispose Ditto instance properly
  Future<void> dispose() async {
    if (_ditto != null) {
      try {
        print('🛑 Stopping Ditto sync and disposing singleton...');
        _ditto!.stopSync();
        await Future.delayed(const Duration(milliseconds: 500));
        _ditto = null;
        print('✅ Ditto singleton disposed');
      } catch (e) {
        print('❌ Error disposing Ditto singleton: $e');
        _ditto = null;
      }
    }
  }

  /// Reset singleton (for testing or hot restart)
  static Future<void> reset() async {
    if (_instance != null) {
      await _instance!.dispose();
      _instance = null;
    }
  }
}
