import 'dart:async';

import 'package:flipper_models/sync/interfaces/business_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

mixin BusinessMixin implements BusinessInterface {
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
  Future<Category?> activeCategory({required int branchId}) async {
    return (await repository.get<Category>(
            query: Query(where: [
              Where('focused').isExactly(true),
              Where('active').isExactly(true),
              Where('branchId').isExactly(branchId),
            ], limit: 1),
            policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist))
        .firstOrNull;
  }

  @override
  FutureOr<Business?> getBusinessById({required int businessId}) async {
    final repository = Repository();
    final query = Query(where: [Where('serverId').isExactly(businessId)]);
    final result = await repository.get<Business>(
        query: query, policy: OfflineFirstGetPolicy.localOnly);
    return result.firstOrNull;
  }
}
