// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'dart:async';

import 'package:ditto_live/ditto_live.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:permission_handler/permission_handler.dart';

// Global singleton instance of DittoService
final DittoService _dittoServiceInstance = DittoService._internal();

/// Provider for the DittoService singleton
final dittoServiceProvider = Provider<DittoService>((ref) {
  return _dittoServiceInstance;
});

/// Provider for Ditto sync control
final dittoSyncProvider = Provider<DittoSyncController>((ref) {
  return DittoSyncController();
});

class DittoSyncController {
  /// Starts Ditto sync
  void startSync() {
    DittoService.instance.startSync();
  }

  /// Stops Ditto sync
  void stopSync() {
    DittoService.instance.stopSync();
  }

  /// Checks if Ditto is ready for sync operations
  bool isReady() {
    return DittoService.instance.isReady();
  }
}

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

    // Request necessary permissions for Ditto
    final platform = Ditto.currentPlatform;
    if (platform case SupportedPlatform.android || SupportedPlatform.ios) {
      [
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
        Permission.nearbyWifiDevices,
        Permission.bluetoothScan,
      ].request();
    }

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

      // Use DQL INSERT syntax to insert document
      await _ditto!.store.execute(
        "INSERT INTO users DOCUMENTS (:profile)",
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
        """UPDATE users SET
          id = :id,
          phoneNumber = :phoneNumber,
          token = :token,
          tenants = :tenants,
          pin = :pin
        WHERE _id = :id""",
        arguments: {"id": docId, ...userProfile.toJson()},
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

  /// Starts Ditto sync if Ditto is initialized
  void startSync() {
    if (_ditto != null) {
      _ditto!.startSync();
      debugPrint('Ditto sync started');
    } else {
      debugPrint('Cannot start sync: Ditto not initialized');
    }
  }

  /// Stops Ditto sync if Ditto is initialized
  void stopSync() {
    if (_ditto != null) {
      _ditto!.stopSync();
      debugPrint('Ditto sync stopped');
    } else {
      debugPrint('Cannot stop sync: Ditto not initialized');
    }
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

  /// Save a business to the businesses collection
  Future<void> saveBusiness(Business business) async {
    try {
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot save business');
        return;
      }

      final docId = business.id;

      await _ditto!.store.execute(
        "INSERT INTO businesses DOCUMENTS (:business) ON ID CONFLICT DO UPDATE",
        arguments: {
          "business": {"_id": docId, ...business.toJson()},
        },
      );
      debugPrint('Saved business with ID: ${business.id}');
    } catch (e) {
      debugPrint('Error saving business to Ditto: $e');
    }
  }

  /// Save a branch to the branches collection
  Future<void> saveBranch(Branch branch) async {
    try {
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot save branch');
        return;
      }

      final docId = branch.id;

      await _ditto!.store.execute(
        "INSERT INTO branches DOCUMENTS (:branch) ON ID CONFLICT DO UPDATE",
        arguments: {
          "branch": {"_id": docId, ...branch.toJson()},
        },
      );
      debugPrint('Saved branch with ID: ${branch.id}');
    } catch (e) {
      debugPrint('Error saving branch to Ditto: $e');
    }
  }

  /// Save a tenant to the tenants collection
  Future<void> saveTenant(Tenant tenant) async {
    try {
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot save tenant');
        return;
      }

      final docId = tenant.id;

      await _ditto!.store.execute(
        "INSERT INTO tenants DOCUMENTS (:tenant) ON ID CONFLICT DO UPDATE",
        arguments: {
          "tenant": {"_id": docId, ...tenant.toJson()},
        },
      );
      debugPrint('Saved tenant with ID: ${tenant.id}');
    } catch (e) {
      debugPrint('Error saving tenant to Ditto: $e');
    }
  }

  /// Get businesses for a specific user
  Future<List<Business>> getBusinessesForUser(String userId) async {
    try {
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot get businesses');
        return [];
      }

      final result = await _ditto!.store.execute(
        "SELECT * FROM businesses WHERE userId = :userId",
        arguments: {"userId": userId},
      );

      return result.items
          .map((doc) => Business.fromJson(Map<String, dynamic>.from(doc.value)))
          .toList();
    } catch (e) {
      debugPrint('Error getting businesses for user $userId: $e');
      return [];
    }
  }

  /// Get branches for a specific business
  Future<List<Branch>> getBranchesForBusiness(String serverId) async {
    debugPrint('🔍 Querying branches for serverId : $serverId');
    try {
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot get branches');
        return [];
      }

      // Convert serverId to int for querying
      final businessIdInt = int.tryParse(serverId);
      if (businessIdInt == null) {
        debugPrint('❌ Invalid serverId format: $serverId');
        return [];
      }

      final result = await _ditto!.store.execute(
        "SELECT * FROM branches WHERE businessId = :businessId",
        arguments: {"businessId": businessIdInt},
      );

      final branches = result.items
          .map((doc) => Branch.fromJson(Map<String, dynamic>.from(doc.value)))
          .toList();

      return branches;
    } catch (e) {
      debugPrint('Error getting branches for business $serverId: $e');
      return [];
    }
  }

  /// Get tenants for a specific user
  Future<List<Tenant>> getTenantsForUser(String userId) async {
    try {
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot get tenants');
        return [];
      }

      final result = await _ditto!.store.execute(
        "SELECT * FROM tenants WHERE userId = :userId",
        arguments: {"userId": userId},
      );

      return result.items
          .map((doc) => Tenant.fromJson(Map<String, dynamic>.from(doc.value)))
          .toList();
    } catch (e) {
      debugPrint('Error getting tenants for user $userId: $e');
      return [];
    }
  }

  /// Update a business in the businesses collection
  Future<void> updateBusiness(Business business) async {
    try {
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot update business');
        return;
      }

      final docId = business.id;

      await _ditto!.store.execute(
        """UPDATE businesses SET
          id = :id,
          name = :name,
          country = :country,
          currency = :currency,
          latitude = :latitude,
          longitude = :longitude,
          active = :active,
          userId = :userId,
          phoneNumber = :phoneNumber,
          lastSeen = :lastSeen,
          backUpEnabled = :backUpEnabled,
          fullName = :fullName,
          tinNumber = :tinNumber,
          taxEnabled = :taxEnabled,
          businessTypeId = :businessTypeId,
          serverId = :serverId,
          is_default = :is_default,
          lastSubscriptionPaymentSucceeded = :lastSubscriptionPaymentSucceeded
        WHERE _id = :id""",
        arguments: {"id": docId, ...business.toJson()},
      );

      debugPrint('Successfully updated business with ID: ${business.id}');
    } catch (e) {
      debugPrint('Error updating business in Ditto: $e');
    }
  }

  /// Update a branch in the branches collection
  Future<void> updateBranch(Branch branch) async {
    try {
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot update branch');
        return;
      }

      final docId = branch.id;

      await _ditto!.store.execute(
        """UPDATE branches SET
          id = :id,
          description = :description,
          name = :name,
          longitude = :longitude,
          latitude = :latitude,
          businessId = :businessId,
          serverId = :serverId,
          active = :active,
          is_default = :is_default
        WHERE _id = :id""",
        arguments: {"id": docId, ...branch.toJson()},
      );

      debugPrint('Successfully updated branch with ID: ${branch.id}');
    } catch (e) {
      debugPrint('Error updating branch in Ditto: $e');
    }
  }

  /// Update a tenant in the tenants collection
  Future<void> updateTenant(Tenant tenant) async {
    try {
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot update tenant');
        return;
      }

      final docId = tenant.id;

      await _ditto!.store.execute(
        """UPDATE tenants SET
          id = :id,
          name = :name,
          phoneNumber = :phoneNumber,
          email = :email,
          imageUrl = :imageUrl,
          permissions = :permissions,
          branches = :branches,
          businesses = :businesses,
          businessId = :businessId,
          nfcEnabled = :nfcEnabled,
          userId = :userId,
          pin = :pin,
          is_default = :is_default,
          type = :type
        WHERE _id = :id""",
        arguments: {"id": docId, ...tenant.toJson()},
      );

      debugPrint('Successfully updated tenant with ID: ${tenant.id}');
    } catch (e) {
      debugPrint('Error updating tenant in Ditto: $e');
    }
  }

  /// Save an event to the events collection
  Future<void> saveEvent(Map<String, dynamic> eventData, String eventId) async {
    try {
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot save event');
        return;
      }

      await _ditto!.store.execute(
        "INSERT INTO events DOCUMENTS (:event) ON ID CONFLICT DO UPDATE",
        arguments: {
          "event": {
            "_id": eventId,
            ...eventData,
            "timestamp": DateTime.now().toIso8601String(),
          },
        },
      );
      debugPrint('Saved event with ID: $eventId');
    } catch (e) {
      debugPrint('Error saving event to Ditto: $e');
    }
  }

  /// Get events for a specific channel and type
  Future<List<Map<String, dynamic>>> getEvents(
    String channel,
    String eventType,
  ) async {
    try {
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot get events');
        return [];
      }

      final result = await _ditto!.store.execute(
        "SELECT * FROM events WHERE channel = :channel AND type = :eventType ORDER BY timestamp DESC",
        arguments: {"channel": channel, "eventType": eventType},
      );

      return result.items
          .map((doc) => Map<String, dynamic>.from(doc.value))
          .toList();
    } catch (e) {
      debugPrint('Error getting events: $e');
      return [];
    }
  }
}
