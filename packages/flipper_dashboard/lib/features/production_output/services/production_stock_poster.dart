import 'package:flipper_dashboard/manual_purchase/manual_purchase_stock_in.dart';
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
/// Only plain goods move. A composite product is a sale-time kit: selling it
/// puts its components on the receipt and deducts *their* stock, while the
/// product's own stock never moves. Stocking it here, or deducting its
/// components, would count the same goods twice. Services hold no stock.
///
/// Raw materials are not consumed here: Flipper has no manufacturing recipe
/// yet, and composites are not one.
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
  if (productId != null && productId.isNotEmpty) {
    final product = await capella.getProduct(
      id: productId,
      branchId: workOrder.branchId,
      businessId: workOrder.businessId,
    );
    if (product?.isComposite == true) return ProductionStockResult.skipped;
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
    remark: 'Production output: ${workOrder.variantName ?? variant.name}',
    deps: deps,
    // This function's own test seams, passed through.
    // ignore: invalid_use_of_visible_for_testing_member
    resolveEbm: resolveEbm,
    // ignore: invalid_use_of_visible_for_testing_member
    nextBranchSar: nextBranchSar,
  );

  return ProductionStockResult(
    stocked: true,
    rraMessage: rra.succeeded ? null : rra.message,
  );
}

/// Whether [workOrder] may move to `in_progress`. Only a planned order
/// starts, so a second tap or a second till is a no-op.
bool canStartWorkOrder(WorkOrder workOrder) => workOrder.status == 'planned';
