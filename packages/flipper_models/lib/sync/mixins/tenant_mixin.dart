import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/interfaces/tenant_interface.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:supabase_models/brick/models/user.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

mixin TenantMixin implements TenantInterface {
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
    // Add tenant saving logic here
    throw UnimplementedError();
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
}
