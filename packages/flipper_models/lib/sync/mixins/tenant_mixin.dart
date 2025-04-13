import 'dart:convert';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/sync/interfaces/tenant_interface.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:supabase_models/brick/models/user.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:http/http.dart' as http;

mixin TenantMixin implements TenantInterface {
  String get apihub;
  Repository get repository;

  @override
  Future<Branch> activeBranch() async {
    final branches = await repository.get<Branch>(
      policy: OfflineFirstGetPolicy.localOnly,
    );

    return branches.firstWhere(
      (branch) => branch.isDefault == true || branch.isDefault == 1,
      orElse: () => throw Exception("No default branch found"),
    );
  }

  @override
  Future<Business?> activeBusiness({int? userId}) async {
    return (await repository.get<Business>(
      policy: OfflineFirstGetPolicy.localOnly,
      query: Query(
        where: [
          if (userId != null) Where('userId').isExactly(userId),
          Where('isDefault').isExactly(true),
        ],
      ),
    ))
        .firstOrNull;
  }

  @override
  Future<Tenant?> saveTenant({
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
  }) async {
    final data = jsonEncode({
      "phoneNumber": phoneNumber,
      "name": name,
      "businessId": business.serverId,
      "permissions": [
        {"name": userType.toLowerCase()}
      ],
      "businesses": [business.toJson()],
      "branches": [branch.toJson()]
    });

    final http.Response response = await flipperHttpClient
        .post(Uri.parse("$apihub/v2/api/tenant"), body: data);

    if (response.statusCode == 200) {
      try {
        ITenant jTenant = ITenant.fromRawJson(response.body);
        await createPin(
          flipperHttpClient: flipperHttpClient,
          phoneNumber: phoneNumber!,
          pin: jTenant.userId!,
          branchId: business.serverId.toString(),
          businessId: branch.serverId!.toString(),
          defaultApp: 1,
        );
        return Tenant(
          name: name,
          phoneNumber: phoneNumber,
          email: email,
          nfcEnabled: false,
          businessId: business.serverId,
          userId: jTenant.userId,
          isDefault: true,
          pin: jTenant.userId,
        );
      } catch (e) {
        rethrow;
      }
    } else {
      throw InternalServerError(term: "internal server error");
    }
  }

  @override
  Stream<Tenant?> getDefaultTenant({required int businessId}) {
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
      "branchId": branchId,
      "businessId": businessId,
      "defaultApp": defaultApp,
    });

    final http.Response response = await flipperHttpClient
        .post(Uri.parse("$apihub/v2/api/pin"), body: data);

    if (response.statusCode != 200) {
      throw InternalServerError(term: "internal server error");
    }
  }
}
