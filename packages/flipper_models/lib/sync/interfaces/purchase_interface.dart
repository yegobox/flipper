import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/domain/party/party_draft.dart';
import 'package:flipper_models/view_models/purchase_report_item.dart';

abstract class PurchaseInterface {
  Future<List<Variant>> selectImportItems({
    required int tin,
    required String bhfId,
  });

  Future<List<Purchase>> purchases();

  Future<List<Purchase>> selectPurchases({
    required String bhfId,
    required int tin,
    required String url,
  });

  Future<List<Variant>> allImportsToDate();
  Future<List<PurchaseReportItem>> allPurchasesToDate();

  /// Creates or updates a canonical supplier row plus accounting contact ext.
  Future<Supplier> upsertSupplierParty(PartyDraft draft);

  /// Persists a purchase recorded manually in-app (regTyCd 'M') so it flows
  /// through the same approval pipeline as RRA-fetched purchases.
  Future<Purchase> saveManualPurchase({
    required Purchase purchase,
    required String branchId,
    Supplier? supplier,
  });

  Future<void> saveVariant(
    Variant item,
    Business business,
    String branchId, {
    required bool skipRRaCall,
  });
  FutureOr<Purchase?> getPurchase({required String id});
}
