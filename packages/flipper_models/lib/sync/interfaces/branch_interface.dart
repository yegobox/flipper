import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/flipper_http_client.dart';

abstract class BranchInterface {
  Future<bool> logOut();
  FutureOr<Branch?> branch({ int? serverId, String? name});
  Future<List<Branch>> branches({
    int? businessId,
    bool? active,
    int? excludeId,
  });
  FutureOr<Branch> addBranch({
    required String name,
    required int businessId,
    required String location,
    String? userOwnerPhoneNumber,
    required HttpClientInterface flipperHttpClient,
    int? serverId,
    String? description,
    String? longitude,
    String? latitude,
    required bool isDefault,
    required bool active,
    DateTime? lastTouched,
    DateTime? deletedAt,
    int? id,
  });
  void clearData({required ClearData data, required int identifier});
  Future<List<Business>> businesses(
      {required int userId, required bool active});
  Future<List<Category>> categories({required int branchId});
  Stream<List<Category>> categoryStream();
  Future<Branch> activeBranch();
  Stream<Branch> activeBranchStream();
  Future<void> saveBranch(Branch branch);
  FutureOr<void> updateBranch(
      {required int branchId, String? name, bool? active, bool? isDefault});
}
