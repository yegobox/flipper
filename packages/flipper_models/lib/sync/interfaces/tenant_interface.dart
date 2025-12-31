import 'dart:async';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:supabase_models/brick/models/user.model.dart';

abstract class TenantInterface {
  Future<Tenant?> addNewTenant({
    required Business business,
    required Branch branch,
    String? phoneNumber,
    String? name,
    String? id,
    String? email,
    String? businessId,
    bool? sessionActive,
    String? branchId,
    String? imageUrl,
    int? pin,
    bool? isDefault,
    required HttpClientInterface flipperHttpClient,
    required String userType,
  });
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

  Future<Business?> activeBusiness({int? userId});
  Future<Tenant?> tenant(
      {String? businessId,
      String? userId,
      String? id,
      required bool fetchRemote});
  Future<List<Tenant>> tenants({String? businessId, int? excludeUserId});
  Future<List<ITenant>> tenantsFromOnline(
      {required String businessId,
      required HttpClientInterface flipperHttpClient});

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
