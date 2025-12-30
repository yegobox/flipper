import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/flipper_http_client.dart';

abstract class BranchInterface {
  Future<bool> logOut();
  FutureOr<Branch?> branch({String? serverId, String? name});
  Future<List<Branch>> branches({
    String? businessId,
    bool? active,
    String? excludeId,
  });
  FutureOr<Branch> addBranch({
    required String name,
    required String businessId,
    required String location,
    String? userOwnerPhoneNumber,
    required HttpClientInterface flipperHttpClient,
    int? serverId,
    String? description,
    num? longitude,
    num? latitude,
    required bool isDefault,
    required bool active,
    DateTime? lastTouched,
    DateTime? deletedAt,
    int? id,
  });
  void clearData({required ClearData data, required String identifier});
  Future<List<Business>> businesses(
      {required String userId, required bool active});
  Future<List<Category>> categories({required String branchId});
  Stream<List<Category>> categoryStream({String? branchId});
  Future<Branch> activeBranch();
  Stream<Branch> activeBranchStream({required String businessId});
  Future<void> saveBranch(Branch branch);
  FutureOr<void> updateBranch(
      {required String branchId, String? name, bool? active, bool? isDefault});
}
