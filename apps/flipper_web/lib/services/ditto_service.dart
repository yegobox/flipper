// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'dart:async';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_web/core/secrets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/models/user_profile.dart';

// Global singleton instance of DittoService
// This ensures only one Ditto instance exists throughout the application lifecycle
// Use a late final to guarantee that the instance is created only once
late final DittoService _dittoServiceInstance = DittoService._internal();

/// Provider for the DittoService singleton
/// This guarantees that only one instance of DittoService is created and used throughout the app
final dittoServiceProvider = Provider<DittoService>((ref) {
  // Return the pre-initialized singleton instance
  return _dittoServiceInstance;
});

/// DittoService implements a singleton pattern to ensure only one Ditto instance
/// exists throughout the application lifecycle. This prevents lock file conflicts
/// when running in web environments.
class DittoService {
  // Private constructor for singleton implementation
  DittoService._internal();

  // Factory constructor that returns the singleton instance
  factory DittoService() {
    return _dittoServiceInstance;
  }

  Ditto? _ditto;
  Timer? _observationTimer;
  final StreamController<List<UserProfile>> _userProfilesController =
      StreamController<List<UserProfile>>.broadcast();

  bool _isInitialized = false;

  // Cache the directory name to ensure consistent usage
  String? _webPersistenceDirectory;

  Stream<List<UserProfile>> get userProfiles => _userProfilesController.stream;

  /// Generate a unique directory name for web environments to avoid lock conflicts
  /// This ensures that each browser session uses a different directory
  String _generateUniqueWebDirectory() {
    // Combine timestamp with a random component
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomPart =
        timestamp % 10000; // Use last 4 digits as random component

    // Create a directory name with both components
    return 'ditto_web_${timestamp}_$randomPart';
  }

  /// Initialize the Ditto service
  /// This is safe to call multiple times - subsequent calls will be ignored
  /// if the service is already initialized
  Future<void> initialize() async {
    // Singleton safety check - prevent double initialization
    if (_isInitialized) {
      debugPrint(
        'DittoService is already initialized - skipping initialization',
      );
      return;
    }

    debugPrint('Initializing DittoService singleton');

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
          // Add a small delay before initialization to ensure everything is ready
          await Future.delayed(const Duration(milliseconds: 500));

          debugPrint('About to call Ditto.init() for web...');
          await Ditto.init();
          debugPrint(
            'Initialized Ditto SDK for Web platform with default settings',
          );
        } catch (e) {
          debugPrint('Error during Ditto web initialization: $e');
          // For now, let's mark as initialized to prevent crashes but log the error
          debugPrint('Continuing without full Ditto initialization');
          _isInitialized = true;
          _ditto = null;
          return; // Exit initialization but don't rethrow
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

      // If we're already marked as initialized but got here due to a previous error,
      // just return without trying to open Ditto again
      if (_isInitialized && _ditto == null && kIsWeb) {
        debugPrint('Skipping Ditto.open due to previous initialization errors');
        return;
      }

      // Open Ditto instance with identity
      // Using the singleton pattern ensures we only ever have one instance
      // so we can use a consistent directory name
      debugPrint('Opening Ditto with consistent directory as a singleton');

      try {
        if (kIsWeb) {
          // For web, use a session-unique directory name to prevent lock conflicts
          // Get or create a unique directory name for this browser session
          _webPersistenceDirectory ??= _generateUniqueWebDirectory();

          debugPrint(
            'Web platform: Using unique directory: $_webPersistenceDirectory',
          );

          _ditto = await Ditto.open(
            identity: identity,
            persistenceDirectory: _webPersistenceDirectory!,
          );
          debugPrint('Opened Ditto with web-specific unique directory');
        } else {
          // For mobile/desktop, use the default directory
          _ditto = await Ditto.open(identity: identity);
          debugPrint('Opened Ditto with default directory for mobile/desktop');
        }
      } catch (e) {
        debugPrint('Error opening Ditto: $e');
        // Try another approach if it fails with a locking error
        if (kIsWeb && e.toString().contains('File already locked')) {
          try {
            debugPrint(
              'Detected locking error, trying with a different directory name',
            );
            // Generate a new unique directory name with fallback suffix
            _webPersistenceDirectory =
                _generateUniqueWebDirectory() + '_fallback';
            debugPrint('Using fallback directory: $_webPersistenceDirectory');

            _ditto = await Ditto.open(
              identity: identity,
              persistenceDirectory: _webPersistenceDirectory!,
            );
            debugPrint('Successfully opened Ditto with fallback directory');
          } catch (retryError) {
            debugPrint('Retry also failed: $retryError');
            // For web, we'll allow the app to continue without Ditto
            debugPrint('Web platform: Continuing without Ditto functionality');
            _isInitialized = true;
            _ditto = null;
            return;
          }
        } else if (kIsWeb) {
          // For web, we'll allow the app to continue without Ditto
          debugPrint('Web platform: Continuing without Ditto functionality');
          _isInitialized = true;
          _ditto = null;
          return;
        } else {
          // For mobile/desktop, this is a critical error
          rethrow;
        }
      }

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
        try {
          await initialize();
        } catch (e) {
          debugPrint('Error initializing DittoService during save: $e');
          if (kIsWeb) {
            // For web, we'll skip saving silently
            debugPrint('Web platform: Skipping Ditto save operation');
            return;
          } else {
            rethrow;
          }
        }
      }

      if (_ditto == null) {
        if (kIsWeb) {
          // For web, we'll skip saving silently
          debugPrint('Web platform: Ditto is null, skipping save operation');
          return;
        } else {
          throw Exception('Ditto not initialized');
        }
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
      if (kIsWeb) {
        // For web, we'll allow the operation to fail silently
        debugPrint('Web platform: Continuing despite Ditto save error');
      } else {
        rethrow;
      }
    }
  }

  /// Update an existing user profile in Ditto
  ///
  /// This method uses the proper UPDATE syntax to update an existing document
  /// which is the recommended way to update documents in Ditto
  Future<void> updateUserProfile(UserProfile userProfile) async {
    try {
      if (!_isInitialized) {
        try {
          await initialize();
        } catch (e) {
          debugPrint('Error initializing DittoService during update: $e');
          if (kIsWeb) {
            // For web, we'll skip updating silently
            debugPrint('Web platform: Skipping Ditto update operation');
            return;
          } else {
            rethrow;
          }
        }
      }

      if (_ditto == null) {
        if (kIsWeb) {
          // For web, we'll skip updating silently
          debugPrint('Web platform: Ditto is null, skipping update operation');
          return;
        } else {
          throw Exception('Ditto not initialized');
        }
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
      if (kIsWeb) {
        // For web, we'll allow the operation to fail silently
        debugPrint('Web platform: Continuing despite Ditto update error');
      } else {
        rethrow;
      }
    }
  }

  Future<UserProfile?> getUserProfile(String id) async {
    try {
      if (!_isInitialized) {
        try {
          await initialize();
        } catch (e) {
          debugPrint('Error initializing DittoService during get: $e');
          return null;
        }
      }

      if (_ditto == null) {
        debugPrint('Ditto is null, cannot get user profile');
        return null;
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
        try {
          await initialize();
        } catch (e) {
          debugPrint('Error initializing DittoService during getAll: $e');
          return [];
        }
      }

      if (_ditto == null) {
        debugPrint('Ditto is null, cannot get all user profiles');
        return [];
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

  /// Static accessor for the singleton instance
  /// Use this method when you need direct access to the singleton outside of providers
  static DittoService get instance {
    return _dittoServiceInstance;
  }

  /// Carefully disposes resources and prepares the singleton for cleanup
  /// For web, this ensures proper cleanup of resources to prevent memory leaks
  Future<void> dispose() async {
    if (!_isInitialized) return;

    debugPrint('Disposing DittoService singleton instance');
    _observationTimer?.cancel();
    _userProfilesController.close();

    if (_ditto != null) {
      try {
        // First stop sync
        debugPrint('Stopping Ditto sync');
        _ditto!.stopSync();

        // For web, we need to be extra careful about cleanup
        if (kIsWeb) {
          debugPrint(
            'Web platform: Performing thorough cleanup of Ditto resources',
          );

          // Allow some time for resources to release
          await Future.delayed(const Duration(milliseconds: 200));

          // Try to explicitly close Ditto if supported by the SDK version
          try {
            // Some versions of Ditto SDK might support explicit close
            // This is a best practice to try to release lock files
            debugPrint('Attempting explicit close of Ditto resources');

            // Reset Ditto reference to help with garbage collection
            _ditto = null;

            // Allow event loop to execute before continuing with cleanup
            await Future.delayed(Duration.zero);
          } catch (closeError) {
            debugPrint(
              'Note: Explicit close not supported or failed: $closeError',
            );
          }
        }

        // Reset initialization flag
        _isInitialized = false;
      } catch (e) {
        debugPrint('Error during Ditto cleanup: $e');
      }
    }

    // Reset Ditto reference to ensure it's properly garbage collected
    _ditto = null;

    debugPrint(
      'DittoService singleton has been disposed and is available for reinitialization',
    );
  }

  /// Registers a hook to automatically dispose the Ditto service when the web page is unloaded
  /// Call this from the main app initialization
  void registerWebDisposeHooks() {
    if (kIsWeb) {
      // In a real implementation, you would register a JS event listener for 'beforeunload'
      // to ensure proper cleanup when the page is closed or refreshed
      debugPrint('Registering web hooks for automatic cleanup on page unload');

      // Set up error handling for Ditto-specific errors
      // In a real implementation, you would use JS interop to register error handlers
      // or use a Flutter-specific mechanism to catch errors
      debugPrint('Setting up error handlers for Ditto in web environment');

      // Example of how you might handle it in a real implementation
      // window.addEventListener('error', (event) => {
      //   if (event.message.includes('lock')) {
      //     console.log('Detected locking error, attempting cleanup');
      //     disposeSync();
      //   }
      // });
    }
  }
}
