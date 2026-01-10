import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/interfaces/tenant_interface.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/user.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:http/http.dart' as http;

mixin TenantMixin implements TenantInterface {
  String get apihub;

  Repository repository = Repository();

  @override
  Future<Business?> activeBusiness() async {
    return (await repository.get<Business>(
      policy: OfflineFirstGetPolicy.localOnly,
      query: Query(
        where: [
          Where('id').isExactly(ProxyService.box.getBusinessId()),
        ],
      ),
    ))
        .firstOrNull;
  }

  @override
  Stream<Tenant?> getDefaultTenant({required String businessId}) {
    // Add default tenant retrieval logic here
    throw UnimplementedError();
  }

  @override
  Future<User> saveUser({required User user}) {
    return repository.upsert(user);
  }

  @override
  Future<User?> authUser({required String uuid}) async {
    return (await repository.get<User>(
      policy: OfflineFirstGetPolicy.awaitRemote,
      query: Query(
        where: [Where('uuid').isExactly(uuid)],
      ),
    ))
        .firstOrNull;
  }

  @override
  Future<void> createPin({
    required HttpClientInterface flipperHttpClient,
    required String phoneNumber,
    required int pin,
    required String branchId,
    required String businessId,
    required int defaultApp,
  }) async {
    final data = jsonEncode({
      "phoneNumber": phoneNumber,
      "pin": pin,
      "userId": pin.toString(),
      "branchId": int.parse(branchId),
      "businessId": int.parse(businessId),
      "defaultApp": defaultApp,
    });

    final http.Response response = await flipperHttpClient
        .post(Uri.parse("$apihub/v2/api/pin"), body: data);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw InternalServerError(term: "internal server error");
    }
  }

  @override
  Future<Tenant?> tenant(
      {String? businessId,
      String? userId,
      String? tenantId,
      required bool fetchRemote}) async {
    final policy = fetchRemote
        ? OfflineFirstGetPolicy.awaitRemoteWhenNoneExist
        : OfflineFirstGetPolicy.localOnly;

    // await loadSupabase();
    if (businessId != null) {
      return (await repository.get<Tenant>(
              policy: policy,
              query: Query(where: [Where('businessId').isExactly(businessId)])))
          .firstOrNull;
    } else if (userId != null) {
      return (await repository.get<Tenant>(
              policy: policy,
              query: Query(where: [
                Where('userId').isExactly(userId),
                Where('pin').isExactly(userId),
              ])))
          .firstOrNull;
    } else if (tenantId != null) {
      final response = await repository.get<Tenant>(
          policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
          query: Query(where: [Where('id').isExactly(tenantId)]));
      return response.firstOrNull;
    }
    return null;
  }

  @override
  Future<List<Tenant>> tenants({String? businessId, int? excludeUserId}) {
    return repository.get<Tenant>(
        query: Query(where: [
      Where('businessId').isExactly(businessId),
      if (excludeUserId != null) Where('userId').isNot(excludeUserId),
    ]));
  }

  @override
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
      String? branchId}) async {
    final tenant = (await repository.get<Tenant>(
            query: Query(where: [
      Where('userId').isExactly(userId),
    ])))
        .firstOrNull;

    repository.upsert<Tenant>(Tenant(
      id: tenant?.id ?? tenantId,
      name: name ?? tenant?.name,
      userId: userId ?? tenant?.userId,
      phoneNumber: phoneNumber ?? tenant?.phoneNumber,
      email: email ?? tenant?.email,
      type: type ?? tenant?.type ?? "Agent",
      pin: pin ?? tenant?.pin,
      sessionActive: sessionActive ?? tenant?.sessionActive,
    ));
  }

  @override
  Future<void> deleteTenantsWithNullPin({String? businessId}) async {
    // Fetch tenants scoped by businessId if provided, otherwise all tenants.
    final query = Query(where: [
      if (businessId != null) Where('businessId').isExactly(businessId),
    ]);

    final tenants = await repository.get<Tenant>(query: query);

    for (final tenant in tenants) {
      try {
        if (tenant.pin == null) {
          await repository.delete<Tenant>(tenant);
        }
      } catch (e) {
        // Swallow errors for now but continue deleting others. Caller can
        // rely on logs or higher-level handling if necessary.
      }
    }
  }
}
