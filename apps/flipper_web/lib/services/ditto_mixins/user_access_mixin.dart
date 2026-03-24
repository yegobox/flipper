import 'package:flutter/foundation.dart' hide Category;
import 'ditto_core_mixin.dart';

mixin UserAccessMixin on DittoCore {
  /// Save the nested user access object to Ditto.
  /// This includes businesses, branches, and their respective accesses.
  Future<void> saveUserAccess(Map<String, dynamic> userJson) async {
    if (dittoInstance == null) return handleNotInitialized('saveUserAccess');

    final userId = userJson['id'] ?? userJson['userId'];
    if (userId == null) {
      debugPrint('❌ Cannot save user access: userId is null');
      return;
    }

    try {
      // We save the entire nested structure under the 'user_access' collection
      // using the userId as the document ID to ensure easy retrieval and one-doc-per-user.
      await executeUpsert('user_access', userId.toString(), userJson);
      debugPrint(
        '✅ Successfully saved user access data to Ditto for user: $userId',
      );
    } catch (e) {
      debugPrint('❌ Error saving user access data to Ditto: $e');
    }
  }

  /// Retrieve the user access object from Ditto.
  /// Note: This performs a one-time fetch without registering subscriptions/observers
  /// to avoid duplicate live queries. Use watchUserAccessStream for reactive updates.
  Future<Map<String, dynamic>?> getUserAccess(String userId) async {
    debugPrint('🔍 getUserAccess called for userId: $userId');
    debugPrint(
      '🔍 dittoInstance state: ${dittoInstance != null ? "SET (${dittoInstance.hashCode})" : "NULL"}',
    );

    if (dittoInstance == null) {
      return handleNotInitializedAndReturn('getUserAccess', null);
    }

    try {
      // Simple one-time query - no subscription/observer registration
      // to avoid duplicate live queries
      final result = await dittoInstance!.store.execute(
        "SELECT * FROM user_access WHERE _id = :id",
        arguments: {"id": userId},
      );

      if (result.items.isEmpty) return null;

      return Map<String, dynamic>.from(result.items.first.value);
    } catch (e) {
      debugPrint('❌ Error retrieving user access data from Ditto: $e');
      return null;
    }
  }

  /// Get branches for a specific business from user access data.
  Future<List<Map<String, dynamic>>> getBranches(
    String userId,
    String businessId,
  ) async {
    final userAccess = await getUserAccess(userId);
    if (userAccess == null || !userAccess.containsKey('businesses')) {
      return [];
    }

    final List<dynamic> businesses = userAccess['businesses'];
    final business = businesses.firstWhere(
      (b) => b['id'] == businessId,
      orElse: () => null,
    );

    if (business != null && business.containsKey('branches')) {
      return List<Map<String, dynamic>>.from(business['branches']);
    }

    return [];
  }

  /// Delete user access data from Ditto.
  Future<void> deleteUserAccess(String userId) async {
    if (dittoInstance == null) return handleNotInitialized('deleteUserAccess');

    try {
      await dittoInstance!.store.execute(
        "EVICT FROM user_access WHERE _id = :id",
        arguments: {"id": userId},
      );
      debugPrint('🗑️ Deleted user access data for user: $userId');
    } catch (e) {
      debugPrint('❌ Error deleting user access data from Ditto: $e');
    }
  }
}
