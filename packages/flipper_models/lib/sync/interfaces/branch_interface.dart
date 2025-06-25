import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';

abstract class BranchInterface {
  Future<bool> logOut();
  FutureOr<Branch?> branch({required int serverId});
  Future<List<Branch>> branches({int? serverId, bool? active});
  void clearData({required ClearData data, required int identifier});
  Future<List<Business>> businesses({required int userId, required bool active});
  Future<List<Category>> categories({required int branchId});
  Stream<List<Category>> categoryStream();
  Future<Branch> activeBranch();
  Stream<Branch> activeBranchStream();
  Future<void> saveBranch(Branch branch);
  FutureOr<void> updateBranch(
      {required int branchId, String? name, bool? active, bool? isDefault});
}
