// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'dart:async';

import 'package:ditto_live/ditto_live.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/models/user_profile.dart';

// Global singleton instance of DittoService
late final DittoService _dittoServiceInstance = DittoService._internal();

/// Provider for the DittoService singleton
final dittoServiceProvider = Provider<DittoService>((ref) {
  return _dittoServiceInstance;
});

/// Simplified DittoService that manages a single Ditto instance
/// initialized once at app startup
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

  Stream<List<UserProfile>> get userProfiles => _userProfilesController.stream;

  /// Sets the Ditto instance (called from main.dart after initialization)
  void setDitto(Ditto ditto) {
    _ditto = ditto;
    _setupObservation();
  }

  Future<void> _setupObservation() async {
    try {
      // Initial load of user profiles
      await _loadAndUpdateUserProfiles();

      // Set up a periodic timer to refresh data (simulating live updates)
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
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot save user profile');
        return;
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
      // Don't rethrow - allow graceful degradation
    }
  }

  /// Update an existing user profile in Ditto
  Future<void> updateUserProfile(UserProfile userProfile) async {
    try {
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot update user profile');
        return;
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
      // Don't rethrow - allow graceful degradation
    }
  }

  Future<UserProfile?> getUserProfile(String id) async {
    try {
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot get user profile');
        return null;
      }

      // Use DQL to get a single document by ID
      final result = await _ditto!.store.execute(
        "SELECT * FROM users WHERE _id = :id",
        arguments: {"id": id},
      );

      if (result.items.isEmpty) {
        debugPrint('No user profile found for ID: $id');
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
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot get all user profiles');
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
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot delete user profile');
        return;
      }

      await _ditto!.store.execute(
        "REMOVE FROM COLLECTION users WHERE _id = :id",
        arguments: {"id": id},
      );
      debugPrint('Deleted user profile with ID: $id');
    } catch (e) {
      debugPrint('Error deleting user profile from Ditto: $e');
      // Don't rethrow - allow graceful degradation
    }
  }

  /// Checks if Ditto is properly initialized and ready to use
  bool isReady() {
    return _ditto != null;
  }

  /// Static accessor for the singleton instance
  static DittoService get instance {
    return _dittoServiceInstance;
  }

  /// Disposes resources and prepares for cleanup
  Future<void> dispose() async {
    _observationTimer?.cancel();
    _userProfilesController.close();

    if (_ditto != null) {
      try {
        debugPrint('Stopping Ditto sync');
        _ditto!.stopSync();
        _ditto = null;
      } catch (e) {
        debugPrint('Error during Ditto cleanup: $e');
      }
    }

    debugPrint('DittoService has been disposed');
  }
}
