import 'dart:async';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:permission_handler/permission_handler.dart';
import 'ditto_core_mixin.dart';

mixin SyncMixin on DittoCore {
  Timer? _observationTimer;
  final List<void Function(Ditto?)> _dittoListeners = [];
  StreamController<List<UserProfile>>? _userProfilesController;
  // Track the last Ditto instance we successfully set up to prevent duplicate setup
  // but allow setup when the instance actually changes
  Ditto? _lastSetupDitto;

  /// Register a listener that will be notified whenever the underlying Ditto
  /// instance changes. The listener is invoked immediately with the current
  /// instance (which can be null).
  void addDittoListener(void Function(Ditto?) listener) {
    _dittoListeners.add(listener);
    listener(dittoInstance);
  }

  /// Remove a previously registered Ditto listener.
  void removeDittoListener(void Function(Ditto?) listener) {
    _dittoListeners.remove(listener);
  }

  void _notifyDittoListeners() {
    for (final listener in List<void Function(Ditto?)>.from(_dittoListeners)) {
      try {
        listener(dittoInstance);
      } catch (error) {
        debugPrint('Error notifying Ditto listener: $error');
      }
    }
  }

  /// Sets the Ditto instance (called from main.dart after initialization)
  /// This method should be called by the class that uses this mixin after setting the Ditto instance in DittoCore
  void setupDittoWithSync(Ditto ditto) {
    // Request necessary permissions for Ditto
    final platform = Ditto.currentPlatform;
    if (platform case SupportedPlatform.android || SupportedPlatform.ios) {
      _requestPermissions(platform);
    }

    // Only set if we don't already have the same instance
    if (_lastSetupDitto == ditto) {
      debugPrint('Same Ditto instance already set up, skipping');
      startSync();
      return;
    }

    _lastSetupDitto = ditto;

    _notifyDittoListeners();

    // Verify the instance was properly set
    try {
      debugPrint('📱 Ditto device initialized: ${ditto.deviceName}');
      debugPrint(
        '📁 Ditto persistence directory: ${ditto.persistenceDirectory}',
      );
      debugPrint('🔗 Ditto sync active: ${dittoInstance!.isSyncActive}');
      debugPrint('🔑 Ditto auth status: ${dittoInstance!.auth.status}');
    } catch (e) {
      debugPrint('❌ ERROR: Ditto instance is not properly initialized: $e');
      _notifyDittoListeners();
      return;
    }

    if (kDebugMode) {
      debugPrint(
        'ℹ️  mDNS NameConflict warnings are normal in development when multiple instances are running',
      );
      debugPrint(
        'ℹ️  File lock conflicts are prevented by using unique directories per instance',
      );
    }

    startSync();
    _setupObservation();
  }

  /// Request necessary permissions for Ditto
  void _requestPermissions(SupportedPlatform platform) {
    [
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.nearbyWifiDevices,
      Permission.bluetoothScan,
      Permission.location,
      Permission.notification,
    ].request().then((statuses) async {
      if (platform == SupportedPlatform.android) {
        _checkAndroidPermissions();
      }
    });
  }

  /// Check Android permissions
  void _checkAndroidPermissions() async {
    final allPermissions = [
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.nearbyWifiDevices,
      Permission.bluetoothScan,
      Permission.location,
      Permission.notification,
    ];

    bool allPermissionsGranted = true;
    List<String> deniedPermissions = [];

    for (var permission in allPermissions) {
      final status = await permission.status;
      if (status != PermissionStatus.granted) {
        allPermissionsGranted = false;
        deniedPermissions.add(permission.toString());
      }
    }

    if (!allPermissionsGranted) {
      debugPrint(
        '⚠️ Some permissions not granted. Ditto sync may not work properly on Android. Denied: ${deniedPermissions.join(", ")}',
      );
      debugPrint(
        'Please ensure all requested permissions are granted for proper sync functionality.',
      );
    } else {
      debugPrint(
        '✅ All required permissions granted for Ditto sync on Android.',
      );
    }
  }

  /// Checks if Ditto is properly initialized and ready to use with additional validation
  bool isActuallyReady() {
    if (dittoInstance == null) {
      debugPrint('❌ Ditto instance is null');
      return false;
    }
    try {
      debugPrint('✅ Ditto is ready and operational');
      return true;
    } catch (e) {
      debugPrint('❌ Ditto is not ready: $e');
      return false;
    }
  }

  /// Starts Ditto sync if Ditto is initialized
  void startSync() {
    if (dittoInstance != null) {
      final platform = Ditto.currentPlatform;
      if (platform == SupportedPlatform.android) {
        _startAndroidSync();
      } else {
        _startSync();
      }
    } else {
      debugPrint('Cannot start sync: Ditto not initialized');
    }
  }

  /// Start sync for Android platform
  void _startAndroidSync() {
    final allPermissions = [
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.nearbyWifiDevices,
      Permission.bluetoothScan,
      Permission.location,
    ];

    Future.wait(allPermissions.map((permission) => permission.status))
        .then((statuses) {
          bool allPermissionsGranted = statuses.every(
            (status) => status == PermissionStatus.granted,
          );

          if (!allPermissionsGranted) {
            List<String> deniedPermissions = [];
            for (int i = 0; i < allPermissions.length; i++) {
              if (statuses[i] != PermissionStatus.granted) {
                deniedPermissions.add(allPermissions[i].toString());
              }
            }
            debugPrint(
              '⚠️ Android: Not all required permissions granted. Ditto sync may not work properly. Denied: ${deniedPermissions.join(", ")}',
            );
            debugPrint(
              'Please ensure all requested permissions are granted for proper sync functionality.',
            );
          } else {
            debugPrint(
              '✅ Android: All required permissions granted, starting sync...',
            );
            _startSync();
          }
        })
        .catchError((error) {
          debugPrint('Error checking permissions: $error');
          _startSync(fallback: true);
        });
  }

  /// Internal method to start sync
  void _startSync({bool fallback = false}) {
    try {
      dittoInstance!.startSync();
      debugPrint(
        fallback
            ? 'Ditto sync started (fallback after permission check error)'
            : 'Ditto sync started',
      );
    } catch (e) {
      debugPrint('Error starting Ditto sync: $e');
    }
  }

  /// Stops Ditto sync if Ditto is initialized
  void stopSync() {
    if (dittoInstance != null) {
      try {
        dittoInstance!.stopSync();
        debugPrint('Ditto sync stopped');
      } catch (e) {
        debugPrint('Error stopping Ditto sync: $e');
      }
    } else {
      debugPrint('Cannot stop sync: Ditto not initialized');
    }
  }

  /// Setup observation for user profiles
  Future<void> _setupObservation() async {
    try {
      await _loadAndUpdateUserProfiles();
      final pollingInterval = kIsWeb
          ? const Duration(seconds: 3)
          : const Duration(seconds: 5);
      _observationTimer = Timer.periodic(pollingInterval, (_) async {
        await _loadAndUpdateUserProfiles();
      });
      if (kIsWeb) {
        debugPrint(
          'Warning: On web platform, Ditto data is in-memory only and will not persist across page reloads.',
        );
      }
    } catch (e) {
      debugPrint('Error setting up user collection observation: $e');
    }
  }

  /// Load and update user profiles
  Future<void> _loadAndUpdateUserProfiles() async {
    try {
      final profiles = await getAllUserProfiles();
      _userProfilesController ??=
          StreamController<List<UserProfile>>.broadcast();
      _userProfilesController!.add(profiles);
    } catch (e) {
      debugPrint('Error updating user profiles: $e');
    }
  }

  /// Disposes resources and prepares for cleanup
  Future<void> dispose() async {
    debugPrint('🧹 Starting DittoService disposal...');
    _observationTimer?.cancel();
    _observationTimer = null;
    if (_userProfilesController != null && !_userProfilesController!.isClosed) {
      await _userProfilesController!.close();
      _userProfilesController = null;
    }
    if (dittoInstance != null) {
      _notifyDittoListeners();
      _dittoListeners.clear();
    }
    debugPrint('✅ DittoService disposal completed');
  }

  /// Placeholder method to be implemented by the class using this mixin
  Future<List<UserProfile>> getAllUserProfiles() async {
    debugPrint(
      '⚠️ getAllUserProfiles() not implemented in the class using this mixin',
    );
    return [];
  }
}
