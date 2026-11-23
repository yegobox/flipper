import 'dart:math' as math;

import 'package:flipper_dashboard/manual_purchase/manual_purchase_stock_in.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/services/purchase_approval_deps.dart';
import 'package:flipper_models/sync/utils/purchase_stock_rra.dart';
import 'package:flipper_services/constants.dart';
import 'package:meta/meta.dart';
import 'package:supabase_models/brick/models/sars.model.dart';
import 'package:supabase_models/brick/models/work_order.model.dart';

/// What recording production output did to stock.
class ProductionStockResult {
  const ProductionStockResult({required this.stocked, this.rraMessage});

  /// Nothing moved: a composite or service product, or no quantity.
  static const skipped = ProductionStockResult(stocked: false);

  /// True when the finished goods were added to stock.
  final bool stocked;

  /// Set when reporting to RRA (EBM) failed; the stock is updated anyway.
  final String? rraMessage;
}

/// Adds recorded production output to the finished product's stock and
/// reports it to RRA as incoming processing (`05`).
///
/// A combo made in production (composite, a finished product: itemTyCd 2)
/// also uses up its components: [Composite.qty] of each per unit made, taken
/// from their stock and reported as outgoing processing (`14`). Selling it
/// later takes from its own stock.
///
/// A combo sold as made (a service) moves nothing here: selling it takes its
/// components' stock (`expandComboLinesForStock`). Services hold no stock.
/// A plain product has no recipe in Flipper, so nothing is used up.
///
/// Throws when the product can't be found, so the caller can tell the user
/// the output was saved but stock was not. An RRA failure never throws; it
/// comes back as [ProductionStockResult.rraMessage].
Future<ProductionStockResult> postProductionOutput({
  required WorkOrder workOrder,
  required double qty,
  required PurchaseApprovalDeps deps,
  @visibleForTesting Future<Ebm?> Function(String businessId)? resolveEbm,
  @visibleForTesting Future<Sar> Function(String branchId)? nextBranchSar,
}) async {
  if (qty <= 0) return ProductionStockResult.skipped;

  final capella = deps.capella;
  final variant = await capella.getVariant(id: workOrder.variantId);
  if (variant == null) {
    throw StateError(
      'Produced variant ${workOrder.variantId} not found; stock not updated',
    );
  }
  if (variant.itemTyCd == '3') return ProductionStockResult.skipped;

  final productId = variant.productId;
  var components = const <Composite>[];
  if (productId != null && productId.isNotEmpty) {
    final product = await capella.getProduct(
      id: productId,
      branchId: workOrder.branchId,
      businessId: workOrder.businessId,
    );
    if (product?.isComposite == true) {
      components = await capella.composites(productId: productId);
    }
  }
  final productName = workOrder.variantName ?? variant.name;

  String? rraMessage;
  final used = await _useUpComponents(components, qty: qty, capella: capella);
  if (used.isNotEmpty) {
    final usedRra = await reportPurchaseStockInToRra(
      branchId: workOrder.branchId,
      businessId: workOrder.businessId,
      lines: used,
      supplierName: 'Production',
      sarTyCd: StockInOutType.processingOut,
      isStockIn: false,
      remark: 'Used in production: $productName',
      deps: deps,
      // This function's own test seams, passed through.
      // ignore: invalid_use_of_visible_for_testing_member
      resolveEbm: resolveEbm,
      // ignore: invalid_use_of_visible_for_testing_member
      nextBranchSar: nextBranchSar,
    );
    if (!usedRra.succeeded) rraMessage = usedRra.message;
  }

  final added = await addPurchasedStock(
    variant: variant,
    qty: qty,
    capella: capella,
  );

  final rra = await reportPurchaseStockInToRra(
    branchId: workOrder.branchId,
    businessId: workOrder.businessId,
    lines: [
      PurchaseStockInLine(
        variant: variant,
        qty: qty,
        onHandAfter: added.onHand,
        stockId: added.stockId,
      ),
    ],
    supplierName: 'Production',
    sarTyCd: StockInOutType.processingIn,
    remark: 'Production output: $productName',
    deps: deps,
    // This function's own test seams, passed through.
    // ignore: invalid_use_of_visible_for_testing_member
    resolveEbm: resolveEbm,
    // ignore: invalid_use_of_visible_for_testing_member
    nextBranchSar: nextBranchSar,
  );
  if (!rra.succeeded) rraMessage ??= rra.message;

  return ProductionStockResult(stocked: true, rraMessage: rraMessage);
}

/// Takes [qty] units' worth of each component out of stock in one counter
/// decrement per stock (concurrent sales on other tills merge), and returns
/// what was used with each component's on-hand afterwards, for RRA.
/// Services and components with no stock record are skipped.
Future<List<PurchaseStockInLine>> _useUpComponents(
  List<Composite> components, {
  required double qty,
  required DatabaseSyncInterface capella,
}) async {
  if (components.isEmpty) return const [];
  final ids = components
      .map((c) => c.variantId)
      .whereType<String>()
      .where((id) => id.isNotEmpty)
      .toSet()
      .toList();
  if (ids.isEmpty) return const [];
  final variants = await capella.batchGetVariantsByIds(ids);

  final usedByStock = <String, double>{};
  final variantByStock = <String, Variant>{};
  for (final component in components) {
    final v = variants[component.variantId];
    final stockId = v?.stockId;
    if (v == null || v.itemTyCd == '3' || stockId == null || stockId.isEmpty) {
      continue;
    }
    final perUnit = (component.qty ?? 0) > 0 ? component.qty! : 1.0;
    usedByStock[stockId] = (usedByStock[stockId] ?? 0) + perUnit * qty;
    variantByStock[stockId] = v;
  }
  if (usedByStock.isEmpty) return const [];

  await capella.batchDeductStocks(usedByStock);
  final after = await capella.batchGetStocksByIds(usedByStock.keys.toList());
  return [
    for (final entry in usedByStock.entries)
      PurchaseStockInLine(
        variant: variantByStock[entry.key]!,
        qty: entry.value,
        onHandAfter: math.max(0, after[entry.key]?.currentStock ?? 0),
        stockId: entry.key,
      ),
  ];
}

/// Whether [workOrder] may move to `in_progress`. Only a planned order
/// starts, so a second tap or a second till is a no-op.
bool canStartWorkOrder(WorkOrder workOrder) => workOrder.status == 'planned';
