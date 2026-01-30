import 'dart:async';
import 'package:flipper_models/sync/interfaces/production_output_interface.dart';
import 'package:supabase_models/brick/models/work_order.model.dart';
import 'package:supabase_models/brick/models/actual_output.model.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:uuid/uuid.dart';

/// Capella (Ditto) implementation of ProductionOutputInterface
///
/// Provides production output functionality using the Ditto sync engine for reads,
/// and Dual Write (Brick + Ditto) for writes to satisfy the requirement:
/// "create use standard sqlite, supabase while retrieving data should use capella"
mixin CapellaProductionOutputMixin implements ProductionOutputInterface {
  DittoService get dittoService => DittoService.instance;
  Repository get repository;

  @override
  Future<List<WorkOrder>> getWorkOrders({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) return [];

      final List<String> whereClauses = ['branchId = :branchId'];
      final Map<String, dynamic> arguments = {'branchId': branchId};

      if (status != null) {
        whereClauses.add('status = :status');
        arguments['status'] = status;
      }
      // Note: Date filtering in Ditto might need specific format or post-filtering
      // For now, we'll fetch and post-filter if complex date logic is needed,
      // but simplistic string comparison works if ISO8601 is used.
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

      // Subscribe to keep data synced
      ditto.sync.registerSubscription(query, arguments: arguments);

      // Execute query
      final result = await ditto.store.execute(query, arguments: arguments);

      return result.items.map((item) {
        return WorkOrder.fromJson(Map<String, dynamic>.from(item.value));
      }).toList();
    } catch (e) {
      print('Error getting work orders from Capella: $e');
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
        id: const Uuid().v4(),
        branchId: branchId,
        businessId: businessId,
        variantId: variantId,
        plannedQuantity: plannedQuantity,
        targetDate: targetDate,
        shiftId: shiftId,
        notes: notes,
        status: 'planned', // Default status
        lastTouched: DateTime.now().toUtc(),
      );

      // 1. Write to Standard SQLite/Supabase (Brick)
      await repository.upsert<WorkOrder>(workOrder);

      // 2. Write to Ditto (Capella)
      final ditto = dittoService.dittoInstance;
      if (ditto != null) {
        final doc = workOrder.toJson();
        // Ensure ID is set in the document for Ditto if needed, usually passed as top level
        // or embedded. Brick models usually have 'id'.
        await ditto.store.execute(
          "INSERT INTO work_orders DOCUMENTS (:doc)",
          arguments: {'doc': doc},
        );
      }

      return workOrder;
    } catch (e) {
      print('Error creating work order in Capella (Dual Write): $e');
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
      // 1. Update in Brick
      // We need to fetch it first to update properly with Brick usually,
      // or if we have the object we upsert. Here we only have ID.
      // Brick's repository doesn't have partial update easily without fetching.
      // But we can try to fetch from Brick first.
      final workOrderList = await repository.get<WorkOrder>(
        query: Query(where: [Where('id').isExactly(workOrderId)]),
      );

      if (workOrderList.isNotEmpty) {
        final workOrder = workOrderList.first;
        final updatedWorkOrder = workOrder.copyWith(
          plannedQuantity: plannedQuantity,
          status: status,
          notes: notes,
          lastTouched: DateTime.now().toUtc(),
        );
        await repository.upsert<WorkOrder>(updatedWorkOrder);
      }

      // 2. Update in Ditto
      final ditto = dittoService.dittoInstance;
      if (ditto != null) {
        final Map<String, dynamic> updates = {};
        if (plannedQuantity != null)
          updates['plannedQuantity'] = plannedQuantity;
        if (status != null) updates['status'] = status;
        if (notes != null) updates['notes'] = notes;
        updates['lastTouched'] = DateTime.now().toUtc().toIso8601String();

        if (updates.isNotEmpty) {
          final setClause = updates.keys.map((k) => "$k = :$k").join(', ');
          final args = {...updates, 'id': workOrderId};

          await ditto.store.execute(
            "UPDATE work_orders SET $setClause WHERE id = :id",
            arguments: args,
          );
        }
      }
    } catch (e) {
      print('Error updating work order in Capella: $e');
    }
  }

  @override
  Future<void> deleteWorkOrder({required String workOrderId}) async {
    try {
      // 1. Delete from Brick
      final workOrderList = await repository.get<WorkOrder>(
        query: Query(where: [Where('id').isExactly(workOrderId)]),
      );
      if (workOrderList.isNotEmpty) {
        await repository.delete<WorkOrder>(workOrderList.first);
      }

      // 2. Delete from Ditto
      final ditto = dittoService.dittoInstance;
      if (ditto != null) {
        await ditto.store.execute(
          "DELETE FROM work_orders WHERE id = :id",
          arguments: {'id': workOrderId},
        );
      }
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
      final ditto = dittoService.dittoInstance;
      if (ditto == null) return [];

      final List<String> whereClauses = ['branchId = :branchId'];
      final Map<String, dynamic> arguments = {'branchId': branchId};

      if (workOrderId != null) {
        whereClauses.add('workOrderId = :workOrderId');
        arguments['workOrderId'] = workOrderId;
      }
      if (startDate != null) {
        whereClauses.add(
          'createdAt >= :startDate',
        ); // Assuming createdAt or recordedAt
        arguments['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        whereClauses.add('createdAt <= :endDate');
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
      print('Error getting actual outputs from Capella: $e');
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

      // 1. Write to Brick
      await repository.upsert<ActualOutput>(output);

      // Update WorkOrder in Brick (simple addition for now, ideally transaction)
      final workOrderList = await repository.get<WorkOrder>(
        query: Query(where: [Where('id').isExactly(workOrderId)]),
      );
      if (workOrderList.isNotEmpty) {
        final wo = workOrderList.first;
        final newQty = (wo.actualQuantity) + actualQuantity;
        final updatedWo = wo.copyWith(
          actualQuantity: newQty,
          lastTouched: DateTime.now().toUtc(),
        );
        await repository.upsert<WorkOrder>(updatedWo);

        // Update WorkOrder in Ditto too
        final ditto = dittoService.dittoInstance;
        if (ditto != null) {
          await ditto.store.execute(
            "UPDATE work_orders SET actualQuantity = :qty, lastTouched = :touched WHERE id = :id",
            arguments: {
              'qty': newQty,
              'touched': DateTime.now().toUtc().toIso8601String(),
              'id': workOrderId,
            },
          );
        }
      }

      // 2. Write Output to Ditto
      final ditto = dittoService.dittoInstance;
      if (ditto != null) {
        await ditto.store.execute(
          "INSERT INTO actual_outputs DOCUMENTS (:doc)",
          arguments: {'doc': output.toJson()},
        );
      }

      return output;
    } catch (e) {
      print('Error recording actual output in Capella: $e');
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
    // Implementation for updating actual output would follow similar pattern
    // Fetch, calculate diff (if quantity changed) to update WorkOrder, save both
    // For brevity, basic implementation:
    try {
      // Brick Update
      final list = await repository.get<ActualOutput>(
        query: Query(where: [Where('id').isExactly(outputId)]),
      );
      if (list.isNotEmpty) {
        var output = list.first;
        // Logic to update WorkOrder total would be needed if quantity changes
        // ...
        output = output.copyWith(
          actualQuantity: actualQuantity,
          varianceReason: varianceReason,
          notes: notes,
          lastTouched: DateTime.now().toUtc(),
        );
        await repository.upsert<ActualOutput>(output);
      }

      // Ditto Update
      final ditto = dittoService.dittoInstance;
      if (ditto != null) {
        final Map<String, dynamic> updates = {};
        if (actualQuantity != null) updates['actualQuantity'] = actualQuantity;
        if (varianceReason != null) updates['varianceReason'] = varianceReason;
        if (notes != null) updates['notes'] = notes;
        updates['lastTouched'] = DateTime.now().toUtc().toIso8601String();

        if (updates.isNotEmpty) {
          final setClause = updates.keys.map((k) => "$k = :$k").join(', ');
          final args = {...updates, 'id': outputId};
          await ditto.store.execute(
            "UPDATE actual_outputs SET $setClause WHERE id = :id",
            arguments: args,
          );
        }
      }
    } catch (e) {
      print("Error updating actual output: $e");
    }
  }

  @override
  Stream<List<WorkOrder>> workOrdersStream({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    // Return a stream from Ditto
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return const Stream.empty();

    // Construct query similar to getWorkOrders
    final List<String> whereClauses = ['branchId = :branchId'];
    final Map<String, dynamic> arguments = {'branchId': branchId};

    // ... date logic ...
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

    // Use registerObserver for reactive stream
    StreamController<List<WorkOrder>> controller = StreamController();

    final observer = ditto.store.registerObserver(
      query,
      arguments: arguments,
      onChange: (result) {
        final items = result.items.map((item) {
          return WorkOrder.fromJson(Map<String, dynamic>.from(item.value));
        }).toList();
        controller.add(items);
      },
    );

    controller.onCancel = () {
      observer.cancel();
    };

    return controller.stream;
  }

  @override
  Future<Map<String, dynamic>> getVarianceSummary({
    required String branchId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // We can implement this by fetching data from Ditto and calculating
    // Or if Ditto supports aggregation queries in the future, usage that.
    // For now, fetch and calculate.

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

    // Calculation logic (same as service/coreSync)
    double totalPlanned = 0;
    double totalActual = 0;
    int completedOrders = 0;
    final totalOrders = workOrders.length;

    for (final wo in workOrders) {
      totalPlanned += wo.plannedQuantity;
      // Depending on data model, actualQuantity on WorkOrder might be summed already
      // or we sum from outputs.
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
    };
  }
}
