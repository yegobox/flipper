import 'dart:async';

import 'package:flipper_models/sync/interfaces/branch_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:supabase_models/brick/databasePath.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_models/services/sqlite_service.dart';
import 'package:path/path.dart' as path;
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
    try {
      // Get the database directory and construct the path using Repository.dbFileName
      final dbDir = await DatabasePath.getDatabaseDirectory();
      // Use the imported path package correctly
      final dbPath = path.join(dbDir, Repository.dbFileName);
      
      // Build the SQL update statement with only the fields that are provided
      final List<String> updateParts = [];
      final List<Object?> params = [];
      
      if (active != null) {
        updateParts.add('active = ?');
        params.add(active ? 1 : 0); // SQLite uses 1 for true, 0 for false
      }
      
      if (isDefault != null) {
        updateParts.add('is_default = ?');
        params.add(isDefault ? 1 : 0);
      }
      
      if (name != null) {
        updateParts.add('name = ?');
        params.add(name);
      }
      
      // Only proceed if we have fields to update
      if (updateParts.isNotEmpty) {
        // Add the branch ID to the params list
        params.add(branchId);
        
        final sql = 'UPDATE branch SET ${updateParts.join(', ')} WHERE server_id = ?';
        
        // Execute the raw SQL update
        final rowsAffected = SqliteService.execute(dbPath, sql, params);
        
        talker.debug('Updated branch $branchId: $rowsAffected rows affected');
      }
    } catch (e, stack) {
      talker.error('Error in updateBranch: $e');
      talker.error('Stack trace: $stack');
      rethrow;
    }
  }

  @override
  Future<List<Branch>> branches({
    int? serverId,
    bool? active,
    bool fetchOnline = false,
  }) async {
    return await _getBranches(serverId, active, fetchOnline);
  }

  Future<List<Branch>> _getBranches(
      int? serverId, bool? active, bool fetchOnline) async {
    final filters = <Where>[
      if (serverId != null) Where('businessId').isExactly(serverId),
      if (active != null) Where('active').isExactly(active),
    ];
    var query = Query(where: filters);

    try {
      // First get local branches
      final localBranches = await repository.get<Branch>(
        policy: OfflineFirstGetPolicy.localOnly,
        query: query,
      );

      if (fetchOnline) {
        try {
          // Create a query to only fetch branches that aren't in our local cache
          final localBranchIds = localBranches.map((b) => b.serverId).toSet();
          for (var branchId in localBranchIds) {
            query = Query(where: [
              ...filters,
              Where('serverId').isNot(branchId),
            ]);
            // Fetch only the missing branches
            final onlineBranches = await repository
                .get<Branch>(
                  policy: OfflineFirstGetPolicy.alwaysHydrate,
                  query: query,
                )
                .timeout(
                  const Duration(seconds: 3),
                  onTimeout: () =>
                      throw TimeoutException('Remote fetch timed out'),
                );
            return [...localBranches, ...onlineBranches];
          }
        } on TimeoutException {
          talker.warning(
            'Branch remote fetch timed out after 3 seconds, falling back to local data',
          );
        }
      }

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
      {int? userId, bool fetchOnline = false}) async {
    return await repository.get<Business>(
      policy: fetchOnline
          ? OfflineFirstGetPolicy.alwaysHydrate
          : OfflineFirstGetPolicy.localOnly,
      query:
          Query(where: [if (userId != null) Where('userId').isExactly(userId)]),
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
