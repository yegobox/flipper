import 'package:flipper_dashboard/features/import_purchase/ipm_purchase_line_defaults.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/capella/manual_purchase_ditto.dart';
import 'package:flipper_models/sync/utils/purchase_stock_rra.dart';
import 'package:flipper_services/proxy.dart';

/// What approving a manual purchase did to stock.
class ManualPurchaseStockInResult {
  const ManualPurchaseStockInResult({
    required this.stockedLines,
    required this.newProducts,
    this.rraMessage,
  });

  final int stockedLines;
  final int newProducts;

  /// Set when reporting to RRA (EBM) failed; the stock is updated anyway.
  final String? rraMessage;
}

/// How one waiting line is stocked in.
enum PurchaseLineStockAction {
  /// Add the quantity to the catalog variant the line was picked from.
  addToExisting,

  /// Create a product for the line, then add the quantity to it.
  createProduct,

  /// Already stocked in, declined, or nothing to add.
  skip,
}

/// Decides each line's action. Only waiting (`'01'`) lines move stock, so
/// approving twice never adds stock twice.
PurchaseLineStockAction planPurchaseLineStockIn(
  Variant line, {
  String? targetVariantId,
}) {
  if ((line.pchsSttsCd ?? '01') != '01') return PurchaseLineStockAction.skip;
  if ((line.qty ?? 0) <= 0) return PurchaseLineStockAction.skip;
  return targetVariantId != null && targetVariantId.isNotEmpty
      ? PurchaseLineStockAction.addToExisting
      : PurchaseLineStockAction.createProduct;
}

/// Adds [qty] to [variant]'s on-hand and returns the new on-hand.
///
/// The add is an atomic `currentStockMilli` COUNTER increment
/// (`appending: true`), not read-then-write: a sale rung up on another till
/// between the read and the write would otherwise be lost. Same pattern as
/// branch transfers (`applyDestinationStockDelta`), but for any quantity.
Future<({double onHand, String? stockId})> addPurchasedStock({
  required Variant variant,
  required double qty,
}) async {
  final capella = ProxyService.getStrategy(Strategy.capella);
  final now = DateTime.now().toUtc();
  final unitPrice = (variant.retailPrice ?? variant.supplyPrice ?? 0)
      .toDouble();
  final stockId = variant.stockId?.trim();
  final existing = stockId == null || stockId.isEmpty
      ? null
      : await capella.getStockById(id: stockId);

  if (existing != null) {
    final base = existing.currentStock ?? 0;
    await capella.updateStock(
      stockId: existing.id,
      currentStock: qty,
      appending: true,
      lastTouched: now,
      ebmSynced: false,
    );
    final after = await capella.getStockById(id: existing.id);
    final onHand = after?.currentStock ?? (base + qty);
    // Metadata only: leaves currentStock / rsdQty (and the counter) alone.
    await capella.updateStock(stockId: existing.id, value: onHand * unitPrice);
    return (onHand: onHand, stockId: existing.id);
  }

  final created = await capella.saveStock(
    variant: variant,
    id: '${variant.id}-stock',
    rsdQty: qty,
    currentStock: qty,
    value: qty * unitPrice,
    productId: variant.productId ?? '',
    variantId: variant.id,
    branchId: variant.branchId,
  );
  return (onHand: qty, stockId: created.id);
}

/// Stocks in an approved manual purchase:
/// * lines picked from the catalog add their quantity to that product;
/// * new items become a real product (item code, RRA registration, selling
///   price) and receive their quantity;
/// * each line is then a purchase record (`'03'`), hidden from the POS
///   catalog, pointing at the product that got the stock.
/// The stock-in is reported to RRA; a failure there is returned, not thrown.
Future<ManualPurchaseStockInResult> stockInManualPurchase(
  Purchase purchase,
) async {
  final capella = ProxyService.getStrategy(Strategy.capella);
  final targets = await ManualPurchaseDitto.catalogTargets(purchase.id);
  final reported = <PurchaseStockInLine>[];
  var created = 0;

  for (final line in purchase.variants ?? const <Variant>[]) {
    final targetId = targets[line.id];
    final action = planPurchaseLineStockIn(line, targetVariantId: targetId);
    if (action == PurchaseLineStockAction.skip) continue;
    final qty = (line.qty ?? 0).toDouble();

    Variant? target = action == PurchaseLineStockAction.addToExisting
        ? await capella.getVariant(id: targetId!)
        : null;
    if (target == null) {
      // A new item, or a catalog product deleted since the purchase was
      // saved: create the product from the line.
      final unitCost = (line.prc ?? line.supplyPrice ?? 0).toDouble();
      target = await createIpmCatalogVariant(
        name: (line.itemNm ?? line.name).trim(),
        supplyPrice: unitCost,
        retailPrice: (line.retailPrice ?? 0) > 0
            ? line.retailPrice!.toDouble()
            : unitCost,
      );
      created++;
    }

    final added = await addPurchasedStock(variant: target, qty: qty);
    await ManualPurchaseDitto.markLineStockedIn(
      line: line,
      targetVariantId: target.id,
    );
    talker.info(
      'Manual purchase ${purchase.id}: +$qty on ${target.id} '
      '(now ${added.onHand})',
    );
    reported.add(
      PurchaseStockInLine(
        variant: target,
        qty: qty,
        onHandAfter: added.onHand,
        stockId: added.stockId,
      ),
    );
  }

  await ManualPurchaseDitto.markPurchaseApproved(purchase);

  final rra = await reportPurchaseStockInToRra(
    branchId: purchase.branchId ?? ProxyService.box.getBranchId() ?? '',
    lines: reported,
    supplierName: purchase.spplrNm,
    supplierTin: purchase.spplrTin,
  );
  return ManualPurchaseStockInResult(
    stockedLines: reported.length,
    newProducts: created,
    rraMessage: rra.succeeded ? null : rra.message,
  );
}
