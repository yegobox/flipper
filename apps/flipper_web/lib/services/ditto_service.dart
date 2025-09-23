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
      // Initialize Ditto SDK
      await Ditto.init();

      // Configure logging (optional)
      DittoLogger.isEnabled = true;
      DittoLogger.minimumLogLevel = LogLevel.info;
      DittoLogger.customLogCallback = (level, message) {
        debugPrint("[$level] => $message");
      };

      // Create identity using App ID and token
      final appID = kDebugMode ? AppSecrets.appIdDebug : AppSecrets.appId;
      final identity = OnlinePlaygroundIdentity(
        appID: appID,
        token: kDebugMode
            ? 'd8b7ac92-004a-47ac-a052-ea8d92d5869f' // dev token
            : 'd8b7ac92-004a-47ac-a052-ea8d92d5869f',
      );

      // Open Ditto instance with identity
      _ditto = await Ditto.open(identity: identity);

      // Configure transport (enable peer-to-peer and cloud sync)
      _ditto!.updateTransportConfig((config) {
        config.setAllPeerToPeerEnabled(true);
        config.connect.webSocketUrls.add("wss://$appID.cloud.ditto.live");
      });

      // Set device name (optional but helpful for debugging)
      _ditto!.deviceName = "Flipper Web (${_ditto!.deviceName})";

      // Start sync
      _ditto!.startSync();

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
      _observationTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
        await _loadAndUpdateUserProfiles();
      });
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

      // Use SQL-like syntax to upsert document
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

  void dispose() {
    _observationTimer?.cancel();
    _userProfilesController.close();
    _ditto?.stopSync();
  }
}
