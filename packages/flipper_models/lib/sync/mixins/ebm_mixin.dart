import 'package:flipper_models/sync/interfaces/ebm_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

mixin EbmMixin implements EbmInterface {
  Repository get repository;

  @override
  Future<Ebm?> ebm({required int branchId, bool fetchRemote = false}) async {
    final query = Query(where: [Where('branchId').isExactly(branchId)]);
    final result = await repository.get<Ebm>(
      query: query,
      policy: fetchRemote
          ? OfflineFirstGetPolicy.alwaysHydrate
          : OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
    return result.firstOrNull;
  }

  @override
  Future<Product?> findProductByTenantId({required String tenantId}) async {
    final query = Query(where: [Where('bindedToTenantId').isExactly(tenantId)]);
    final result = await repository.get<Product>(query: query);
    return result.firstOrNull;
  }
}
