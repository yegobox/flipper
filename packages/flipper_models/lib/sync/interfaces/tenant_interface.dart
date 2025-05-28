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
    int? businessId,
    bool? sessionActive,
    int? branchId,
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

  Stream<Tenant?> getDefaultTenant({required int businessId});

  Future<Branch> activeBranch();
  Future<User?> authUser({required String uuid});
  // save user
  Future<User> saveUser({required User user});

  Future<Business?> activeBusiness({int? userId});
  Future<Tenant?> tenant(
      {int? businessId, int? userId, String? id, required bool fetchRemote});
  Future<List<Tenant>> tenants({int? businessId, int? excludeUserId});
  Future<List<ITenant>> tenantsFromOnline(
      {required int businessId,
      required HttpClientInterface flipperHttpClient});
  Future<void> updateTenant(
      {String? tenantId,
      String? name,
      String? phoneNumber,
      String? email,
      int? userId,
      int? businessId,
      String? type,
      int? id,
      int? pin,
      bool? sessionActive,
      int? branchId});
}
