import 'package:supabase_models/brick/models/work_order.model.dart';
import 'package:supabase_models/brick/models/actual_output.model.dart';
import 'package:flipper_accounting/production_journal_poster.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/services/purchase_approval_deps.dart';
import 'package:flipper_web/services/ditto_service.dart';

import 'production_stock_poster.dart';

/// Service layer for the production output feature.
///
/// A thin write facade over Capella/Ditto. Reads are served reactively by
/// `workOrdersStreamProvider` / `actualOutputsStreamProvider` and the derived
/// providers in `../providers/production_output_derived_providers.dart`; this
/// class deliberately keeps no read logic of its own beyond [getWorkOrders],
/// which the forecasting service still needs as a one-shot.
class ProductionOutputService {
  /// [deps], [postStock] and [postToBooks] default to the live app; tests
  /// pass fakes.
  ProductionOutputService({
    PurchaseApprovalDeps Function()? deps,
    Future<void> Function(String businessId, ProductionOutputRecord record)?
    postToBooks,
    Future<ProductionStockResult> Function({
      required WorkOrder workOrder,
      required double qty,
      required PurchaseApprovalDeps deps,
    })?
    postStock,
  }) : _deps = deps ?? PurchaseApprovalDeps.fromProxy,
       _postStock = postStock ?? _postProductionOutput,
       _postToBooks = postToBooks ?? _postProductionToBooks;

  final Future<void> Function(String businessId, ProductionOutputRecord record)
  _postToBooks;

  static Future<void> _postProductionToBooks(
    String businessId,
    ProductionOutputRecord record,
  ) => ProductionJournalPoster(
    DittoService.instance,
  ).sync(businessId: businessId, outputs: [record]);

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
  /// Throws only when the output can't be saved — see [createWorkOrder].
  /// Once it is saved this never throws: an error would read as "not
  /// recorded", and recording again would count the output twice. A stock
  /// failure comes back as `stockError`, an RRA failure as `rraMessage`.
  Future<({ActualOutput? output, String? rraMessage, String? stockError})>
  recordActualOutput({
    required WorkOrder workOrder,
    required double actualQuantity,
    String? varianceReason,
    String? notes,
  }) async {
    final deps = _deps();
    final branchId = deps.branchId;
    final userId = deps.userId;

    if (branchId == null || userId == null) {
      return (output: null, rraMessage: null, stockError: null);
    }

    final output = await deps.strategy.recordActualOutput(
      workOrderId: workOrder.id,
      branchId: branchId,
      actualQuantity: actualQuantity,
      userId: userId,
      varianceReason: varianceReason,
      notes: notes,
    );
    if (output == null) {
      return (output: null, rraMessage: null, stockError: null);
    }

    final saved = output as ActualOutput;
    final ProductionStockResult stock;
    try {
      stock = await _postStock(
        workOrder: workOrder,
        qty: actualQuantity,
        deps: deps,
      );
    } catch (e, s) {
      talker.error('ProductionOutput: output saved, stock not updated', e, s);
      return (
        output: saved,
        rraMessage: null,
        // The increment may have landed before the failure, so don't
        // claim the stock is unchanged: a blind manual add would double it.
        stockError:
            'Output saved, but stock posting failed ($e). Stock may already '
            'have changed: check the finished product stock before adjusting '
            'it by hand. Do not record this output again.',
      );
    }

    // A product made without a recipe: move the batch's value into stock in
    // Books. Only once its stock is in, and best effort: the output and the
    // stock are already saved.
    final unitCost = stock.absorbUnitCost;
    if (unitCost != null) {
      try {
        await _postToBooks(
          workOrder.businessId,
          ProductionOutputRecord(
            outputId: saved.id,
            productName: workOrder.variantName ?? '',
            qty: actualQuantity,
            unitCost: unitCost,
            recordedAt: saved.recordedAt,
          ),
        );
      } catch (e, s) {
        talker.warning('Production: Books posting skipped: $e\n$s');
      }
    }
    return (output: saved, rraMessage: stock.rraMessage, stockError: null);
  }

  /// Update work order status. Throws on failure — see [createWorkOrder].
  /// With [fromStatus], the change applies only while the order still has
  /// that status.
  Future<void> updateWorkOrderStatus({
    required String workOrderId,
    required String status,
    String? fromStatus,
  }) async {
    await _deps().strategy.updateWorkOrder(
      workOrderId: workOrderId,
      status: status,
      fromStatus: fromStatus,
    );
  }

  /// Start a planned work order (status `in_progress`). Starting moves no
  /// stock: finished goods are added when output is recorded. An order that
  /// is already started or finished is left alone, also when this copy is
  /// stale and another till moved it on meanwhile (the update is conditional).
  Future<void> startWorkOrder(WorkOrder workOrder) async {
    if (!canStartWorkOrder(workOrder)) return;
    await updateWorkOrderStatus(
      workOrderId: workOrder.id,
      status: 'in_progress',
      fromStatus: 'planned',
    );
  }

  /// Complete a work order
  Future<void> completeWorkOrder(String workOrderId) async {
    await updateWorkOrderStatus(workOrderId: workOrderId, status: 'completed');
  }
}
