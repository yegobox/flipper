import 'package:flutter/foundation.dart';
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
  Future<Map<String, dynamic>?> getUserAccess(String userId) async {
    if (dittoInstance == null)
      return handleNotInitializedAndReturn('getUserAccess', null);

    try {
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
