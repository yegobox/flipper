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

  /// Set on a legacy line once the repair has handled it (see
  /// [legacyLinesOnStore]). Later runs re-check these lines' stock, which is
  /// what corrects a move two offline devices both made.
  static const String legacyRepairedField = 'legacyRepaired';

  /// The legacy-line DQL, public so a real-store test runs these exact
  /// strings (see `manual_purchase_legacy_ditto_test.dart`).
  static const manualPurchaseIdsDql =
      'SELECT * FROM purchases WHERE branchId = :branchId AND regTyCd = :regTyCd';
  // Bound as a bare array: `IN (:ids)` silently matches nothing in DQL.
  static const legacyLinesDql =
      'SELECT * FROM variants WHERE purchaseId IN :ids AND pchsSttsCd = :approved';
  static const repairedLegacyLinesDql =
      'SELECT * FROM variants WHERE purchaseId IN :ids '
      'AND $legacyRepairedField = :repaired';
  static const retireLegacyLineDql =
      'UPDATE variants SET pchsSttsCd = :record, lastTouched = :now, '
      '$legacyRepairedField = :repaired WHERE _id = :id';
  static const mergeLegacyLineDql =
      'UPDATE variants SET pchsSttsCd = :record, lastTouched = :now, '
      '$legacyRepairedField = :repaired, $targetVariantIdField = :target '
      'WHERE _id = :id';

  static bool get isReady => _dittoService.dittoInstance != null;

  /// Manual purchase lines approved before stock-in existed (#710): those
  /// builds set every line to `'02'` and gave it its own stock, so the line
  /// sells as a product of its own. RRA purchase lines also use `'02'`, so
  /// only lines of `regTyCd 'M'` purchases count. Lines the repair already
  /// handled come back too, flagged [LegacyPurchaseLine.repaired].
  static Future<List<LegacyPurchaseLine>> legacyLines(String branchId) =>
      legacyLinesOnStore(_dittoOrThrow().store, branchId);

  static Future<List<LegacyPurchaseLine>> legacyLinesOnStore(
    dynamic store,
    String branchId,
  ) async {
    final purchases = await store.execute(
      manualPurchaseIdsDql,
      arguments: {'branchId': branchId, 'regTyCd': 'M'},
    );
    final ids = [
      for (final item in purchases.items)
        '${item.value['_id'] ?? item.value['id'] ?? ''}',
    ].where((id) => id.isNotEmpty).toList();
    if (ids.isEmpty) return [];

    // Two queries rather than an OR: a line without the flag must not depend
    // on how DQL folds a missing field into a boolean.
    final approved = await store.execute(
      legacyLinesDql,
      arguments: {'ids': ids, 'approved': '02'},
    );
    final repaired = await store.execute(
      repairedLegacyLinesDql,
      arguments: {'ids': ids, 'repaired': true},
    );
    final byId = <String, LegacyPurchaseLine>{};
    for (final (result, wasRepaired) in [(approved, false), (repaired, true)]) {
      for (final item in result.items) {
        final raw = Map<String, dynamic>.from(item.value);
        final line = variantFromApiJson(raw);
        final target = '${raw[targetVariantIdField] ?? ''}';
        byId[line.id] = LegacyPurchaseLine(
          line: line,
          repaired: wasRepaired,
          targetVariantId: target.isEmpty ? null : target,
        );
      }
    }
    return byId.values.toList();
  }

  /// On-hand of [stockId] (the COUNTER when it has one), or null when there
  /// is no such stock row.
  static Future<double?> stockOnHand(String stockId) =>
      stockOnHandOnStore(_dittoOrThrow().store, stockId);

  static Future<double?> stockOnHandOnStore(
    dynamic store,
    String stockId,
  ) async {
    final result = await store.execute(
      stockSelectWithMilliDql(
        whereClause: '_id = :stockId OR id = :stockId LIMIT 1',
      ),
      arguments: {'stockId': stockId},
    );
    if (result.items.isEmpty) return null;
    final data = Map<String, dynamic>.from(result.items.first.value);
    final milli = parseStockMilli(data[stockCurrentStockMilliField]);
    if (milli != null) return fromMilli(milli);
    final register = data['currentStock'];
    return register is num ? register.toDouble() : 0;
  }

  /// Hides a legacy line that had no stock to move: a purchase record
  /// (`'03'`). A field-level UPDATE, not an upsert: the line has been selling
  /// as a product, and re-writing it from the parsed model would null every
  /// field the purchase mapper does not read.
  static Future<void> retireLegacyLine(String lineId) =>
      retireLegacyLineOnStore(_dittoOrThrow().store, lineId);

  static Future<void> retireLegacyLineOnStore(
    dynamic store,
    String lineId,
  ) async {
    await store.execute(
      retireLegacyLineDql,
      arguments: {
        'record': '03',
        'now': DateTime.now().toUtc().toIso8601String(),
        'repaired': true,
        'id': lineId,
      },
    );
  }

  /// Moves [qty] from a legacy line's stock to its catalog product's and
  /// marks the line a purchase record pointing at [targetVariantId], with both
  /// stock registers rewritten, in one local transaction: no crash can leave
  /// the stock counted twice or lost.
  ///
  /// Both sides are COUNTER increments, which add up across devices. Two
  /// offline devices moving the same line therefore leave it negative by the
  /// extra amount, and the next run moves that back ([qty] may be negative).
  static Future<void> moveLegacyLineStock({
    required String lineId,
    required String lineStockId,
    required String targetVariantId,
    required String targetStockId,
    required double qty,
  }) => moveLegacyLineStockOnStore(
    _dittoOrThrow().store,
    lineId: lineId,
    lineStockId: lineStockId,
    targetVariantId: targetVariantId,
    targetStockId: targetStockId,
    qty: qty,
  );

  static Future<void> moveLegacyLineStockOnStore(
    dynamic store, {
    required String lineId,
    required String lineStockId,
    required String targetVariantId,
    required String targetStockId,
    required double qty,
  }) async {
    for (final stockId in [lineStockId, targetStockId]) {
      if (await stockOnHandOnStore(store, stockId) == null) {
        throw StateError('Stock $stockId not found');
      }
      // Stocks written by old builds hold only the register: seed the
      // counter from it, or the increment below would start from zero.
      await seedStockMilliIfAbsentOnStore(store, stockId: stockId, qty: 0);
    }
    final delta = toMilli(qty);
    await store.transaction((txn) async {
      await txn.execute(
        stockIncrementMilliDql(),
        arguments: {'delta': -delta, 'stockId': lineStockId},
      );
      await txn.execute(
        stockIncrementMilliDql(),
        arguments: {'delta': delta, 'stockId': targetStockId},
      );
      await txn.execute(
        mergeLegacyLineDql,
        arguments: {
          'record': '03',
          'now': DateTime.now().toUtc().toIso8601String(),
          'repaired': true,
          'target': targetVariantId,
          'id': lineId,
        },
      );
      // Older builds read the register, not the counter. Written in the same
      // transaction (which reads its own increments): a repaired line whose
      // counter is settled is never moved again, so a register write that
      // failed after the commit would stay stale.
      for (final stockId in [lineStockId, targetStockId]) {
        final onHand = await stockOnHandOnStore(txn, stockId) ?? 0;
        await txn.execute(
          stockDualWriteRegistersDql(),
          arguments: {
            'currentStock': onHand,
            'rsdQty': onHand,
            'stockId': stockId,
          },
        );
      }
    });
  }

  /// Every variant on [branchId], for matching a purchase line to the
  /// catalog product it was bought for.
  static Future<List<Variant>> branchVariants(String branchId) async {
    final ditto = _dittoService.dittoInstance;
    if (ditto == null) return [];
    final result = await ditto.store.execute(
      'SELECT * FROM variants WHERE branchId = :branchId',
      arguments: {'branchId': branchId},
    );
    return result.items
        .map((e) => variantFromApiJson(Map<String, dynamic>.from(e.value)))
        .toList();
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

/// A manual purchase line found by [ManualPurchaseDitto.legacyLines].
class LegacyPurchaseLine {
  const LegacyPurchaseLine({
    required this.line,
    required this.repaired,
    this.targetVariantId,
  });

  final Variant line;

  /// Already handled by an earlier repair run (now a `'03'` record).
  final bool repaired;

  /// The catalog variant an earlier run moved this line's stock to.
  final String? targetVariantId;
}
