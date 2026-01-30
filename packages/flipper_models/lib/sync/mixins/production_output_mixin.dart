import 'dart:async';
import 'package:flipper_models/sync/interfaces/production_output_interface.dart';
import 'package:supabase_models/brick/models/work_order.model.dart';
import 'package:supabase_models/brick/models/actual_output.model.dart';

/// CoreSync implementation of ProductionOutputInterface
///
/// Provides production output functionality.
/// Note: This is a placeholder implementation until Brick models are generated.
mixin ProductionOutputMixin implements ProductionOutputInterface {
  // In-memory storage for development (to be replaced with Brick queries)
  final List<WorkOrder> _workOrders = [];
  final List<ActualOutput> _actualOutputs = [];

  @override
  Future<List<WorkOrder>> getWorkOrders({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    try {
      var filtered = _workOrders.where((wo) => wo.branchId == branchId);

      if (status != null) {
        filtered = filtered.where((wo) => wo.status == status);
      }
      if (startDate != null) {
        filtered = filtered.where((wo) => !wo.targetDate.isBefore(startDate));
      }
      if (endDate != null) {
        filtered = filtered.where((wo) => !wo.targetDate.isAfter(endDate));
      }

      return filtered.toList();
    } catch (e) {
      print('Error getting work orders: $e');
      return [];
    }
  }

  @override
  Future<WorkOrder?> createWorkOrder({
    required String branchId,
    required String businessId,
    required String variantId,
    required double plannedQuantity,
    required DateTime targetDate,
    String? shiftId,
    String? notes,
  }) async {
    try {
      final workOrder = WorkOrder(
        branchId: branchId,
        businessId: businessId,
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

  @override
  Future<void> updateWorkOrder({
    required String workOrderId,
    double? plannedQuantity,
    String? status,
    String? notes,
  }) async {
    try {
      final index = _workOrders.indexWhere((wo) => wo.id == workOrderId);
      if (index != -1) {
        final current = _workOrders[index];
        _workOrders[index] = current.copyWith(
          plannedQuantity: plannedQuantity,
          status: status,
          notes: notes,
          lastTouched: DateTime.now().toUtc(),
        );
      }
    } catch (e) {
      print('Error updating work order: $e');
    }
  }

  @override
  Future<void> deleteWorkOrder({required String workOrderId}) async {
    try {
      _workOrders.removeWhere((wo) => wo.id == workOrderId);
    } catch (e) {
      print('Error deleting work order: $e');
    }
  }

  @override
  Future<List<ActualOutput>> getActualOutputs({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
    String? workOrderId,
  }) async {
    try {
      var filtered = _actualOutputs.where((ao) => ao.branchId == branchId);

      if (workOrderId != null) {
        filtered = filtered.where((ao) => ao.workOrderId == workOrderId);
      }
      if (startDate != null) {
        filtered = filtered.where((ao) => !ao.recordedAt.isBefore(startDate));
      }
      if (endDate != null) {
        filtered = filtered.where((ao) => !ao.recordedAt.isAfter(endDate));
      }

      return filtered.toList();
    } catch (e) {
      print('Error getting actual outputs: $e');
      return [];
    }
  }

  @override
  Future<ActualOutput?> recordActualOutput({
    required String workOrderId,
    required String branchId,
    required double actualQuantity,
    required String userId,
    String? varianceReason,
    String? notes,
  }) async {
    try {
      final output = ActualOutput(
        workOrderId: workOrderId,
        branchId: branchId,
        actualQuantity: actualQuantity,
        userId: userId,
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

  @override
  Future<void> updateActualOutput({
    required String outputId,
    double? actualQuantity,
    String? varianceReason,
    String? notes,
  }) async {
    try {
      final index = _actualOutputs.indexWhere((ao) => ao.id == outputId);
      if (index != -1) {
        final current = _actualOutputs[index];
        _actualOutputs[index] = current.copyWith(
          actualQuantity: actualQuantity,
          varianceReason: varianceReason,
          notes: notes,
          lastTouched: DateTime.now().toUtc(),
        );
      }
    } catch (e) {
      print('Error updating actual output: $e');
    }
  }

  @override
  Stream<List<WorkOrder>> workOrdersStream({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Stream.periodic(const Duration(seconds: 10), (_) {
      return getWorkOrders(
        branchId: branchId,
        startDate: startDate,
        endDate: endDate,
      );
    }).asyncMap((future) => future);
  }

  @override
  Future<Map<String, dynamic>> getVarianceSummary({
    required String branchId,
    required DateTime startDate,
    required DateTime endDate,
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
      int totalOrders = workOrders.length;

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
          }
        }
      }

      final variance = totalActual - totalPlanned;
      final variancePercentage = totalPlanned > 0
          ? (variance / totalPlanned) * 100
          : 0.0;
      final efficiency = totalPlanned > 0
          ? (totalActual / totalPlanned) * 100
          : 0.0;

      return {
        'totalPlanned': totalPlanned,
        'totalActual': totalActual,
        'variance': variance,
        'variancePercentage': variancePercentage,
        'efficiency': efficiency,
        'totalOrders': totalOrders,
        'completedOrders': completedOrders,
        'completionRate': totalOrders > 0
            ? (completedOrders / totalOrders) * 100
            : 0.0,
        'varianceByReason': varianceByReason,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      };
    } catch (e) {
      print('Error getting variance summary: $e');
      return {};
    }
  }
}
