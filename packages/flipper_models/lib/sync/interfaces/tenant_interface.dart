import 'dart:async';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/models/user.model.dart';

abstract class TenantInterface {
  Future<void> createPin({
    required HttpClientInterface flipperHttpClient,
    required String phoneNumber,
    required int pin,
    required String branchId,
    required String businessId,
    required int defaultApp,
  });

  Stream<Tenant?> getDefaultTenant({required String businessId});

  Future<User?> authUser({required String uuid});
  // save user
  Future<User> saveUser({required User user});

  Future<Business?> activeBusiness();
  Future<Tenant?> tenant(
      {String? businessId,
      String? userId,
      String? tenantId,
      required bool fetchRemote});
  Future<List<Tenant>> tenants({String? businessId, int? excludeUserId});

  /// Delete tenants that have a null `pin` value. If [businessId] is provided,
  /// only tenants for that business will be checked and deleted.
  Future<void> deleteTenantsWithNullPin({String? businessId});
  Future<void> updateTenant(
      {String? tenantId,
      String? name,
      String? phoneNumber,
      String? email,
      String? userId,
      String? businessId,
      String? type,
      String? id,
      int? pin,
      bool? sessionActive,
      String? branchId});
}
