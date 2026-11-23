import 'package:supabase_models/brick/models/work_order.model.dart';
import 'package:supabase_models/brick/models/actual_output.model.dart';
import 'package:flipper_models/services/purchase_approval_deps.dart';

import 'production_stock_poster.dart';

/// Service layer for the production output feature.
///
/// A thin write facade over Capella/Ditto. Reads are served reactively by
/// `workOrdersStreamProvider` / `actualOutputsStreamProvider` and the derived
/// providers in `../providers/production_output_derived_providers.dart`; this
/// class deliberately keeps no read logic of its own beyond [getWorkOrders],
/// which the forecasting service still needs as a one-shot.
class ProductionOutputService {
  /// [deps] and [postStock] default to the live app; tests pass fakes.
  ProductionOutputService({
    PurchaseApprovalDeps Function()? deps,
    Future<ProductionStockResult> Function({
      required WorkOrder workOrder,
      required double qty,
      required PurchaseApprovalDeps deps,
    })?
    postStock,
  }) : _deps = deps ?? PurchaseApprovalDeps.fromProxy,
       _postStock = postStock ?? _postProductionOutput;

  final PurchaseApprovalDeps Function() _deps;
  final Future<ProductionStockResult> Function({
    required WorkOrder workOrder,
    required double qty,
    required PurchaseApprovalDeps deps,
  })
  _postStock;

  static Future<ProductionStockResult> _postProductionOutput({
    required WorkOrder workOrder,
    required double qty,
    required PurchaseApprovalDeps deps,
  }) => postProductionOutput(workOrder: workOrder, qty: qty, deps: deps);

  /// One-shot work-order read. Prefer the stream providers in UI code.
  Future<List<WorkOrder>> getWorkOrders({
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    final deps = _deps();
    final bId = branchId ?? deps.branchId;
    if (bId == null) return [];

    final rows = await deps.strategy.getWorkOrders(
      branchId: bId,
      startDate: startDate,
      endDate: endDate,
      status: status,
    );
    return rows.cast<WorkOrder>().toList();
  }

  /// Create a new work order. Throws if Capella/Ditto is unavailable — the
  /// caller must surface that rather than leave the tap looking like a no-op.
  Future<WorkOrder?> createWorkOrder({
    required String variantId,
    String? variantName,
    required double plannedQuantity,
    required DateTime targetDate,
    String? shiftId,
    String? notes,
  }) async {
    final deps = _deps();
    final branchId = deps.branchId;
    final businessId = deps.businessId;

    if (branchId == null || businessId == null) return null;

    return await deps.strategy.createWorkOrder(
      branchId: branchId,
      businessId: businessId,
      variantId: variantId,
      variantName: variantName,
      plannedQuantity: plannedQuantity,
      targetDate: targetDate,
      shiftId: shiftId,
      notes: notes,
    );
  }

  /// Record actual output for a work order and add it to the finished
  /// product's stock (see [postProductionOutput]).
  ///
  /// Throws when the output can't be saved, or when it was saved but the
  /// stock could not be updated — see [createWorkOrder]. An RRA failure does
  /// not throw: it comes back as `rraMessage` for the caller to show.
  Future<({ActualOutput? output, String? rraMessage})> recordActualOutput({
    required WorkOrder workOrder,
    required double actualQuantity,
    String? varianceReason,
    String? notes,
  }) async {
    final deps = _deps();
    final branchId = deps.branchId;
    final userId = deps.userId;

    if (branchId == null || userId == null) {
      return (output: null, rraMessage: null);
    }

    final output = await deps.strategy.recordActualOutput(
      workOrderId: workOrder.id,
      branchId: branchId,
      actualQuantity: actualQuantity,
      userId: userId,
      varianceReason: varianceReason,
      notes: notes,
    );
    if (output == null) return (output: null, rraMessage: null);

    final stock = await _postStock(
      workOrder: workOrder,
      qty: actualQuantity,
      deps: deps,
    );
    return (output: output as ActualOutput, rraMessage: stock.rraMessage);
  }

  /// Update work order status. Throws on failure — see [createWorkOrder].
  Future<void> updateWorkOrderStatus({
    required String workOrderId,
    required String status,
  }) async {
    await _deps().strategy.updateWorkOrder(
      workOrderId: workOrderId,
      status: status,
    );
  }

  /// Start a planned work order (status `in_progress`). Starting moves no
  /// stock: finished goods are added when output is recorded. An order that
  /// is already started or finished is left alone.
  Future<void> startWorkOrder(WorkOrder workOrder) async {
    if (!canStartWorkOrder(workOrder)) return;
    await updateWorkOrderStatus(
      workOrderId: workOrder.id,
      status: 'in_progress',
    );
  }

  /// Complete a work order
  Future<void> completeWorkOrder(String workOrderId) async {
    await updateWorkOrderStatus(workOrderId: workOrderId, status: 'completed');
  }
}
