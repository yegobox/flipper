import 'package:flipper_models/db_model_export.dart';

abstract class EbmInterface {
  Future<Ebm?> ebm({required String branchId, bool fetchRemote = true});
  Future<Product?> findProductByTenantId({required String tenantId});
  Future<bool> saveEbm({
    required String branchId,
    required String severUrl,
    required String bhFId,
    bool vatEnabled = false,
    required String mrc,
    String? dataConnectorUrl,
  });
}
