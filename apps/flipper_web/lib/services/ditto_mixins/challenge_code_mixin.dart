import 'dart:async';

import 'package:flutter/foundation.dart' hide Category;
import 'ditto_core_mixin.dart';

mixin ChallengeCodeMixin on DittoCore {
  /// Save a challenge code to the challengeCodes collection
  Future<void> saveChallengeCode(Map<String, dynamic> challengeCode) async {
    if (dittoInstance == null) return handleNotInitialized('saveChallengeCode');
    final docId = challengeCode['_id'] ?? challengeCode['id'];
    await executeUpsert('challengeCodes', docId, challengeCode);
    debugPrint('Saved challenge code with ID: $docId');
  }

  /// Get challenge codes from the challengeCodes collection
  Future<List<Map<String, dynamic>>> getChallengeCodes({
    String? businessId,
    bool onlyValid = true,
  }) async {
    if (dittoInstance == null)
      return handleNotInitializedAndReturn('getChallengeCodes', []);
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
    final result = await dittoInstance!.store.execute(
      query,
      arguments: arguments,
    );
    return result.items
        .map((doc) => Map<String, dynamic>.from(doc.value))
        .toList();
  }

  /// Observe challenge codes for real-time updates
  Stream<List<Map<String, dynamic>>> observeChallengeCodes({
    String? businessId,
    bool onlyValid = true,
  }) {
    if (dittoInstance == null) return Stream.value([]);
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
    observer = dittoInstance!.store.registerObserver(
      query,
      arguments: arguments,
      onChange: (queryResult) {
        if (controller.isClosed) return;
        final items = queryResult.items
            .map((doc) => Map<String, dynamic>.from(doc.value))
            .toList();
        controller.add(items);
      },
    );
    controller.onCancel = () async {
      await observer?.cancel();
      await controller.close();
    };
    return controller.stream;
  }
}
