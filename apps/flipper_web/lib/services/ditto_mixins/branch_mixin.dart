import 'package:flipper_web/models/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'ditto_core_mixin.dart';

mixin BranchMixin on DittoCore {
  /// Save a branch to the branches collection
  Future<void> saveBranch(Branch branch) async {
    if (dittoInstance == null) return _handleNotInitialized('saveBranch');
    final docId = branch.id;
    await _executeUpsert('branches', docId, branch.toJson());
    debugPrint('Saved branch with ID: ${branch.id}');
  }

  /// Update a branch in the branches collection
  Future<void> updateBranch(Branch branch) async {
    if (dittoInstance == null) return _handleNotInitialized('updateBranch');
    final docId = branch.id;
    await _executeUpdate('branches', docId, branch.toJson());
    debugPrint('Successfully updated branch with ID: ${branch.id}');
  }

  /// Get branches for a specific business
  Future<List<Branch>> getBranchesForBusiness(String serverId) async {
    debugPrint('🔍 Querying branches for serverId : $serverId');
    if (dittoInstance == null) {
      return _handleNotInitializedAndReturn('getBranchesForBusiness', []);
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

  /// Helper method to handle not initialized case
  void _handleNotInitialized(String methodName) {
    debugPrint('Ditto not initialized, cannot $methodName');
  }

  /// Helper method to handle not initialized case and return a value
  T _handleNotInitializedAndReturn<T>(String methodName, T defaultValue) {
    debugPrint('Ditto not initialized, cannot $methodName');
    return defaultValue;
  }

  /// Helper method to execute upsert operation
  Future<void> _executeUpsert(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    await dittoInstance!.store.execute(
      "INSERT INTO $collection DOCUMENTS (:data) ON ID CONFLICT DO UPDATE",
      arguments: {
        "data": {"_id": docId, ...data},
      },
    );
  }

  /// Helper method to execute update operation
  Future<void> _executeUpdate(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    final fields = data.keys.map((key) => '$key = :$key').join(', ');
    await dittoInstance!.store.execute(
      "UPDATE $collection SET $fields WHERE _id = :id",
      arguments: {"id": docId, ...data},
    );
  }
}
