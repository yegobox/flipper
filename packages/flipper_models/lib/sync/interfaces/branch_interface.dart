import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';

abstract class BranchInterface {
  Future<bool> logOut();
  FutureOr<Branch?> branch({required int serverId});
  Future<List<Branch>> branches(
      {required int businessId, bool? includeSelf = false});
  void clearData({required ClearData data, required int identifier});
  Future<List<Business>> businesses({required int userId});
  Future<List<Category>> categories({required int branchId});
  Stream<List<Category>> categoryStream();
  Future<Branch> activeBranch();
  Stream<Branch> activeBranchStream();
}
