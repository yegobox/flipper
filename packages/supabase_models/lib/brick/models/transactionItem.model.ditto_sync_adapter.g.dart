// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactionItem.model.dart';

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************
//
// REQUIRED IMPORTS in parent file (transactionitem.model.dart):
// - import 'package:brick_core/query.dart';
// - import 'package:brick_offline_first/brick_offline_first.dart';
// - import 'package:flipper_services/proxy.dart';
// - import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
// - import 'package:supabase_models/sync/ditto_sync_adapter.dart';
// - import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
// - import 'package:supabase_models/sync/ditto_sync_generated.dart';
// - import 'package:supabase_models/brick/repository.dart';
// **************************************************************************
//
// Sync Direction: sendOnly
// This adapter sends data to Ditto but does NOT receive remote updates.
// **************************************************************************

class TransactionItemDittoAdapter extends DittoSyncAdapter<TransactionItem> {
  TransactionItemDittoAdapter._internal();

  static final TransactionItemDittoAdapter instance =
      TransactionItemDittoAdapter._internal();

  static int? Function()? _branchIdProviderOverride;
  static int? Function()? _businessIdProviderOverride;

  /// Allows tests to override how the current branch ID is resolved.
  void overrideBranchIdProvider(int? Function()? provider) {
    _branchIdProviderOverride = provider;
  }

  /// Allows tests to override how the current business ID is resolved.
  void overrideBusinessIdProvider(int? Function()? provider) {
    _businessIdProviderOverride = provider;
  }

  /// Clears any provider overrides (intended for tests).
  void resetOverrides() {
    _branchIdProviderOverride = null;
    _businessIdProviderOverride = null;
  }

  String get collectionName => "transaction_items";

  @override
  bool get supportsBackupPull => false;

  @override
  Future<DittoSyncQuery?> buildObserverQuery() async {
    // Send-only mode: no remote observation
    return null;
  }

  @override
  Future<String?> documentIdForModel(TransactionItem model) async => model.id;

  @override
  Future<Map<String, dynamic>> toDittoDocument(TransactionItem model) async {
    return {
      "id": model.id,
      "name": model.name,
      "quantityRequested": model.quantityRequested,
      "quantityApproved": model.quantityApproved,
      "quantityShipped": model.quantityShipped,
      "transactionId": model.transactionId,
      "variantId": model.variantId,
      "qty": model.qty,
      "price": model.price,
      "discount": model.discount,
      "remainingStock": model.remainingStock,
      "createdAt": model.createdAt?.toIso8601String(),
      "updatedAt": model.updatedAt?.toIso8601String(),
      "isRefunded": model.isRefunded,
      "doneWithTransaction": model.doneWithTransaction,
      "active": model.active,
      "dcRt": model.dcRt,
      "dcAmt": model.dcAmt,
      "taxblAmt": model.taxblAmt,
      "taxAmt": model.taxAmt,
      "totAmt": model.totAmt,
      "itemSeq": model.itemSeq,
      "isrccCd": model.isrccCd,
      "isrccNm": model.isrccNm,
      "isrcRt": model.isrcRt,
      "isrcAmt": model.isrcAmt,
      "taxTyCd": model.taxTyCd,
      "bcd": model.bcd,
      "itemClsCd": model.itemClsCd,
      "itemTyCd": model.itemTyCd,
      "itemStdNm": model.itemStdNm,
      "orgnNatCd": model.orgnNatCd,
      "pkg": model.pkg,
      "itemCd": model.itemCd,
      "pkgUnitCd": model.pkgUnitCd,
      "qtyUnitCd": model.qtyUnitCd,
      "itemNm": model.itemNm,
      "prc": model.prc,
      "splyAmt": model.splyAmt,
      "tin": model.tin,
      "bhfId": model.bhfId,
      "dftPrc": model.dftPrc,
      "addInfo": model.addInfo,
      "isrcAplcbYn": model.isrcAplcbYn,
      "useYn": model.useYn,
      "regrId": model.regrId,
      "regrNm": model.regrNm,
      "modrId": model.modrId,
      "modrNm": model.modrNm,
      "lastTouched": model.lastTouched?.toIso8601String(),
      "purchaseId": model.purchaseId,
      "taxPercentage": model.taxPercentage,
      "color": model.color,
      "sku": model.sku,
      "productId": model.productId,
      "unit": model.unit,
      "productName": model.productName,
      "categoryId": model.categoryId,
      "categoryName": model.categoryName,
      "taxName": model.taxName,
      "supplyPrice": model.supplyPrice,
      "retailPrice": model.retailPrice,
      "spplrItemNm": model.spplrItemNm,
      "totWt": model.totWt,
      "netWt": model.netWt,
      "spplrNm": model.spplrNm,
      "agntNm": model.agntNm,
      "invcFcurAmt": model.invcFcurAmt,
      "invcFcurCd": model.invcFcurCd,
      "invcFcurExcrt": model.invcFcurExcrt,
      "exptNatCd": model.exptNatCd,
      "dclNo": model.dclNo,
      "taskCd": model.taskCd,
      "dclDe": model.dclDe,
      "hsCd": model.hsCd,
      "imptItemSttsCd": model.imptItemSttsCd,
      "isShared": model.isShared,
      "assigned": model.assigned,
      "spplrItemClsCd": model.spplrItemClsCd,
      "spplrItemCd": model.spplrItemCd,
      "branchId": model.branchId,
      "ebmSynced": model.ebmSynced,
      "partOfComposite": model.partOfComposite,
      "compositePrice": model.compositePrice,
      "inventoryRequestId": model.inventoryRequestId,
      "ignoreForReport": model.ignoreForReport,
      "supplyPriceAtSale": model.supplyPriceAtSale,
      "ttCatCd": model.ttCatCd,
    };
  }

  @override
  Future<TransactionItem?> fromDittoDocument(
      Map<String, dynamic> document) async {
    final id = document["_id"] ?? document["id"];
    if (id == null) return null;

    // Branch filtering
    final currentBranch =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    final docBranch = document["branchId"];
    if (currentBranch != null && docBranch != currentBranch) {
      return null;
    }

    return TransactionItem(
      id: id,
      name: document["name"],
      quantityRequested: document["quantityRequested"],
      quantityApproved: document["quantityApproved"],
      quantityShipped: document["quantityShipped"],
      transactionId: document["transactionId"],
      variantId: document["variantId"],
      qty: document["qty"],
      price: document["price"],
      discount: document["discount"],
      remainingStock: document["remainingStock"],
      createdAt: DateTime.tryParse(document["createdAt"]?.toString() ?? ""),
      updatedAt: DateTime.tryParse(document["updatedAt"]?.toString() ?? ""),
      isRefunded: document["isRefunded"],
      doneWithTransaction: document["doneWithTransaction"],
      active: document["active"],
      dcRt: document["dcRt"],
      dcAmt: document["dcAmt"],
      taxblAmt: document["taxblAmt"],
      taxAmt: document["taxAmt"],
      totAmt: document["totAmt"],
      itemSeq: document["itemSeq"],
      isrccCd: document["isrccCd"],
      isrccNm: document["isrccNm"],
      isrcRt: document["isrcRt"],
      isrcAmt: document["isrcAmt"],
      taxTyCd: document["taxTyCd"],
      bcd: document["bcd"],
      itemClsCd: document["itemClsCd"],
      itemTyCd: document["itemTyCd"],
      itemStdNm: document["itemStdNm"],
      orgnNatCd: document["orgnNatCd"],
      pkg: document["pkg"],
      itemCd: document["itemCd"],
      pkgUnitCd: document["pkgUnitCd"],
      qtyUnitCd: document["qtyUnitCd"],
      itemNm: document["itemNm"],
      prc: document["prc"],
      splyAmt: document["splyAmt"],
      tin: document["tin"],
      bhfId: document["bhfId"],
      dftPrc: document["dftPrc"],
      addInfo: document["addInfo"],
      isrcAplcbYn: document["isrcAplcbYn"],
      useYn: document["useYn"],
      regrId: document["regrId"],
      regrNm: document["regrNm"],
      modrId: document["modrId"],
      modrNm: document["modrNm"],
      lastTouched: DateTime.tryParse(document["lastTouched"]?.toString() ?? ""),
      purchaseId: document["purchaseId"],
      stock: null, // Excluded from Ditto sync
      taxPercentage: document["taxPercentage"],
      color: document["color"],
      sku: document["sku"],
      productId: document["productId"],
      unit: document["unit"],
      productName: document["productName"],
      categoryId: document["categoryId"],
      categoryName: document["categoryName"],
      taxName: document["taxName"],
      supplyPrice: document["supplyPrice"],
      retailPrice: document["retailPrice"],
      spplrItemNm: document["spplrItemNm"],
      totWt: document["totWt"],
      netWt: document["netWt"],
      spplrNm: document["spplrNm"],
      agntNm: document["agntNm"],
      invcFcurAmt: document["invcFcurAmt"],
      invcFcurCd: document["invcFcurCd"],
      invcFcurExcrt: document["invcFcurExcrt"],
      exptNatCd: document["exptNatCd"],
      dclNo: document["dclNo"],
      taskCd: document["taskCd"],
      dclDe: document["dclDe"],
      hsCd: document["hsCd"],
      imptItemSttsCd: document["imptItemSttsCd"],
      isShared: document["isShared"],
      assigned: document["assigned"],
      spplrItemClsCd: document["spplrItemClsCd"],
      spplrItemCd: document["spplrItemCd"],
      branchId: document["branchId"],
      ebmSynced: document["ebmSynced"],
      partOfComposite: document["partOfComposite"],
      compositePrice: document["compositePrice"],
      inventoryRequestId: document["inventoryRequestId"],
      ignoreForReport: document["ignoreForReport"],
      supplyPriceAtSale: document["supplyPriceAtSale"],
      ttCatCd: document["ttCatCd"],
    );
  }

  @override
  Future<bool> shouldApplyRemote(Map<String, dynamic> document) async {
    final currentBranch =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    if (currentBranch == null) return true;
    final docBranch = document["branchId"];
    return docBranch == currentBranch;
  }

  static bool _seeded = false;

  static void _resetSeedFlag() {
    _seeded = false;
  }

  static Future<void> _seed(DittoSyncCoordinator coordinator) async {
    if (_seeded) {
      if (kDebugMode) {
        debugPrint(
            'Ditto seeding skipped for TransactionItem (already seeded)');
      }
      return;
    }

    try {
      Query? query;
      final branchId =
          _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
      if (branchId != null) {
        query = Query(where: [Where('branchId').isExactly(branchId)]);
      }

      final models = await Repository().get<TransactionItem>(
        query: query,
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      var seededCount = 0;
      for (final model in models) {
        await coordinator.notifyLocalUpsert<TransactionItem>(model);
        seededCount++;
      }
      if (kDebugMode) {
        debugPrint('Ditto seeded ' +
            seededCount.toString() +
            ' TransactionItem record' +
            (seededCount == 1 ? '' : 's'));
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto seeding failed for TransactionItem: $error\n$stack');
      }
    }

    _seeded = true;
  }

  static final int _$TransactionItemDittoAdapterRegistryToken =
      DittoSyncGeneratedRegistry.register((coordinator) async {
    await coordinator
        .registerAdapter<TransactionItem>(TransactionItemDittoAdapter.instance);
  }, seed: (coordinator) async {
    await _seed(coordinator);
  }, reset: _resetSeedFlag);

  /// Public accessor to ensure static initializer runs
  static int get registryToken => _$TransactionItemDittoAdapterRegistryToken;
}
