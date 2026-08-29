import 'package:supabase_models/brick/models/work_order.model.dart';
import 'package:supabase_models/brick/models/actual_output.model.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:uuid/uuid.dart';
import 'package:flipper_services/proxy.dart';

/// Service layer for the production output feature.
///
/// A thin write facade over Capella/Ditto. Reads are served reactively by
/// `workOrdersStreamProvider` / `actualOutputsStreamProvider` and the derived
/// providers in `../providers/production_output_derived_providers.dart`; this
/// class deliberately keeps no read logic of its own beyond [getWorkOrders],
/// which the raw-material deduction and the forecasting service still need
/// as a one-shot.
class ProductionOutputService {
  /// One-shot work-order read. Prefer the stream providers in UI code.
  Future<List<WorkOrder>> getWorkOrders({
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    final bId = branchId ?? ProxyService.box.getBranchId();
    if (bId == null) return [];

    final rows = await ProxyService.strategy.getWorkOrders(
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
    final branchId = ProxyService.box.getBranchId();
    final businessId = ProxyService.box.getBusinessId();

    if (branchId == null || businessId == null) return null;

    return await ProxyService.strategy.createWorkOrder(
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

  /// Record actual output for a work order. Throws on failure — see
  /// [createWorkOrder].
  Future<ActualOutput?> recordActualOutput({
    required String workOrderId,
    required double actualQuantity,
    String? varianceReason,
    String? notes,
  }) async {
    final branchId = ProxyService.box.getBranchId();
    final userId = ProxyService.box.getUserId();

    if (branchId == null || userId == null) return null;

    return await ProxyService.strategy.recordActualOutput(
      workOrderId: workOrderId,
      branchId: branchId,
      actualQuantity: actualQuantity,
      userId: userId.toString(),
      varianceReason: varianceReason,
      notes: notes,
    );
  }

  /// Update work order status. Throws on failure — see [createWorkOrder].
  Future<void> updateWorkOrderStatus({
    required String workOrderId,
    required String status,
  }) async {
    await ProxyService.strategy.updateWorkOrder(
      workOrderId: workOrderId,
      status: status,
    );
  }

  /// Start a work order (change status to in_progress)
  Future<void> startWorkOrder(String workOrderId) async {
    await updateWorkOrderStatus(
      workOrderId: workOrderId,
      status: 'in_progress',
    );

    // Auto-deduct raw materials when work order starts
    try {
      final workOrders = await getWorkOrders(
        branchId: ProxyService.box.getBranchId(),
      );
      final workOrder = workOrders
          .where((w) => w.id == workOrderId)
          .firstOrNull;

      if (workOrder != null) {
        await _handleRawMaterialDeduction(workOrder);
      }
    } catch (e) {
      print('Error auto-deducting materials: $e');
    }
  }

  /// Complete a work order
  Future<void> completeWorkOrder(String workOrderId) async {
    await updateWorkOrderStatus(workOrderId: workOrderId, status: 'completed');
  }

  /// Handle auto-deduction of raw materials
  Future<void> _handleRawMaterialDeduction(WorkOrder workOrder) async {
    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) return;

      // 1. Get the main product variant to find ingredients
      final variant = await ProxyService.strategy.getVariant(
        id: workOrder.variantId,
      );
      if (variant == null) return;

      // 2. Fetch composites (ingredients) for this product
      // Note: Composite links via productId usually
      final composites = await ProxyService.strategy.composites(
        productId: variant.productId,
      );

      // 3. Prepare RRA items if EBM is enabled
      final ebm = await ProxyService.strategy.ebm(branchId: branchId);
      final taxUrl = ebm?.taxServerUrl;
      final isEbmEnabled =
          ebm != null && (ebm.vatEnabled ?? false) && taxUrl != null && taxUrl.isNotEmpty;
      final rraItems = <models.TransactionItem>[];

      // 4. If no composites, treat the variant itself as the raw material
      if (composites.isEmpty) {
        // The variant itself is a raw material - deduct its stock directly
        final plannedQty = workOrder.plannedQuantity;

        if (plannedQty > 0 &&
            variant.stockId != null &&
            variant.itemTyCd != "3") {
          // Deduct from local stock
          await ProxyService.strategy.updateStock(
            stockId: variant.stockId!,
            currentStock: -plannedQty, // Negative to deduct
            appending: true,
            lastTouched: DateTime.now().toUtc(),
          );

          // Send to RRA if EBM is enabled
          if (isEbmEnabled) {
            final supplyPrice = variant.supplyPrice ?? 0.0;
            rraItems.add(
              models.TransactionItem(
                id: const Uuid().v4(),
                name: variant.name,
                itemTyCd: variant.itemTyCd,
                taxTyCd: variant.taxTyCd,
                qty: plannedQty,
                price: supplyPrice,
                prc: supplyPrice,
                splyAmt: supplyPrice * plannedQty,
                totAmt: supplyPrice * plannedQty,
                taxblAmt: supplyPrice * plannedQty,
                taxAmt: 0,
                variantId: variant.id,
                branchId: branchId,
                lastTouched: DateTime.now().toUtc(),
                itemCd: variant.itemCd,
                itemClsCd: variant.itemClsCd,
                itemStdNm: variant.itemStdNm,
                orgnNatCd: variant.orgnNatCd,
                pkgUnitCd: variant.pkgUnitCd,
                qtyUnitCd: variant.qtyUnitCd,
                discount: 0.0,
                ttCatCd: variant.ttCatCd ?? 'D',
              ),
            );

            // Get SAR number for tracking
            final sar = await ProxyService.strategy.getSar(branchId: branchId);
            final sarNo = sar != null ? (sar.sarNo + 1) : null;

            // Send stock deduction to RRA
            await ProxyService.tax.saveStockItems(
              items: rraItems,
              updateMaster: false,
              tinNumber: ebm.tinNumber.toString(),
              bhFId: ebm.bhfId,
              sarTyCd: '06', // Adjustment/Internal Usage
              isStockIn: false,
              sarNo: sarNo?.toString(),
              invoiceNumber: sarNo,
              totalSupplyPrice: supplyPrice * plannedQty,
              totalvat: 0,
              totalAmount: supplyPrice * plannedQty,
              remark: 'Manufacturing Usage: ${workOrder.variantName}',
              ocrnDt: DateTime.now().toUtc(),
              URI: taxUrl!,
            );

            // Save stock master for the raw material variant
            final currentStock =
                variant.stock?.currentStock ?? variant.qty ?? 0.0;
            await ProxyService.tax.saveStockMaster(
              variant: variant,
              URI: taxUrl!,
              stockMasterQty: currentStock,
            );
          }
        }
        return; // Exit after handling non-composite case
      }

      // 5. Process each ingredient (composite case)
      for (final composite in composites) {
        // composite.variantId is the ingredient variant ID in this context
        final ingredientVariantId = composite.variantId;
        final double qtyPerUnit = composite.qty ?? 0.0;
        final plannedQty = workOrder.plannedQuantity;
        final totalDeduction = qtyPerUnit * plannedQty;

        if (totalDeduction <= 0) continue;

        // Update local stock
        final ingredientVariant = await ProxyService.strategy.getVariant(
          id: ingredientVariantId,
        );

        if (ingredientVariant != null && ingredientVariant.stockId != null) {
          // Deduct from local stock (passing negative value if appending, or calculator new value)

          await ProxyService.strategy.updateStock(
            stockId: ingredientVariant.stockId!,
            currentStock: -totalDeduction, // Negative to deduct
            appending: true,
            lastTouched: DateTime.now().toUtc(),
          );

          if (isEbmEnabled) {
            final supplyPrice = ingredientVariant.supplyPrice ?? 0.0;
            // Prepare item for RRA
            rraItems.add(
              models.TransactionItem(
                id: const Uuid().v4(),
                name: ingredientVariant.name,
                itemTyCd: ingredientVariant.itemTyCd,
                taxTyCd: ingredientVariant.taxTyCd,
                qty: totalDeduction, // Positive quantity for the record
                price: supplyPrice,
                prc: supplyPrice,
                splyAmt: supplyPrice * totalDeduction,
                totAmt: supplyPrice * totalDeduction,
                taxblAmt: supplyPrice * totalDeduction,
                taxAmt: 0,
                variantId: ingredientVariantId,
                branchId: branchId,
                lastTouched: DateTime.now().toUtc(),
                itemCd: ingredientVariant.itemCd,
                itemClsCd: ingredientVariant.itemClsCd,
                itemStdNm: ingredientVariant.itemStdNm,
                orgnNatCd: ingredientVariant.orgnNatCd,
                pkgUnitCd: ingredientVariant.pkgUnitCd,
                qtyUnitCd: ingredientVariant.qtyUnitCd,
                discount: 0.0,
                ttCatCd: ingredientVariant.ttCatCd ?? 'D',
              ),
            );
          }
        }
      }

      // 5. Send to RRA if applicable
      if (isEbmEnabled && rraItems.isNotEmpty) {
        // Get SAR number for tracking
        final sar = await ProxyService.strategy.getSar(branchId: branchId);
        final sarNo = sar != null ? (sar.sarNo + 1) : null;

        // Save stock items to RRA with SAR number
        await ProxyService.tax.saveStockItems(
          items: rraItems,
          updateMaster: false,
          tinNumber: ebm.tinNumber.toString(),
          bhFId: ebm.bhfId,
          sarTyCd: '06', // Adjustment/Internal Usage
          isStockIn: false, // Stock going OUT
          sarNo: sarNo?.toString(),
          invoiceNumber: sarNo,
          totalSupplyPrice: rraItems.fold(
            0.0,
            (sum, item) => sum + (item.splyAmt ?? 0.0),
          ),
          totalvat: 0,
          totalAmount: rraItems.fold(
            0.0,
            (sum, item) => sum + (item.totAmt ?? 0.0),
          ),
          remark: 'Manufacturing Usage: ${workOrder.variantName}',
          ocrnDt: DateTime.now().toUtc(),
          URI: taxUrl!,
        );

        // Save stock master for each ingredient (skip services - itemTyCd: "3")
        for (final composite in composites) {
          final ingredientVariant = await ProxyService.strategy.getVariant(
            id: composite.variantId,
          );
          if (ingredientVariant != null && ingredientVariant.itemTyCd != "3") {
            // Get current stock from embedded stock, or use qty field as fallback
            final currentStock =
                ingredientVariant.stock?.currentStock ??
                ingredientVariant.qty ??
                0.0;

            await ProxyService.tax.saveStockMaster(
              variant: ingredientVariant,
              URI: taxUrl!,
              stockMasterQty: currentStock,
            );
          }
        }
      }
    } catch (e) {
      print('Error in raw material deduction: $e');
    }
  }
}
