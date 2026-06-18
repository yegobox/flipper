import 'package:brick_offline_first/brick_offline_first.dart' as brick;
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/domain/party/party_draft.dart';
import 'package:flipper_models/sync/interfaces/purchase_interface.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Local hydration helpers for import/purchase date cursors.
/// RRA sync/approve uses data-connector HTTP; manual entry uses Ditto (Capella).
mixin PurchaseMixin implements PurchaseInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<Purchase> saveManualPurchase({
    required Purchase purchase,
    required String branchId,
    Supplier? supplier,
  }) {
    throw UnimplementedError(
      'Manual purchase requires Capella sync (Ditto)',
    );
  }

  @override
  Future<Supplier> upsertSupplierParty(PartyDraft draft) {
    throw UnimplementedError(
      'Supplier party upsert requires Capella sync (Ditto)',
    );
  }

  Future<void> hydrateDate({required String branchId}) async {
    await repository.get<ImportPurchaseDates>(
      policy: brick.OfflineFirstGetPolicy.alwaysHydrate,
      query: brick.Query(where: [brick.Where('branchId').isExactly(branchId)]),
    );
  }
}
