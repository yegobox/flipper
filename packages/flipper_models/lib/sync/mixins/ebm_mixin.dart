import 'package:flipper_models/sync/interfaces/ebm_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/databasePath.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/services/sqlite_service.dart';
import 'package:path/path.dart' as path;

mixin EbmMixin implements EbmInterface {
  Repository get repository;

  @override
  Future<void> saveEbm({
    required int branchId,
    required String severUrl,
    required String bhFId,
  }) async {
    final business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);

    if (business == null) {
      throw Exception("Business not found");
    }

    final query = Query(where: [
      Where('branchId').isExactly(branchId),
      Where('bhfId').isExactly(bhFId),
    ]);

    final ebm = await repository.get<Ebm>(
      query: query,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );

    final existingEbm = ebm.firstOrNull;

    final updatedEbm = existingEbm ??
        Ebm(
          bhfId: bhFId,
          tinNumber: business.tinNumber!,
          dvcSrlNo: business.dvcSrlNo ?? "vsdcyegoboxltd",
          userId: ProxyService.box.getUserId()!,
          taxServerUrl: severUrl,
          businessId: business.serverId,
          branchId: branchId,
        );

    if (existingEbm != null) {
      updatedEbm.taxServerUrl = severUrl;
    }

    await repository.upsert(updatedEbm);
  }

  @override
  Future<Ebm?> ebm({required int branchId, bool fetchRemote = false}) async {
    final query = Query(where: [Where('branchId').isExactly(branchId)]);
    var result = await repository.get<Ebm>(
      query: query,
      policy: fetchRemote
          ? OfflineFirstGetPolicy.alwaysHydrate
          : OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
    // If more than one result, delete all and re-fetch (ensure only one config)
    if (result.length > 1) {
      final dbDir = await DatabasePath.getDatabaseDirectory();
      final dbPath = path.join(dbDir, 'flipper_v17.sqlite');

      // Construct delete query: only delete where branchId matches
      final deleteSql = 'DELETE FROM Ebm WHERE branch_id = ?';
      SqliteService.execute(dbPath, deleteSql, [branchId]);
      // Re-fetch after cleanup
      result = await repository.get<Ebm>(
        query: query,
        policy: fetchRemote
            ? OfflineFirstGetPolicy.alwaysHydrate
            : OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      );
    }
    final ebm = result.firstOrNull;
    // Save EBM to local storage if fetched from remote and exists
    if (fetchRemote && ebm != null) {
      try {
        // Save the relevant EBM fields to local storage as done in proforma_url_form.dart
        ProxyService.box.writeString(
          key: "getServerUrl",
          value: ebm.taxServerUrl,
        );
        ProxyService.box.writeString(
          key: "bhfId",
          value: ebm.bhfId,
        );
      } catch (e) {
        // Handle storage errors gracefully
      }
    }
    return ebm;
  }

  @override
  Future<Product?> findProductByTenantId({required String tenantId}) async {
    final query = Query(where: [Where('bindedToTenantId').isExactly(tenantId)]);
    final result = await repository.get<Product>(query: query);
    return result.firstOrNull;
  }
}
