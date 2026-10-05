import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/imports_purchases_map.dart';
import 'package:flipper_models/sync/branch_catalog_cloud_sync.dart';
import 'package:flipper_models/sync/utils/stock_qty_milli.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:uuid/uuid.dart';

/// Ditto-only persistence for manually recorded purchases (`regTyCd: 'M'`).
/// No Brick/SQLite writes — mesh is the source of truth for manual entry.
abstract final class ManualPurchaseDitto {
  static DittoService get _dittoService => DittoService.instance;

  static dynamic _dittoOrThrow() {
    final ditto = _dittoService.dittoInstance;
    if (ditto == null) {
      throw Exception('Ditto not initialized');
    }
    return ditto;
  }

  static Future<void> _upsertPurchase(Purchase purchase) async {
    final ditto = _dittoOrThrow();
    final doc = await PurchaseDittoAdapter.instance.toDittoDocument(purchase);
    await ditto.store.execute(
      'INSERT INTO purchases DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
  }

  static Future<void> _upsertStock(Stock stock) async {
    final ditto = _dittoOrThrow();
    await ditto.store.execute(
      'INSERT INTO stocks DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': stock.toJson()},
    );
    await seedStockMilliIfAbsentOnStore(
      ditto.store,
      stockId: stock.id,
      qty: stock.currentStock ?? 0,
    );
  }

  /// [extra] carries Ditto-only fields the [Variant] model has no slot for
  /// (see [targetVariantIdField]).
  static Future<void> _upsertVariant(
    Variant variant, {
    Map<String, dynamic> extra = const {},
  }) async {
    final ditto = _dittoOrThrow();
    await ditto.store.execute(
      'INSERT INTO variants DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {
        'doc': {...variant.toFlipperJson(), ...extra},
      },
    );
  }

  /// On a purchase line variant: the catalog variant whose stock the line
  /// adds to. Set at save for lines picked from the catalog, and on approval
  /// for new items (the product created for them).
  static const String targetVariantIdField = 'targetVariantId';

  static Future<void> _upsertSupplier(Supplier supplier) async {
    final ditto = _dittoOrThrow();
    final doc = await SupplierDittoAdapter.instance.toDittoDocument(supplier);
    await ditto.store.execute(
      'INSERT INTO suppliers DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
  }

  /// Startup registers these too; screens opened first must not read an
  /// unsubscribed collection (the result would only hold this device's docs).
  static Future<void> _ensureSubscribed(dynamic ditto, String branchId) async {
    try {
      await ensurePurchaseCloudSubscriptions(
        ditto: ditto,
        branchId: branchId,
        businessId: ProxyService.box.getBusinessId(),
      );
    } catch (_) {
      // Reading local data still works; replication catches up later.
    }
  }

  static Future<bool> supplierExistsByName({
    required String custNm,
    required String branchId,
  }) async {
    final ditto = _dittoService.dittoInstance;
    if (ditto == null) return false;
    final result = await ditto.store.execute(
      'SELECT * FROM suppliers WHERE custNm = :custNm AND branchId = :branchId LIMIT 1',
      arguments: {'custNm': custNm, 'branchId': branchId},
    );
    return result.items.isNotEmpty;
  }

  /// Suppliers saved for [branchId]. They live in Ditto only (see
  /// [_upsertSupplier] and `upsertSupplierParty`), so reading them through
  /// Brick/SQLite finds nothing.
  static Future<List<Supplier>> listSuppliers(String branchId) async {
    final ditto = _dittoService.dittoInstance;
    if (ditto == null) return [];
    await _ensureSubscribed(ditto, branchId);
    final result = await ditto.store.execute(
      'SELECT * FROM suppliers WHERE branchId = :branchId',
      arguments: {'branchId': branchId},
    );
    final suppliers = <Supplier>[];
    for (final item in result.items) {
      final supplier = await SupplierDittoAdapter.instance.fromDittoDocument(
        Map<String, dynamic>.from(item.value),
      );
      if (supplier != null && (supplier.custNm ?? '').trim().isNotEmpty) {
        suppliers.add(supplier);
      }
    }
    return suppliers;
  }

  /// Supplier name, TIN and invoice number of every manual purchase on
  /// [branchId], used to suggest the next invoice number.
  static Future<List<({String name, String tin, int invoiceNo, bool recorded})>>
  invoiceHistory(String branchId) async {
    final ditto = _dittoService.dittoInstance;
    if (ditto == null) return [];
    await _ensureSubscribed(ditto, branchId);
    final result = await ditto.store.execute(
      'SELECT * FROM purchases '
      'WHERE branchId = :branchId AND regTyCd = :regTyCd',
      arguments: {'branchId': branchId, 'regTyCd': 'M'},
    );
    return [
      for (final item in result.items)
        if (num.tryParse('${item.value['spplrInvcNo']}') case final n?)
          (
            name: '${item.value['spplrNm'] ?? ''}',
            tin: '${item.value['spplrTin'] ?? ''}',
            invoiceNo: n.toInt(),
            recorded: true,
          ),
    ];
  }

  static Future<bool> invoiceExists({
    required String branchId,
    required String spplrTin,
    required int spplrInvcNo,
  }) async {
    final ditto = _dittoService.dittoInstance;
    if (ditto == null) return false;
    final result = await ditto.store.execute(
      'SELECT * FROM purchases WHERE branchId = :branchId '
      'AND spplrTin = :spplrTin AND spplrInvcNo = :spplrInvcNo LIMIT 1',
      arguments: {
        'branchId': branchId,
        'spplrTin': spplrTin,
        'spplrInvcNo': spplrInvcNo,
      },
    );
    return result.items.isNotEmpty;
  }

  /// Saves a manual purchase and its line variants to Ditto only.
  ///
  /// No stock moves here: a waiting purchase can still be declined. Approval
  /// adds each line to its catalog variant's stock. [catalogTargets] maps a
  /// line's `itemSeq` to the catalog variant it was picked from.
  static Future<Purchase> save({
    required Purchase purchase,
    required String branchId,
    Supplier? supplier,
    Map<int, String> catalogTargets = const {},
  }) async {
    final now = DateTime.now().toUtc();
    purchase.branchId = branchId;
    purchase.createdAt = now;
    purchase.hasUnApprovedVariant = true;

    if (supplier != null && (supplier.custNm?.isNotEmpty ?? false)) {
      final exists = await supplierExistsByName(
        custNm: supplier.custNm!,
        branchId: branchId,
      );
      if (!exists) {
        await _upsertSupplier(supplier);
      }
    }

    final lineVariants = <Variant>[];
    for (final variant in purchase.variants ?? <Variant>[]) {
      if (variant.itemNm?.isEmpty != false && variant.name.isEmpty) continue;

      final stock = variant.stock ?? Stock(branchId: branchId);
      stock.id = stock.id.isEmpty ? const Uuid().v4() : stock.id;
      stock.branchId = branchId;
      stock.currentStock = 0;
      stock.rsdQty = 0;
      stock.lastTouched = now;
      await _upsertStock(stock);

      variant.id = variant.id.isEmpty ? const Uuid().v4() : variant.id;
      variant.purchaseId = purchase.id;
      variant.branchId = branchId;
      variant.pchsSttsCd = '01';
      variant.stockId = stock.id;
      variant.stock = stock;
      variant.lastTouched = now;
      variant.itemNm ??= variant.name;
      variant.name = variant.itemNm ?? variant.name;
      final target = catalogTargets[variant.itemSeq];
      await _upsertVariant(
        variant,
        extra: {if (target != null) targetVariantIdField: target},
      );
      lineVariants.add(variant);
    }

    purchase.variants = lineVariants;
    await _upsertPurchase(purchase);
    return purchase;
  }

  static Future<List<Variant>> _variantsForPurchase(String purchaseId) async {
    final ditto = _dittoService.dittoInstance;
    if (ditto == null) return [];
    final result = await ditto.store.execute(
      'SELECT * FROM variants WHERE purchaseId = :purchaseId',
      arguments: {'purchaseId': purchaseId},
    );
    return result.items
        .map((e) => variantFromApiJson(Map<String, dynamic>.from(e.value)))
        .toList();
  }

  static Future<List<Purchase>> listForBranch(
    String branchId, {
    String? statusFilter,
  }) async {
    final ditto = _dittoService.dittoInstance;
    if (ditto == null) return [];

    final result = await ditto.store.execute(
      'SELECT * FROM purchases WHERE branchId = :branchId AND regTyCd = :regTyCd '
      'ORDER BY createdAt DESC',
      arguments: {'branchId': branchId, 'regTyCd': 'M'},
    );

    final purchases = <Purchase>[];
    for (final item in result.items) {
      final purchase = await PurchaseDittoAdapter.instance.fromDittoDocument(
        Map<String, dynamic>.from(item.value),
      );
      if (purchase == null) continue;

      final variants = await _variantsForPurchase(purchase.id);
      if (statusFilter != null && statusFilter != 'all') {
        final code = purchaseStatusApiParam(statusFilter);
        if (code != null &&
            !variants.any((v) => _matchesPurchaseStatus(v, statusFilter))) {
          continue;
        }
      }
      if (variants.isEmpty) continue;

      purchase.variants = variants;
      purchase.hasUnApprovedVariant = variants.any((v) => v.pchsSttsCd == '01');
      purchases.add(purchase);
    }
    return purchases;
  }

  static bool _matchesPurchaseStatus(Variant variant, String filterKey) {
    if (filterKey == 'all') return true;
    if (filterKey == 'approved') {
      return variant.pchsSttsCd == '02' || variant.pchsSttsCd == '03';
    }
    if (filterKey == 'pending') return variant.pchsSttsCd == '01';
    if (filterKey == 'rejected') return variant.pchsSttsCd == '04';
    return variant.pchsSttsCd == purchaseStatusApiParam(filterKey);
  }

  /// Line variant id → catalog variant id its stock goes to, for [purchaseId].
  static Future<Map<String, String>> catalogTargets(String purchaseId) async {
    final ditto = _dittoService.dittoInstance;
    if (ditto == null) return {};
    final result = await ditto.store.execute(
      'SELECT * FROM variants WHERE purchaseId = :purchaseId',
      arguments: {'purchaseId': purchaseId},
    );
    return {
      for (final item in result.items)
        if ('${item.value[targetVariantIdField] ?? ''}'.isNotEmpty)
          '${item.value['_id'] ?? item.value['id']}':
              '${item.value[targetVariantIdField]}',
    };
  }

  /// Marks a line as stocked in: its quantity now sits on [targetVariantId]'s
  /// stock, so the line itself is a purchase record (`'03'`, hidden from the
  /// POS catalog) and is never stocked in again.
  static Future<void> markLineStockedIn({
    required Variant line,
    required String targetVariantId,
  }) async {
    line.pchsSttsCd = '03';
    line.assigned = true;
    line.lastTouched = DateTime.now().toUtc();
    await _upsertVariant(line, extra: {targetVariantIdField: targetVariantId});
  }

  /// Purchase header after every line was stocked in.
  static Future<void> markPurchaseApproved(Purchase purchase) async {
    purchase.hasUnApprovedVariant = false;
    await _upsertPurchase(purchase);
  }

  /// Local approve/decline for manual purchases (not on data-connector).
  static Future<void> setPurchaseStatus({
    required Purchase purchase,
    required String pchsSttsCd,
  }) async {
    for (final variant in purchase.variants ?? <Variant>[]) {
      variant.pchsSttsCd = pchsSttsCd;
      variant.lastTouched = DateTime.now().toUtc();
      await _upsertVariant(variant);
    }
    purchase.hasUnApprovedVariant = pchsSttsCd == '01';
    await _upsertPurchase(purchase);
  }
}
