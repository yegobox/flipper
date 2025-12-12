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
      debugPrint('⏳ Ditto initialization already in progress, waiting...');
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return _ditto;
    }

    // Return existing instance if available
    if (_ditto != null) {
      debugPrint('✅ Using existing Ditto instance');
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

      debugPrint('📁 Using Ditto directory: $persistenceDir');

      _ditto = await Ditto.open(
        identity: identity,
        persistenceDirectory: persistenceDir,
      );

      // Configure transport
      _ditto!.updateTransportConfig((config) {
        // config.connect.webSocketUrls.clear();

        if (kIsWeb) {
          config.setAllPeerToPeerEnabled(false);
        } else {
          config.setAllPeerToPeerEnabled(true);
        }

        config.connect.webSocketUrls.add("wss://$appId.cloud.ditto.live");
      });

      await _ditto!.store.execute("ALTER SYSTEM SET DQL_STRICT_MODE = false");

      _ditto!.sync;

      debugPrint('✅ Ditto singleton initialized successfully');
      return _ditto;
    } catch (e) {
      debugPrint('❌ Ditto singleton initialization failed: $e');
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
        debugPrint('🛑 Stopping Ditto singleton...');
        _ditto!.stopSync();
        await Future.delayed(const Duration(milliseconds: 1000));
        _ditto = null;
        debugPrint('✅ Ditto singleton disposed');
      } catch (e) {
        debugPrint('❌ Error disposing Ditto singleton: $e');
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
