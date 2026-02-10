import 'package:supabase_models/brick/models/work_order.model.dart';
import 'package:supabase_models/brick/models/actual_output.model.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:uuid/uuid.dart';
import 'package:flipper_services/proxy.dart';
import '../models/production_output_models.dart';

/// Service layer for production output feature
///
/// Provides business logic and data formatting for the UI.
/// ENFORCES Reads from Ditto (Capella) while Writes delegate to strategy.
class ProductionOutputService {
  /// Get production summary for a date range
  Future<ProductionSummary> getProductionSummary({
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final bId = branchId ?? ProxyService.box.getBranchId();
      if (bId == null) return ProductionSummary.empty;

      // Always calculate from Ditto data directly
      return await _calculateSummarySafely(bId, startDate, endDate);
    } catch (e) {
      print('Error getting production summary: $e');
      return ProductionSummary.empty;
    }
  }

  Future<ProductionSummary> _calculateSummarySafely(
    String branchId,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    // These calls now go to Ditto
    final workOrders = await getWorkOrders(
      branchId: branchId,
      startDate: startDate,
      endDate: endDate,
    );

    double totalPlanned = 0;
    double totalActual = 0;
    int completedOrders = 0;
    final totalOrders = workOrders.length;

    final varianceByReason = <String, double>{
      'machine': 0,
      'material': 0,
      'labor': 0,
      'quality': 0,
      'planning': 0,
      'other': 0,
    };

    for (final wo in workOrders) {
      totalPlanned += wo.plannedQuantity;
      totalActual += wo.actualQuantity;
      if (wo.status == 'completed') completedOrders++;
    }

    final variance = totalActual - totalPlanned;
    final variancePercentage = totalPlanned > 0
        ? (variance / totalPlanned) * 100
        : 0.0;
    final efficiency = totalPlanned > 0
        ? (totalActual / totalPlanned) * 100
        : 0.0;

    final outputs = await getActualOutputs(
      branchId: branchId,
      startDate: startDate,
      endDate: endDate,
    );

    for (final output in outputs) {
      if (output.varianceReason != null) {
        final reason = output.varianceReason!.toLowerCase();
        if (varianceByReason.containsKey(reason)) {
          varianceByReason[reason] = varianceByReason[reason]! + 1;
        } else {
          varianceByReason['other'] = varianceByReason['other']! + 1;
        }
      }
    }

    return ProductionSummary(
      totalPlanned: totalPlanned,
      totalActual: totalActual,
      variance: variance,
      variancePercentage: variancePercentage,
      efficiency: efficiency,
      totalOrders: totalOrders,
      completedOrders: completedOrders,
      completionRate: totalOrders > 0
          ? (completedOrders / totalOrders) * 100
          : 0.0,
      varianceByReason: varianceByReason,
    );
  }

  /// Get actual outputs from Ditto
  Future<List<ActualOutput>> getActualOutputs({
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final bId = branchId ?? ProxyService.box.getBranchId();
      if (bId == null) return [];

      final ditto = ProxyService.ditto.dittoInstance;
      if (ditto == null) return [];

      final List<String> whereClauses = ['branchId = :branchId'];
      final Map<String, dynamic> arguments = {'branchId': bId};

      if (startDate != null) {
        whereClauses.add('recordedAt >= :startDate');
        arguments['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        whereClauses.add('recordedAt <= :endDate');
        arguments['endDate'] = endDate.toIso8601String();
      }

      final query =
          "SELECT * FROM actual_outputs WHERE ${whereClauses.join(' AND ')}";

      ditto.sync.registerSubscription(query, arguments: arguments);

      final result = await ditto.store.execute(query, arguments: arguments);

      return result.items.map((item) {
        return ActualOutput.fromJson(Map<String, dynamic>.from(item.value));
      }).toList();
    } catch (e) {
      print('Error getting actual outputs from Ditto: $e');
      return [];
    }
  }

  /// Get work orders for display from DITTO
  Future<List<WorkOrder>> getWorkOrders({
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    try {
      final bId = branchId ?? ProxyService.box.getBranchId();
      if (bId == null) return [];

      final ditto = ProxyService.ditto.dittoInstance;
      if (ditto == null) return [];

      final List<String> whereClauses = ['branchId = :branchId'];
      final Map<String, dynamic> arguments = {'branchId': bId};

      if (status != null) {
        whereClauses.add('status = :status');
        arguments['status'] = status;
      }
      if (startDate != null) {
        whereClauses.add('targetDate >= :startDate');
        arguments['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        whereClauses.add('targetDate <= :endDate');
        arguments['endDate'] = endDate.toIso8601String();
      }

      final query =
          "SELECT * FROM work_orders WHERE ${whereClauses.join(' AND ')}";

      ditto.sync.registerSubscription(query, arguments: arguments);

      final result = await ditto.store.execute(query, arguments: arguments);

      return result.items.map((item) {
        return WorkOrder.fromJson(Map<String, dynamic>.from(item.value));
      }).toList();
    } catch (e) {
      print('Error getting work orders from Ditto: $e');
      return [];
    }
  }

  /// Get today's work orders
  Future<List<WorkOrder>> getTodayWorkOrders() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return getWorkOrders(startDate: startOfDay, endDate: endOfDay);
  }

  /// Get this week's work orders
  Future<List<WorkOrder>> getWeekWorkOrders() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    return getWorkOrders(
      startDate: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      endDate: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day),
    );
  }

  /// Create a new work order
  /// Uses strategy to allow dual write logic in CapellaSync
  Future<WorkOrder?> createWorkOrder({
    required String variantId,
    String? variantName,
    required double plannedQuantity,
    required DateTime targetDate,
    String? shiftId,
    String? notes,
  }) async {
    try {
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
    } catch (e) {
      print('Error creating work order: $e');
      return null;
    }
  }

  /// Record actual output for a work order
  /// Uses strategy to allow dual write logic in CapellaSync
  Future<ActualOutput?> recordActualOutput({
    required String workOrderId,
    required double actualQuantity,
    String? varianceReason,
    String? notes,
  }) async {
    try {
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
    } catch (e) {
      print('Error recording actual output: $e');
      return null;
    }
  }

  /// Get variance chart data for a period
  Future<List<VarianceDataPoint>> getVarianceChartData({int days = 7}) async {
    try {
      final now = DateTime.now();
      final dataPoints = <VarianceDataPoint>[];

      for (int i = days - 1; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final startOfDay = DateTime(date.year, date.month, date.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));

        // Start fetching data for the day using new summary logic (Ditto backed)
        final summary = await getProductionSummary(
          startDate: startOfDay,
          endDate: endOfDay,
        );

        dataPoints.add(
          VarianceDataPoint(
            date: startOfDay,
            planned: summary.totalPlanned,
            actual: summary.totalActual,
            variance: summary.variance,
          ),
        );
      }

      return dataPoints;
    } catch (e) {
      print('Error getting variance chart data: $e');
      return [];
    }
  }

  /// Update work order status
  Future<void> updateWorkOrderStatus({
    required String workOrderId,
    required String status,
  }) async {
    try {
      await ProxyService.strategy.updateWorkOrder(
        workOrderId: workOrderId,
        status: status,
      );
    } catch (e) {
      print('Error updating work order status: $e');
    }
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
      final isEbmEnabled = ebm != null && (ebm.vatEnabled ?? false);
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
              URI: ebm.taxServerUrl,
            );

            // Save stock master for the raw material variant
            final currentStock =
                variant.stock?.currentStock ?? variant.qty ?? 0.0;
            await ProxyService.tax.saveStockMaster(
              variant: variant,
              URI: ebm.taxServerUrl,
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
          URI: ebm.taxServerUrl,
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
              URI: ebm.taxServerUrl,
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
