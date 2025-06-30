import 'dart:async';

import 'package:flipper_models/sync/interfaces/branch_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

mixin BranchMixin implements BranchInterface {
  Repository get repository;

  @override
  Future<bool> logOut();

  @override
  FutureOr<Branch?> branch({required int serverId}) async {
    final repository = Repository();
    final query = Query(where: [Where('serverId').isExactly(serverId)]);
    final result = await repository.get<Branch>(
        query: query, policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    final branch = result.firstOrNull;

    return branch;
  }

  @override
  Future<void> saveBranch(Branch branch) async {
    await repository.upsert<Branch>(branch);
  }

  @override
  FutureOr<void> updateBranch(
      {required int branchId,
      String? name,
      bool? active,
      bool? isDefault}) async {
    Branch? branchs = await branch(serverId: branchId);
    if (branchs == null) {
      throw Exception('Branch not found');
    }
    branchs.active = active ?? branchs.active;
    branchs.isDefault = isDefault ?? branchs.isDefault;

    await saveBranch(branchs);
  }

  @override
  Future<List<Branch>> branches({
    int? businessId,
    bool? active = false,
  }) async {
    return await _getBranches(businessId);
  }

  Future<List<Branch>> _getBranches(int? businessId) async {
    final filters = <Where>[
      if (businessId != null) Where('businessId').isExactly(businessId),
    ];
    var query = Query(where: filters);

    try {
      // First get local branches
      final localBranches = await repository.get<Branch>(
        policy: OfflineFirstGetPolicy.localOnly,
        query: query,
      );

      // if (fetchOnline) {
      //   try {
      //     // Create a query to only fetch branches that aren't in our local cache
      //     final localBranchIds = localBranches.map((b) => b.serverId).toSet();
      //     for (var branchId in localBranchIds) {
      //       query = Query(where: [
      //         ...filters,
      //         Where('serverId').isNot(branchId),
      //       ]);
      //       // Fetch only the missing branches
      //       final onlineBranches = await repository
      //           .get<Branch>(
      //             policy: OfflineFirstGetPolicy.alwaysHydrate,
      //             query: query,
      //           )
      //           .timeout(
      //             const Duration(seconds: 3),
      //             onTimeout: () =>
      //                 throw TimeoutException('Remote fetch timed out'),
      //           );
      //       return [...localBranches, ...onlineBranches];
      //     }
      //   } on TimeoutException {
      //     talker.warning(
      //       'Branch remote fetch timed out after 3 seconds, falling back to local data',
      //     );
      //   }
      // }

      return localBranches;
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
      rethrow;
    }
  }

  @override
  void clearData({required ClearData data, required int identifier}) async {
    try {
      if (data == ClearData.Branch) {
        final List<Branch> branches = await repository.get<Branch>(
          query: Query(where: [Where('serverId').isExactly(identifier)]),
        );

        for (final branch in branches) {
          await repository.delete<Branch>(
            branch,
            policy: OfflineFirstDeletePolicy.optimisticLocal,
          );
        }
      }

      if (data == ClearData.Business) {
        final List<Business> businesses = await repository.get<Business>(
          query: Query(where: [Where('serverId').isExactly(identifier)]),
        );

        for (final business in businesses) {
          await repository.delete<Business>(business);
        }
      }
    } catch (e, s) {
      talker.error('Failed to clear data: $e');
      talker.error('Stack trace: $s');
    }
  }

  @override
  Future<List<Business>> businesses(
      {int? userId, bool fetchOnline = false, bool active = false}) async {
    return await repository.get<Business>(
      policy: fetchOnline
          ? OfflineFirstGetPolicy.alwaysHydrate
          : OfflineFirstGetPolicy.localOnly,
      query: Query(where: [
        if (userId != null) Where('userId').isExactly(userId),
        Where('active').isExactly(active)
      ]),
    );
  }

  @override
  Future<List<Category>> categories({required int branchId}) async {
    return repository.get<Category>(
      query: Query(where: [Where('branchId').isExactly(branchId)]),
    );
  }

  @override
  Stream<List<Category>> categoryStream() {
    final branchId = ProxyService.box.getBranchId()!;
    return repository.subscribe<Category>(
      query: Query(where: [Where('branchId').isExactly(branchId)]),
    );
  }

  @override
  Future<Branch> activeBranch() async {
    try {
      // Use a direct query to filter for the default branch at the database level
      // Query for branches where isDefault is either true or 1
      final branches = await repository.get<Branch>(
        policy: OfflineFirstGetPolicy.localOnly,
        query: Query(where: [Where('isDefault').isExactly(true)]),
      );

      // If we found a default branch, return it
      if (branches.isNotEmpty) {
        return branches.first;
      }

      if (branches.isEmpty) {
        throw Exception("No default branch found");
      }

      return branches.first;
    } catch (e) {
      await logOut();
      rethrow;
    }
  }

  @override
  Stream<Branch> activeBranchStream() {
    return repository
        .subscribe<Branch>(
      policy: OfflineFirstGetPolicy.localOnly,
    )
        .map((branches) {
      final branch = branches.firstWhere(
        (branch) => branch.isDefault == true || branch.isDefault == 1,
        orElse: () => throw Exception("No default branch found"),
      );
      return branch;
    });
  }
}
