import 'package:flipper_models/sync/interfaces/branch_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaBranchMixin implements BranchInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<Branch?> branch({required int serverId}) async {
    throw UnimplementedError('branch needs to be implemented for Capella');
  }

  @override
  Future<List<Branch>> branches(
      {required int serverId,
      bool? includeSelf = false,
      required bool fetchOnline}) async {
    throw UnimplementedError('branches needs to be implemented for Capella');
  }

  @override
  void clearData({required ClearData data, required int identifier}) {
    throw UnimplementedError('clearData needs to be implemented for Capella');
  }

  @override
  Future<List<Business>> businesses(
      {required int userId, bool fetchOnline = false}) async {
    throw UnimplementedError('businesses needs to be implemented for Capella');
  }

  @override
  Future<List<Category>> categories({required int branchId}) async {
    throw UnimplementedError('categories needs to be implemented for Capella');
  }

  @override
  Stream<List<Category>> categoryStream() {
    throw UnimplementedError(
        'categoryStream needs to be implemented for Capella');
  }

  @override
  Future<Branch> activeBranch() async {
    throw UnimplementedError(
        'activeBranch needs to be implemented for Capella');
  }

  @override
  Stream<Branch> activeBranchStream() {
    throw UnimplementedError(
        'activeBranchStream needs to be implemented for Capella');
  }
}
