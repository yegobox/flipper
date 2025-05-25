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
  Future<List<Branch>> branches({
    required int businessId,
    bool? includeSelf = false,
  }) async {
    return await _getBranches(businessId, includeSelf!);
  }

  Future<List<Branch>> _getBranches(int businessId, bool active) async {
    try {
      return await repository.get<Branch>(
        query: Query(where: [
          Where('businessId').isExactly(businessId),
          //if we are given active and is true then we return only
          if (active) Where('active').isExactly(active),
        ]),
      );
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
      {required int userId, bool fetchOnline = false}) async {
    return await repository.get<Business>(
      query: Query(where: [Where('userId').isExactly(userId)]),
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

      // If no branch with isDefault=true, try with isDefault=1
      final branchesWithNumericDefault = await repository.get<Branch>(
        policy: OfflineFirstGetPolicy.localOnly,
        query: Query(where: [Where('isDefault').isExactly(1)]),
      );

      if (branchesWithNumericDefault.isEmpty) {
        throw Exception("No default branch found");
      }

      return branchesWithNumericDefault.first;
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
