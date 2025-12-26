
import 'package:flipper_web/models/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'ditto_core_mixin.dart';

mixin TenantMixin on DittoCore {
  /// Save a tenant to the tenants collection
  Future<void> saveTenant(Tenant tenant) async {
    if (dittoInstance == null) return handleNotInitialized('saveTenant');
    final docId = tenant.id;
    await executeUpsert('tenants', docId, tenant.toJson());
    debugPrint('Saved tenant with ID: ${tenant.id}');
  }

  /// Update a tenant in the tenants collection
  Future<void> updateTenant(Tenant tenant) async {
    if (dittoInstance == null) return handleNotInitialized('updateTenant');
    final docId = tenant.id;
    await executeUpdate('tenants', docId, tenant.toJson());
    debugPrint('Successfully updated tenant with ID: ${tenant.id}');
  }

  /// Get tenants for a specific user
  Future<List<Tenant>> getTenantsForUser(String userId) async {
    if (dittoInstance == null) return handleNotInitializedAndReturn('getTenantsForUser', []);
    final result = await dittoInstance!.store.execute(
      "SELECT * FROM tenants WHERE userId = :userId",
      arguments: {"userId": userId},
    );
    return result.items
        .map((doc) => Tenant.fromJson(Map<String, dynamic>.from(doc.value)))
        .toList();
  }
}