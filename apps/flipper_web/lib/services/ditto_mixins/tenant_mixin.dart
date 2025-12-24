
import 'package:flipper_web/models/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'ditto_core_mixin.dart';

mixin TenantMixin on DittoCore {
  /// Save a tenant to the tenants collection
  Future<void> saveTenant(Tenant tenant) async {
    if (dittoInstance == null) return _handleNotInitialized('saveTenant');
    final docId = tenant.id;
    await _executeUpsert('tenants', docId, tenant.toJson());
    debugPrint('Saved tenant with ID: ${tenant.id}');
  }

  /// Update a tenant in the tenants collection
  Future<void> updateTenant(Tenant tenant) async {
    if (dittoInstance == null) return _handleNotInitialized('updateTenant');
    final docId = tenant.id;
    await _executeUpdate('tenants', docId, tenant.toJson());
    debugPrint('Successfully updated tenant with ID: ${tenant.id}');
  }

  /// Get tenants for a specific user
  Future<List<Tenant>> getTenantsForUser(String userId) async {
    if (dittoInstance == null) return _handleNotInitializedAndReturn('getTenantsForUser', []);
    final result = await dittoInstance!.store.execute(
      "SELECT * FROM tenants WHERE userId = :userId",
      arguments: {"userId": userId},
    );
    return result.items
        .map((doc) => Tenant.fromJson(Map<String, dynamic>.from(doc.value)))
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