import 'package:flutter/foundation.dart' hide Category;
import 'ditto_core_mixin.dart';

mixin ClaimMixin on DittoCore {
  /// Save a claim to the claims collection
  Future<void> saveClaim(Map<String, dynamic> claim) async {
    if (dittoInstance == null) return handleNotInitialized('saveClaim');
    final docId = claim['_id'] ?? claim['id'];
    await executeUpsert('claims', docId, claim);
    debugPrint('Saved claim with ID: $docId');
  }

  /// Get claims for a user from the claims collection
  Future<List<Map<String, dynamic>>> getClaimsForUser(String userId) async {
    if (dittoInstance == null)
      return handleNotInitializedAndReturn('getClaimsForUser', []);
    final result = await dittoInstance!.store.execute(
      "SELECT * FROM claims WHERE userId = :userId ORDER BY claimedAt DESC",
      arguments: {"userId": userId},
    );
    return result.items
        .map((doc) => Map<String, dynamic>.from(doc.value))
        .toList();
  }

  /// Check if a challenge code has already been claimed by a user
  Future<bool> isChallengeCodeClaimed(
    String userId,
    String challengeCodeId,
  ) async {
    if (dittoInstance == null)
      return handleNotInitializedAndReturn('isChallengeCodeClaimed', false);
    final result = await dittoInstance!.store.execute(
      "SELECT * FROM claims WHERE userId = :userId AND challengeCodeId = :challengeCodeId LIMIT 1",
      arguments: {"userId": userId, "challengeCodeId": challengeCodeId},
    );
    return result.items.isNotEmpty;
  }
}
