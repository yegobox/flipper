import 'package:supabase_models/brick/models/work_order.model.dart';
import 'package:supabase_models/brick/models/actual_output.model.dart';
import '../models/production_output_models.dart';

/// Service layer for production output feature
///
/// Provides business logic and data formatting for the UI.
/// Note: This uses in-memory storage until the interface is fully connected to CoreSync.
class ProductionOutputService {
  // In-memory storage for development
  final List<WorkOrder> _workOrders = [];
  final List<ActualOutput> _actualOutputs = [];

  /// Get production summary for a date range
  Future<ProductionSummary> getProductionSummary({
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
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
        if (wo.isCompleted) completedOrders++;
      }

      final variance = totalActual - totalPlanned;
      final variancePercentage = totalPlanned > 0
          ? (variance / totalPlanned) * 100
          : 0.0;
      final efficiency = totalPlanned > 0
          ? (totalActual / totalPlanned) * 100
          : 0.0;

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
    } catch (e) {
      print('Error getting production summary: $e');
      return ProductionSummary.empty;
    }
  }

  /// Get work orders for display
  Future<List<WorkOrder>> getWorkOrders({
    String? branchId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    try {
      var filtered = _workOrders.where((wo) {
        if (branchId != null && wo.branchId != branchId) return false;
        if (status != null && wo.status != status) return false;
        if (startDate != null && wo.targetDate.isBefore(startDate))
          return false;
        if (endDate != null && wo.targetDate.isAfter(endDate)) return false;
        return true;
      });
      return filtered.toList();
    } catch (e) {
      print('Error getting work orders: $e');
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
  Future<WorkOrder?> createWorkOrder({
    required String variantId,
    required double plannedQuantity,
    required DateTime targetDate,
    String? shiftId,
    String? notes,
  }) async {
    try {
      final workOrder = WorkOrder(
        branchId: '',
        businessId: '',
        variantId: variantId,
        plannedQuantity: plannedQuantity,
        targetDate: targetDate,
        shiftId: shiftId,
        notes: notes,
        lastTouched: DateTime.now().toUtc(),
      );

      _workOrders.add(workOrder);
      return workOrder;
    } catch (e) {
      print('Error creating work order: $e');
      return null;
    }
  }

  /// Record actual output for a work order
  Future<ActualOutput?> recordActualOutput({
    required String workOrderId,
    required double actualQuantity,
    String? varianceReason,
    String? notes,
  }) async {
    try {
      final output = ActualOutput(
        workOrderId: workOrderId,
        branchId: '',
        actualQuantity: actualQuantity,
        userId: '',
        varianceReason: varianceReason,
        notes: notes,
        lastTouched: DateTime.now().toUtc(),
      );

      _actualOutputs.add(output);

      // Update the work order's actual quantity
      final woIndex = _workOrders.indexWhere((wo) => wo.id == workOrderId);
      if (woIndex != -1) {
        final workOrder = _workOrders[woIndex];
        final allOutputs = _actualOutputs
            .where((ao) => ao.workOrderId == workOrderId)
            .toList();
        final totalActual = allOutputs.fold<double>(
          0,
          (sum, o) => sum + o.actualQuantity,
        );
        _workOrders[woIndex] = workOrder.copyWith(
          actualQuantity: totalActual,
          lastTouched: DateTime.now().toUtc(),
        );
      }

      return output;
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

        final workOrders = await getWorkOrders(
          startDate: startOfDay,
          endDate: endOfDay,
        );

        double totalPlanned = 0;
        double totalActual = 0;

        for (final wo in workOrders) {
          totalPlanned += wo.plannedQuantity;
          totalActual += wo.actualQuantity;
        }

        dataPoints.add(
          VarianceDataPoint(
            date: startOfDay,
            planned: totalPlanned,
            actual: totalActual,
            variance: totalActual - totalPlanned,
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
      final woIndex = _workOrders.indexWhere((wo) => wo.id == workOrderId);
      if (woIndex != -1) {
        _workOrders[woIndex] = _workOrders[woIndex].copyWith(
          status: status,
          lastTouched: DateTime.now().toUtc(),
        );
      }
    } catch (e) {
      print('Error updating work order status: $e');
    }
  }

  /// Complete a work order
  Future<void> completeWorkOrder(String workOrderId) async {
    await updateWorkOrderStatus(workOrderId: workOrderId, status: 'completed');
  }
}
