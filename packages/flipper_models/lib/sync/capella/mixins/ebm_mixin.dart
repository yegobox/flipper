import 'package:flipper_models/sync/interfaces/ebm_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaEbmMixin implements EbmInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<Ebm?> ebm({required int branchId, bool fetchRemote = false}) async {
    throw UnimplementedError('ebm needs to be implemented for Capella');
  }

  @override
  Future<Product?> findProductByTenantId({required String tenantId}) async {
    throw UnimplementedError(
        'findProductByTenantId needs to be implemented for Capella');
  }

  @override
  Future<void> saveEbm({
    required int branchId,
    required String severUrl,
    required String bhFId,
    bool vatEnabled = false,
  }) async {
    throw UnimplementedError('saveEbm needs to be implemented for Capella');
  }
}
