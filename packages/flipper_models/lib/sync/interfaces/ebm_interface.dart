import 'package:flipper_models/realm_model_export.dart';

abstract class EbmInterface {
  Future<Ebm?> ebm({required int branchId, bool fetchRemote = false});
  Future<Product?> findProductByTenantId({required String tenantId});
}
