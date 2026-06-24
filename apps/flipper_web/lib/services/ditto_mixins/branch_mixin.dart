import 'package:flipper_web/models/user_profile.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'ditto_core_mixin.dart';

mixin BranchMixin on DittoCore {
  /// Save a branch to the branches collection
  Future<void> saveBranch(Branch branch) async {
    if (dittoInstance == null) return handleNotInitialized('saveBranch');
    final docId = branch.id;
    await executeUpsert('branches', docId, branch.toJson());
    debugPrint('Saved branch with ID: ${branch.id}');
  }

  /// Update a branch in the branches collection
  Future<void> updateBranch(Branch branch) async {
    if (dittoInstance == null) return handleNotInitialized('updateBranch');
    final docId = branch.id;
    await executeUpdate('branches', docId, branch.toJson());
    debugPrint('Successfully updated branch with ID: ${branch.id}');
  }

  /// Get branches for a specific business
  Future<List<Branch>> getBranchesForBusiness(String serverId) async {
    debugPrint('🔍 Querying branches for serverId : $serverId');
    if (dittoInstance == null) {
      return handleNotInitializedAndReturn('getBranchesForBusiness', []);
    }
    final businessIdInt = int.tryParse(serverId);
    if (businessIdInt == null) {
      debugPrint('❌ Invalid serverId format: $serverId');
      return [];
    }
    final result = await dittoInstance!.store.execute(
      "SELECT * FROM branches WHERE businessId = :businessId",
      arguments: {"businessId": businessIdInt},
    );
    return result.items
        .map((doc) => Branch.fromJson(Map<String, dynamic>.from(doc.value)))
        .toList();
  }
}
