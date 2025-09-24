// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'dart:async';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_web/core/secrets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/models/user_profile.dart';

final dittoServiceProvider = Provider<DittoService>((ref) {
  return DittoService();
});

class DittoService {
  Ditto? _ditto;
  Timer? _observationTimer;
  final StreamController<List<UserProfile>> _userProfilesController =
      StreamController<List<UserProfile>>.broadcast();

  bool _isInitialized = false;

  Stream<List<UserProfile>> get userProfiles => _userProfilesController.stream;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Add memory specific error handler for web platform
      if (kIsWeb) {
        debugPrint('Web platform detected, installing specific error handlers');
        // This is a hook that could be expanded with custom error handling if needed
      }

      final appID = kDebugMode ? AppSecrets.appIdDebug : AppSecrets.appId;

      // Initialize Ditto SDK with platform-specific handling
      if (kIsWeb) {
        // For web, we need to be careful with WebAssembly initialization
        debugPrint('Initializing Ditto for Web platform');

        try {
          // Use init without custom parameters to use default assets bundled with the package
          await Ditto.init();
          debugPrint(
            'Initialized Ditto SDK for Web platform using default assets',
          );
        } catch (e) {
          debugPrint('Error during Ditto web initialization: $e');
          rethrow;
        }
      } else {
        // Non-web initialization is simpler
        await Ditto.init();
        debugPrint('Initialized Ditto SDK for Mobile/Desktop platform');
      }

      // Configure logging (optional)
      DittoLogger.isEnabled = true;
      DittoLogger.minimumLogLevel = LogLevel.info;
      DittoLogger.customLogCallback = (level, message) {
        debugPrint("[$level] => $message");
      };

      // Create identity using App ID and token
      final identity = OnlinePlaygroundIdentity(
        appID: appID,
        token: kDebugMode
            ? 'd8b7ac92-004a-47ac-a052-ea8d92d5869f' // dev token
            : 'd8b7ac92-004a-47ac-a052-ea8d92d5869f',
      );

      // Open Ditto instance with identity
      _ditto = await Ditto.open(identity: identity);

      // Configure transport based on platform
      _ditto!.updateTransportConfig((config) {
        // Clear any existing configs first to prevent conflicts
        config.connect.webSocketUrls.clear();

        if (kIsWeb) {
          // For web, ensure P2P is completely disabled
          config.setAllPeerToPeerEnabled(false);

          // Add cloud sync URL
          config.connect.webSocketUrls.add("wss://$appID.cloud.ditto.live");
          debugPrint(
            'Web platform: Disabled P2P and configured cloud sync URL',
          );
        } else {
          // Enable P2P for mobile/desktop
          config.setAllPeerToPeerEnabled(true);

          // Add cloud sync URL
          config.connect.webSocketUrls.add("wss://$appID.cloud.ditto.live");
          debugPrint(
            'Mobile/Desktop: Enabled P2P and configured cloud sync URL',
          );
        }
      });

      // Set device name (optional but helpful for debugging)
      final platformTag = kIsWeb ? "Web" : "Mobile";
      _ditto!.deviceName = "Flipper $platformTag (${_ditto!.deviceName})";
      if (kDebugMode) {
        debugPrint('Set device name: ${_ditto!.deviceName}');
      }

      // Check web platform limitations
      checkWebPlatformLimitations();

      // Start sync with error handling
      try {
        if (kIsWeb) {
          // Allow a short delay before starting sync on web platform
          // This can help ensure WebAssembly initialization is fully complete
          await Future.delayed(const Duration(milliseconds: 300));
          debugPrint('Web platform: Adding delay before sync start');
        }
        _ditto!.startSync();
        debugPrint('Started Ditto sync');
      } catch (e) {
        debugPrint('Error starting Ditto sync: $e');
        // Continue execution - we'll still try to observe in case it works partially
      }

      // Set up live query to observe changes to users collection
      await _setupObservation();

      _isInitialized = true;
      debugPrint('DittoService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing DittoService: $e');
      rethrow;
    }
  }

  Future<void> _setupObservation() async {
    try {
      // For modern Ditto SDK, we need to periodically poll for changes
      // since the observe() method is not available in the newer SDK

      // Initial load of user profiles
      await _loadAndUpdateUserProfiles();

      // Set up a periodic timer to refresh data (simulating live updates)
      // For web, we poll more frequently since data is in-memory and we want to ensure
      // changes from the cloud are detected quickly
      final pollingInterval = kIsWeb
          ? const Duration(seconds: 3) // More frequent for web
          : const Duration(seconds: 5); // Standard for mobile/desktop

      _observationTimer = Timer.periodic(pollingInterval, (_) async {
        await _loadAndUpdateUserProfiles();
      });

      if (kIsWeb) {
        debugPrint(
          'Warning: On web platform, Ditto data is in-memory only and '
          'will not persist across page reloads.',
        );
      }
    } catch (e) {
      debugPrint('Error setting up user collection observation: $e');
    }
  }

  Future<void> _loadAndUpdateUserProfiles() async {
    try {
      final profiles = await getAllUserProfiles();
      _userProfilesController.add(profiles);
    } catch (e) {
      debugPrint('Error updating user profiles: $e');
    }
  }

  Future<void> saveUserProfile(UserProfile userProfile) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (_ditto == null) {
        throw Exception('Ditto not initialized');
      }

      // Use user's ID as document ID for easier retrieval
      final docId = userProfile.id.toString();

      // Use SQL-like syntax to insert document
      await _ditto!.store.execute(
        "INSERT INTO COLLECTION users DOCUMENTS (:profile)",
        arguments: {
          "profile": {"_id": docId, ...userProfile.toJson()},
        },
      );
      debugPrint('Saved user profile with ID: ${userProfile.id}');
    } catch (e) {
      debugPrint('Error saving user profile to Ditto: $e');
      rethrow;
    }
  }

  /// Update an existing user profile in Ditto
  ///
  /// This method uses the proper UPDATE syntax to update an existing document
  /// which is the recommended way to update documents in Ditto
  Future<void> updateUserProfile(UserProfile userProfile) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (_ditto == null) {
        throw Exception('Ditto not initialized');
      }

      // Use user's ID as document ID for easier retrieval
      final docId = userProfile.id.toString();

      // Use the UPDATE statement to update the document with the given ID
      await _ditto!.store.execute(
        "UPDATE users SET doc = :profile WHERE _id = :id",
        arguments: {"profile": userProfile.toJson(), "id": docId},
      );

      debugPrint(
        'Successfully updated user profile with ID: ${userProfile.id}',
      );
    } catch (e) {
      debugPrint('Error updating user profile in Ditto: $e');
      rethrow;
    }
  }

  Future<UserProfile?> getUserProfile(String id) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (_ditto == null) {
        throw Exception('Ditto not initialized');
      }

      // Use DQL to get a single document by ID
      final result = await _ditto!.store.execute(
        "SELECT * FROM users WHERE _id = :id",
        arguments: {"id": id},
      );

      if (result.items.isEmpty) {
        return null;
      }

      return UserProfile.fromJson(
        Map<String, dynamic>.from(result.items.first.value),
        id: id,
      );
    } catch (e) {
      debugPrint('Error getting user profile from Ditto: $e');
      return null;
    }
  }

  Future<List<UserProfile>> getAllUserProfiles() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (_ditto == null) {
        throw Exception('Ditto not initialized');
      }

      // Use DQL to get all documents
      final result = await _ditto!.store.execute("SELECT * FROM users");

      return result.items
          .map((doc) {
            try {
              return UserProfile.fromJson(Map<String, dynamic>.from(doc.value));
            } catch (e) {
              debugPrint('Error parsing user profile document: $e');
              return null;
            }
          })
          .whereType<UserProfile>()
          .toList();
    } catch (e) {
      debugPrint('Error getting all user profiles from Ditto: $e');
      return [];
    }
  }

  Future<void> deleteUserProfile(String id) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (_ditto == null) {
        throw Exception('Ditto not initialized');
      }

      await _ditto!.store.execute(
        "REMOVE FROM COLLECTION users WHERE _id = :id",
        arguments: {"id": id},
      );
      debugPrint('Deleted user profile with ID: $id');
    } catch (e) {
      debugPrint('Error deleting user profile from Ditto: $e');
      rethrow;
    }
  }

  /// Checks if the platform is web and provides information about web limitations
  /// Returns true if the current platform is web
  bool checkWebPlatformLimitations() {
    if (kIsWeb) {
      debugPrint('DITTO WEB LIMITATIONS:');
      debugPrint(
        '- Data is stored in-memory only and will not persist across page reloads',
      );
      debugPrint('- Peer-to-peer synchronization is not supported');
      debugPrint('- Only cloud synchronization is available');
      debugPrint(
        '- For development: Restart the Flutter dev server after code changes',
      );
      return true;
    }
    return false;
  }

  /// Handle browser beforeunload event to warn about data loss
  /// This should be called from a web-specific part of your app
  void setupWebUnloadWarning() {
    if (kIsWeb) {
      // This would be implemented with web-specific code in a real app
      // using js interop to add beforeunload listener
      debugPrint(
        'Web unload warning would be set up here in a real implementation',
      );
    }
  }

  /// Helper method to ensure cloud sync is properly established for web
  Future<bool> ensureCloudConnectivity() async {
    if (!kIsWeb || _ditto == null) return true;

    try {
      // On web, we can check if we're connected to the cloud
      // This is a simplified version - in a real app, you would
      // implement proper connectivity checking

      // For now, just return true since we can't easily check connectivity
      // in this simplified version
      return true;
    } catch (e) {
      debugPrint('Error checking cloud connectivity: $e');
      return false;
    }
  }

  void dispose() {
    _observationTimer?.cancel();
    _userProfilesController.close();
    _ditto?.stopSync();

    if (kIsWeb) {
      debugPrint('Disposing Ditto service - all in-memory data will be lost');
    }
  }
}
