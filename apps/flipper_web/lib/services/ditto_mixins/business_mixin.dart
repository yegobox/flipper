import 'package:flipper_web/models/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'ditto_core_mixin.dart';

mixin BusinessMixin on DittoCore {
  /// Save a business to the businesses collection
  Future<void> saveBusiness(Business business) async {
    if (dittoInstance == null) return handleNotInitialized('saveBusiness');
    final docId = business.id;
    await executeUpsert('businesses', docId, business.toJson());
    debugPrint('Saved business with ID: ${business.id}');
  }

  /// Update a business in the businesses collection
  Future<void> updateBusiness(Business business) async {
    if (dittoInstance == null) return handleNotInitialized('updateBusiness');
    final docId = business.id;
    await executeUpdate('businesses', docId, business.toJson());
    debugPrint('Successfully updated business with ID: ${business.id}');
  }

  /// Get businesses for a specific user
  Future<List<Business>> getBusinessesForUser(String userId) async {
    if (dittoInstance == null) return handleNotInitializedAndReturn('getBusinessesForUser', []);
    final result = await dittoInstance!.store.execute(
      "SELECT * FROM businesses WHERE userId = :userId",
      arguments: {"userId": userId},
    );
    return result.items
        .map((doc) => Business.fromJson(Map<String, dynamic>.from(doc.value)))
        .toList();
  }
}