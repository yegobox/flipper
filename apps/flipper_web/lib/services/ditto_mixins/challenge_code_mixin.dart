import 'dart:async';

import 'package:flutter/foundation.dart';
import 'ditto_core_mixin.dart';

mixin ChallengeCodeMixin on DittoCore {
  /// Save a challenge code to the challengeCodes collection
  Future<void> saveChallengeCode(Map<String, dynamic> challengeCode) async {
    if (dittoInstance == null) return _handleNotInitialized('saveChallengeCode');
    final docId = challengeCode['_id'] ?? challengeCode['id'];
    await _executeUpsert('challengeCodes', docId, challengeCode);
    debugPrint('Saved challenge code with ID: $docId');
  }

  /// Get challenge codes from the challengeCodes collection
  Future<List<Map<String, dynamic>>> getChallengeCodes({
    String? businessId,
    bool onlyValid = true,
  }) async {
    if (dittoInstance == null) return _handleNotInitializedAndReturn('getChallengeCodes', []);
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
    final result = await dittoInstance!.store.execute(query, arguments: arguments);
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

  /// Helper method to handle not initialized case
  void _handleNotInitialized(String methodName) {
    debugPrint('Ditto not initialized, cannot $methodName');
  }

  /// Helper method to handle not initialized case and return a value
  T _handleNotInitializedAndReturn<T>(String methodName, T defaultValue) {
    debugPrint('Ditto not initialized, cannot $methodName');
    return defaultValue;
  }

  /// Helper method to execute upsert operation
  Future<void> _executeUpsert(String collection, String docId, Map<String, dynamic> data) async {
    await dittoInstance!.store.execute(
      "INSERT INTO $collection DOCUMENTS (:data) ON ID CONFLICT DO UPDATE",
      arguments: {
        "data": {"_id": docId, ...data},
      },
    );
  }
}