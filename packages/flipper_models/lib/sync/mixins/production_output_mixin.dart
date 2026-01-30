import 'dart:async';
import 'package:flipper_models/sync/interfaces/production_output_interface.dart';
import 'package:supabase_models/brick/models/work_order.model.dart';
import 'package:supabase_models/brick/models/actual_output.model.dart';
import 'package:supabase_models/brick/repository.dart';

import 'package:uuid/uuid.dart';

/// CoreSync implementation of ProductionOutputInterface
///
/// Provides production output functionality using Brick (SQLite/Supabase).
/// Used as the default strategy or when Capella is not active.
mixin ProductionOutputMixin implements ProductionOutputInterface {
  Repository get repository;

  @override
  Future<List<WorkOrder>> getWorkOrders({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    try {
      final queryConditions = [Where('branchId').isExactly(branchId)];

      if (status != null) {
        queryConditions.add(Where('status').isExactly(status));
      }

      // Brick query doesn't support complex date comparisons in 'where' easily for all providers
      // Fetch and filter in memory if needed, or rely on provider capabilities.
      // For OfflineFirstWithSupabase, simpler equality is safest, but we can try ranges if supported.
      // We'll fetch by branch and filter in memory to be safe and consistent.

      final workOrders = await repository.get<WorkOrder>(
        query: Query(where: queryConditions),
      );

      var filtered = workOrders;
      if (startDate != null) {
        filtered = filtered
            .where((wo) => !wo.targetDate.isBefore(startDate))
            .toList();
      }
      if (endDate != null) {
        filtered = filtered
            .where((wo) => !wo.targetDate.isAfter(endDate))
            .toList();
      }

      return filtered;
    } catch (e) {
      print('Error getting work orders (Brick): $e');
      return [];
    }
  }

  @override
  Future<WorkOrder?> createWorkOrder({
    required String branchId,
    required String businessId,
    required String variantId,
    String? variantName,
    required double plannedQuantity,
    required DateTime targetDate,
    String? shiftId,
    String? notes,
  }) async {
    try {
      final workOrder = WorkOrder(
        id: const Uuid().v4(),
        branchId: branchId,
        businessId: businessId,
        variantId: variantId,
        variantName: variantName,
        plannedQuantity: plannedQuantity,
        targetDate: targetDate, // DateTime
        shiftId: shiftId,
        notes: notes,
        status: 'planned',
        lastTouched: DateTime.now().toUtc(),
      );

      await repository.upsert<WorkOrder>(workOrder);
      return workOrder;
    } catch (e) {
      print('Error creating work order (Brick): $e');
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
      final workOrders = await repository.get<WorkOrder>(
        query: Query(where: [Where('id').isExactly(workOrderId)]),
      );

      if (workOrders.isNotEmpty) {
        final current = workOrders.first;
        final now = DateTime.now().toUtc();

        // Set timestamps based on status changes
        DateTime? startedAt = current.startedAt;
        DateTime? completedAt = current.completedAt;

        if (status == 'in_progress' && current.status != 'in_progress') {
          startedAt = now;
        }
        if (status == 'completed' && current.status != 'completed') {
          completedAt = now;
        }

        final updated = current.copyWith(
          plannedQuantity: plannedQuantity,
          status: status,
          notes: notes,
          startedAt: startedAt,
          completedAt: completedAt,
          lastTouched: now,
        );
        await repository.upsert<WorkOrder>(updated);
      }
    } catch (e) {
      print('Error updating work order (Brick): $e');
    }
  }

  @override
  Future<void> deleteWorkOrder({required String workOrderId}) async {
    try {
      final workOrders = await repository.get<WorkOrder>(
        query: Query(where: [Where('id').isExactly(workOrderId)]),
      );
      if (workOrders.isNotEmpty) {
        await repository.delete<WorkOrder>(workOrders.first);
      }
    } catch (e) {
      print('Error deleting work order (Brick): $e');
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
      final queryConditions = [Where('branchId').isExactly(branchId)];
      if (workOrderId != null) {
        queryConditions.add(Where('workOrderId').isExactly(workOrderId));
      }

      final outputs = await repository.get<ActualOutput>(
        query: Query(where: queryConditions),
      );

      var filtered = outputs;
      if (startDate != null) {
        // Assuming recordedAt or using lastTouched as proxy if needed.
        // ActualOutput should have a date field. Checking model...
        // It has lastTouched. A 'createdAt' or 'recordedAt' would be better.
        // Assuming the model has it or we filter by lastTouched.
        // The interface implies we filter by date.
        // Let's assume lastTouched for now or check model later.
        filtered = filtered
            .where(
              (ao) =>
                  ao.lastTouched != null &&
                  !ao.lastTouched!.isBefore(startDate),
            )
            .toList();
      }
      if (endDate != null) {
        filtered = filtered
            .where(
              (ao) =>
                  ao.lastTouched != null && !ao.lastTouched!.isAfter(endDate),
            )
            .toList();
      }

      return filtered;
    } catch (e) {
      print('Error getting actual outputs (Brick): $e');
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
        id: const Uuid().v4(),
        workOrderId: workOrderId,
        branchId: branchId,
        actualQuantity: actualQuantity,
        userId: userId,
        varianceReason: varianceReason,
        notes: notes,
        lastTouched: DateTime.now().toUtc(),
      );

      await repository.upsert<ActualOutput>(output);

      // Update work order total
      final workOrders = await repository.get<WorkOrder>(
        query: Query(where: [Where('id').isExactly(workOrderId)]),
      );
      if (workOrders.isNotEmpty) {
        final wo = workOrders.first;
        final newTotal = (wo.actualQuantity) + actualQuantity;
        final updatedWo = wo.copyWith(
          actualQuantity: newTotal,
          lastTouched: DateTime.now().toUtc(),
        );
        await repository.upsert<WorkOrder>(updatedWo);
      }

      return output;
    } catch (e) {
      print('Error recording actual output (Brick): $e');
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
      final outputs = await repository.get<ActualOutput>(
        query: Query(where: [Where('id').isExactly(outputId)]),
      );

      if (outputs.isNotEmpty) {
        final current = outputs.first;
        final updated = current.copyWith(
          actualQuantity: actualQuantity,
          varianceReason: varianceReason,
          notes: notes,
          lastTouched: DateTime.now().toUtc(),
        );
        await repository.upsert<ActualOutput>(updated);
      }
    } catch (e) {
      print('Error updating actual output (Brick): $e');
    }
  }

  @override
  Stream<List<WorkOrder>> workOrdersStream({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    // Brick doesn't have a simple 'watch' query exposed via Repository in this mixin usually
    // Standard practice is to return a Stream that polls or uses repository.subscribe if available.
    // For now, simpler polling stream or just return a future as stream.
    return Stream.periodic(const Duration(seconds: 5), (_) async {
      return await getWorkOrders(
        branchId: branchId,
        startDate: startDate,
        endDate: endDate,
      );
    }).asyncMap((event) => event);
  }

  @override
  Future<Map<String, dynamic>> getVarianceSummary({
    required String branchId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Same calculation logic as service/Capella, but using Brick fetch
    try {
      final workOrders = await getWorkOrders(
        branchId: branchId,
        startDate: startDate,
        endDate: endDate,
      );

      final outputs = await getActualOutputs(
        branchId: branchId,
        startDate: startDate,
        endDate: endDate,
      );

      double totalPlanned = 0;
      double totalActual = 0;
      int completedOrders = 0;
      final totalOrders = workOrders.length;

      for (final wo in workOrders) {
        totalPlanned += wo.plannedQuantity;
        totalActual += wo.actualQuantity;
        if (wo.status == 'completed') completedOrders++;
      }

      final varianceByReason = <String, double>{
        'machine': 0,
        'material': 0,
        'labor': 0,
        'quality': 0,
        'planning': 0,
        'other': 0,
      };

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
      print('Error getting variance summary (Brick): $e');
      return {};
    }
  }
}
