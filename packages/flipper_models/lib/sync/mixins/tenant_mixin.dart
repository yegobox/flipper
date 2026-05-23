import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helpers/tenant_supabase_queries.dart';
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
        where: [Where('id').isExactly(ProxyService.box.getBusinessId())],
      ),
    )).firstOrNull;
  }

  @override
  Stream<Tenant?> getDefaultTenant({required String businessId}) {
    return Stream.fromFuture(
      TenantSupabaseQueries.defaultForBusiness(businessId),
    );
  }

  @override
  Future<User> saveUser({required User user}) {
    return repository.upsert(user);
  }

  @override
  Future<User?> authUser({required String uuid}) async {
    return (await repository.get<User>(
      policy: OfflineFirstGetPolicy.awaitRemote,
      query: Query(where: [Where('uuid').isExactly(uuid)]),
    )).firstOrNull;
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

    final http.Response response = await flipperHttpClient.post(
      Uri.parse("$apihub/v2/api/pin"),
      body: data,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw InternalServerError(term: "internal server error");
    }
  }

  @override
  Future<Tenant?> tenant({
    String? businessId,
    String? userId,
    String? tenantId,
    required bool fetchRemote,
  }) async {
    if (businessId != null) {
      return TenantSupabaseQueries.firstForBusiness(businessId);
    }
    if (userId != null) {
      return TenantSupabaseQueries.byUserIdOrPin(userId);
    }
    if (tenantId != null) {
      return TenantSupabaseQueries.byId(tenantId);
    }
    return null;
  }

  @override
  Future<List<Tenant>> tenants({String? businessId, int? excludeUserId}) async {
    return TenantSupabaseQueries.listForBusiness(
      businessId,
      excludeUserId: excludeUserId?.toString(),
    );
  }

  @override
  Future<void> updateTenant({
    String? tenantId,
    String? name,
    String? phoneNumber,
    String? email,
    String? userId,
    String? businessId,
    String? type,
    String? id,
    int? pin,
    bool? sessionActive,
    String? branchId,
  }) async {}

  @override
  Future<void> deleteTenantsWithNullPin({String? businessId}) async {}
}
