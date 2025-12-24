import 'package:flipper_web/models/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'ditto_core_mixin.dart';

mixin BusinessMixin on DittoCore {
  /// Save a business to the businesses collection
  Future<void> saveBusiness(Business business) async {
    if (dittoInstance == null) return _handleNotInitialized('saveBusiness');
    final docId = business.id;
    await _executeUpsert('businesses', docId, business.toJson());
    debugPrint('Saved business with ID: ${business.id}');
  }

  /// Update a business in the businesses collection
  Future<void> updateBusiness(Business business) async {
    if (dittoInstance == null) return _handleNotInitialized('updateBusiness');
    final docId = business.id;
    await _executeUpdate('businesses', docId, business.toJson());
    debugPrint('Successfully updated business with ID: ${business.id}');
  }

  /// Get businesses for a specific user
  Future<List<Business>> getBusinessesForUser(String userId) async {
    if (dittoInstance == null) return _handleNotInitializedAndReturn('getBusinessesForUser', []);
    final result = await dittoInstance!.store.execute(
      "SELECT * FROM businesses WHERE userId = :userId",
      arguments: {"userId": userId},
    );
    return result.items
        .map((doc) => Business.fromJson(Map<String, dynamic>.from(doc.value)))
        .toList();
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

  /// Helper method to execute update operation
  Future<void> _executeUpdate(String collection, String docId, Map<String, dynamic> data) async {
    final fields = data.keys.map((key) => '$key = :$key').join(', ');
    await dittoInstance!.store.execute(
      "UPDATE $collection SET $fields WHERE _id = :id",
      arguments: {"id": docId, ...data},
    );
  }
}