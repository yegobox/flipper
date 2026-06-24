import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/imports_purchases_map.dart';
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
  }

  static Future<void> _upsertVariant(Variant variant) async {
    final ditto = _dittoOrThrow();
    await ditto.store.execute(
      'INSERT INTO variants DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': variant.toFlipperJson()},
    );
  }

  static Future<void> _upsertSupplier(Supplier supplier) async {
    final ditto = _dittoOrThrow();
    final doc = await SupplierDittoAdapter.instance.toDittoDocument(supplier);
    await ditto.store.execute(
      'INSERT INTO suppliers DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
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
  static Future<Purchase> save({
    required Purchase purchase,
    required String branchId,
    Supplier? supplier,
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
      await _upsertVariant(variant);
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
