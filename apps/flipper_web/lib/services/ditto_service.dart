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
  StreamController<List<UserProfile>>? _userProfilesController;
  final List<void Function(Ditto?)> _dittoListeners = [];

  Stream<List<UserProfile>> get userProfiles {
    _userProfilesController ??= StreamController<List<UserProfile>>.broadcast();
    return _userProfilesController!.stream;
  }

  /// Register a listener that will be notified whenever the underlying Ditto
  /// instance changes. The listener is invoked immediately with the current
  /// instance (which can be null).
  void addDittoListener(void Function(Ditto?) listener) {
    _dittoListeners.add(listener);
    listener(_ditto);
  }

  /// Remove a previously registered Ditto listener.
  void removeDittoListener(void Function(Ditto?) listener) {
    _dittoListeners.remove(listener);
  }

  void _notifyDittoListeners() {
    for (final listener in List<void Function(Ditto?)>.from(_dittoListeners)) {
      try {
        listener(_ditto);
      } catch (error) {
        debugPrint('Error notifying Ditto listener: $error');
      }
    }
  }

  /// Sets the Ditto instance (called from main.dart after initialization)
  void setDitto(Ditto ditto) {
    // Dispose of existing Ditto instance if it exists to prevent file lock conflicts
    if (_ditto != null) {
      debugPrint('Disposing existing Ditto instance before setting new one');
      try {
        _ditto!.stopSync();
        // Give a moment for cleanup to complete
      } catch (e) {
        debugPrint('Error during existing Ditto disposal: $e');
      }
    }

    _ditto = ditto;
    _notifyDittoListeners();

    // Request necessary permissions for Ditto
    final platform = Ditto.currentPlatform;
    if (platform case SupportedPlatform.android || SupportedPlatform.ios) {
      [
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
        Permission.nearbyWifiDevices,
        Permission.bluetoothScan,
        Permission.location, // Required for Ditto on Android
      ].request();
    }

    // Log Ditto device info for debugging
    debugPrint('📱 Ditto device initialized: ${ditto.deviceName}');

    // Note about mDNS warnings in debug
    if (kDebugMode) {
      debugPrint(
        'ℹ️  mDNS NameConflict warnings are normal in development when multiple instances are running',
      );
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
      _userProfilesController ??=
          StreamController<List<UserProfile>>.broadcast();
      _userProfilesController!.add(profiles);
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

      // Use EVICT instead of REMOVE FROM COLLECTION for DQL compatibility
      await _ditto!.store.execute(
        "EVICT FROM users WHERE _id = :id",
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

  /// Get the Ditto instance (for use by cache implementations)
  Ditto? get dittoInstance => _ditto;

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

  /// Reset the service state (useful for hot restart scenarios)
  static Future<void> resetInstance() async {
    debugPrint('🔄 Resetting DittoService instance...');
    await _dittoServiceInstance.dispose();
    debugPrint('✅ DittoService instance reset completed');
  }

  /// Disposes resources and prepares for cleanup
  Future<void> dispose() async {
    debugPrint('🧹 Starting DittoService disposal...');

    // Cancel observation timer
    _observationTimer?.cancel();
    _observationTimer = null;

    // Close stream controller
    if (_userProfilesController != null && !_userProfilesController!.isClosed) {
      await _userProfilesController!.close();
      _userProfilesController = null;
    }

    // Properly dispose of Ditto instance
    if (_ditto != null) {
      try {
        debugPrint('🛑 Stopping Ditto sync...');
        _ditto!.stopSync();

        // Wait a bit to ensure sync is fully stopped
        await Future.delayed(const Duration(milliseconds: 200));

        debugPrint('🗑️  Clearing Ditto instance reference...');
        _ditto = null;
        _notifyDittoListeners();

        // Additional wait to ensure file locks are released
        await Future.delayed(const Duration(milliseconds: 300));
      } catch (e) {
        debugPrint('❌ Error during Ditto cleanup: $e');
      }
    }

    debugPrint('✅ DittoService disposal completed');
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
      // Normalize event payload: if caller provided a nested `data` map, merge
      // its keys to the top-level so observers and downstream parsers see a
      // flat map (e.g. userId, phone, etc are top-level). Keep the original
      // top-level keys like `channel` and `type`.
      final Map<String, dynamic> flattened = {};
      // Start with top-level eventData fields
      flattened.addAll(eventData);

      // If there's a nested `data` object, merge it into the flattened map
      if (eventData['data'] is Map<String, dynamic>) {
        flattened.addAll(Map<String, dynamic>.from(eventData['data']));
        // Optionally remove the nested `data` key to avoid duplication
        flattened.remove('data');
      }

      // Ensure timestamp and _id are present
      flattened['timestamp'] = DateTime.now().toIso8601String();
      flattened['_id'] = eventId;
      flattened['channel'] = eventId;

      await _ditto!.store.execute(
        "INSERT INTO events DOCUMENTS (:event) ON ID CONFLICT DO UPDATE",
        arguments: {"event": flattened},
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

  /// Save a challenge code to the challengeCodes collection
  Future<void> saveChallengeCode(Map<String, dynamic> challengeCode) async {
    try {
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot save challenge code');
        return;
      }

      final docId = challengeCode['_id'] ?? challengeCode['id'];
      await _ditto!.store.execute(
        "INSERT INTO challengeCodes DOCUMENTS (:challenge) ON ID CONFLICT DO UPDATE",
        arguments: {
          "challenge": {"_id": docId, ...challengeCode},
        },
      );
      debugPrint('Saved challenge code with ID: $docId');
    } catch (e) {
      debugPrint('Error saving challenge code to Ditto: $e');
    }
  }

  /// Get challenge codes from the challengeCodes collection
  Future<List<Map<String, dynamic>>> getChallengeCodes({
    String? businessId,
    bool onlyValid = true,
  }) async {
    try {
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot get challenge codes');
        return [];
      }

      String query = "SELECT * FROM challengeCodes";
      final arguments = <String, dynamic>{};

      if (businessId != null) {
        query += " WHERE businessId = :businessId";
        arguments["businessId"] = businessId;
      }

      if (onlyValid) {
        final whereClause = businessId != null ? " AND" : " WHERE";
        query += "$whereClause validTo > :now";
        arguments["now"] = DateTime.now().toIso8601String();
      }

      query += " ORDER BY createdAt DESC";

      final result = await _ditto!.store.execute(query, arguments: arguments);

      return result.items
          .map((doc) => Map<String, dynamic>.from(doc.value))
          .toList();
    } catch (e) {
      debugPrint('Error getting challenge codes: $e');
      return [];
    }
  }

  /// Save a claim to the claims collection
  Future<void> saveClaim(Map<String, dynamic> claim) async {
    try {
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot save claim');
        return;
      }

      final docId = claim['_id'] ?? claim['id'];
      await _ditto!.store.execute(
        "INSERT INTO claims DOCUMENTS (:claim) ON ID CONFLICT DO UPDATE",
        arguments: {
          "claim": {"_id": docId, ...claim},
        },
      );
      debugPrint('Saved claim with ID: $docId');
    } catch (e) {
      debugPrint('Error saving claim to Ditto: $e');
    }
  }

  /// Get claims for a user from the claims collection
  Future<List<Map<String, dynamic>>> getClaimsForUser(String userId) async {
    try {
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot get claims');
        return [];
      }

      final result = await _ditto!.store.execute(
        "SELECT * FROM claims WHERE userId = :userId ORDER BY claimedAt DESC",
        arguments: {"userId": userId},
      );

      return result.items
          .map((doc) => Map<String, dynamic>.from(doc.value))
          .toList();
    } catch (e) {
      debugPrint('Error getting claims for user $userId: $e');
      return [];
    }
  }

  /// Check if a challenge code has already been claimed by a user
  Future<bool> isChallengeCodeClaimed(
    String userId,
    String challengeCodeId,
  ) async {
    try {
      if (_ditto == null) {
        debugPrint('Ditto not initialized, cannot check claim status');
        return false;
      }

      final result = await _ditto!.store.execute(
        "SELECT * FROM claims WHERE userId = :userId AND challengeCodeId = :challengeCodeId LIMIT 1",
        arguments: {"userId": userId, "challengeCodeId": challengeCodeId},
      );

      return result.items.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking claim status: $e');
      return false;
    }
  }

  /// Observe challenge codes for real-time updates
  Stream<List<Map<String, dynamic>>> observeChallengeCodes({
    String? businessId,
    bool onlyValid = true,
  }) {
    if (_ditto == null) {
      return Stream.value([]);
    }

    String query = "SELECT * FROM challengeCodes";
    final arguments = <String, dynamic>{};

    if (businessId != null) {
      query += " WHERE businessId = :businessId";
      arguments["businessId"] = businessId;
    }

    if (onlyValid) {
      final whereClause = businessId != null ? " AND" : " WHERE";
      query += "$whereClause validTo > :now";
      arguments["now"] = DateTime.now().toIso8601String();
    }

    query += " ORDER BY createdAt DESC";

    final controller = StreamController<List<Map<String, dynamic>>>.broadcast();
    dynamic observer;

    observer = _ditto!.store.registerObserver(
      query,
      arguments: arguments,
      onChange: (queryResult) {
        // Check if controller is closed before adding data
        if (controller.isClosed) {
          return;
        }

        final items = queryResult.items
            .map((doc) => Map<String, dynamic>.from(doc.value))
            .toList();
        controller.add(items);
      },
    );

    // Handle stream cancellation
    controller.onCancel = () async {
      await observer?.cancel();
      await controller.close();
    };

    return controller.stream;
  }
}
