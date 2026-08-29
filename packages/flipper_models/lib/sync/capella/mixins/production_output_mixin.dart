import 'dart:async';
import 'package:flipper_models/sync/interfaces/production_output_interface.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';

/// Capella (Ditto) implementation of ProductionOutputInterface.
///
/// Production output is **Ditto-only**: every read and every write in this
/// mixin goes straight to the Ditto store, with no Brick/Turso leg. Writes are
/// committed before the future completes, so a caller (or an observer) that
/// looks immediately afterwards always sees them — the old Brick-first path
/// only reached Ditto through an unawaited `DittoSyncCoordinator` hop, which
/// is what made freshly created work orders look like they never arrived.
///
/// Consequence to be aware of: `work_orders` / `actual_outputs` are not in the
/// data-connector's `SYNC_TABLES` and their generated adapters are `sendOnly`,
/// so these documents live in Ditto (device + Capella cloud) and no longer
/// reach Postgres.
///
/// When Ditto is unavailable these methods throw rather than silently falling
/// back — a write that bypasses Ditto would be invisible to the whole feature.
mixin CapellaProductionOutputMixin implements ProductionOutputInterface {
  DittoService get dittoService => DittoService.instance;

  /// The live Ditto handle, or a loud failure. Every write goes through here.
  dynamic _dittoOrThrow(String operation) {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized ($operation)');
      throw StateError('Ditto not initialized for $operation');
    }
    return ditto;
  }

  /// `field = :field, other = :other` for a partial DQL update.
  String _setClause(Map<String, dynamic> updates) =>
      updates.keys.map((key) => '$key = :$key').join(', ');

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
      final preparedPo = prepareDqlSyncSubscription(query, arguments);
      ditto.sync.registerSubscription(
        preparedPo.dql,
        arguments: preparedPo.arguments,
      );

      // Execute query
      final result = await ditto.store.execute(query, arguments: arguments);

      return result.items.map((item) {
        return WorkOrder.fromJson(Map<String, dynamic>.from(item.value));
      }).toList();
    } catch (e) {
      talker.error('Error getting work orders from Capella: $e');
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
    final ditto = _dittoOrThrow('createWorkOrder');

    // Name may be supplied by the caller; the unit only ever comes from the
    // variant, so one read covers both cases.
    String? effectiveVariantName = variantName;
    String? unitOfMeasure;

    final variantResult = await ditto.store.execute(
      'SELECT * FROM variants WHERE _id = :id OR id = :id LIMIT 1',
      arguments: {'id': variantId},
    );
    if (variantResult.items.isNotEmpty) {
      final variant = Map<String, dynamic>.from(variantResult.items.first.value);
      effectiveVariantName ??= variant['name'] as String?;
      unitOfMeasure = variant['unit'] as String?;
    }

    final workOrder = WorkOrder(
      id: const Uuid().v4(),
      branchId: branchId,
      businessId: businessId,
      variantId: variantId,
      variantName: effectiveVariantName,
      plannedQuantity: plannedQuantity,
      targetDate: targetDate,
      shiftId: shiftId,
      notes: notes,
      status: 'planned', // Default status
      unitOfMeasure: unitOfMeasure,
      createdBy: ProxyService.box.getUserId()?.toString(),
      lastTouched: DateTime.now().toUtc(),
    );

    await ditto.store.execute(
      'INSERT INTO work_orders DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {
        'doc': await WorkOrderDittoAdapter.instance.toDittoDocument(workOrder),
      },
    );

    return workOrder;
  }

  @override
  Future<void> updateWorkOrder({
    required String workOrderId,
    double? plannedQuantity,
    String? status,
    String? notes,
  }) async {
    final ditto = _dittoOrThrow('updateWorkOrder');

    // Partial UPDATE rather than a whole-document upsert: a null argument means
    // "leave alone" (matching the old copyWith semantics), and we never write
    // back fields another device may have changed in the meantime.
    final updates = <String, dynamic>{};
    if (plannedQuantity != null) updates['plannedQuantity'] = plannedQuantity;
    if (status != null) updates['status'] = status;
    if (notes != null) updates['notes'] = notes;
    if (updates.isEmpty) return;
    updates['lastTouched'] = DateTime.now().toUtc().toIso8601String();

    await ditto.store.execute(
      'UPDATE work_orders SET ${_setClause(updates)} '
      'WHERE _id = :id OR id = :id',
      arguments: {...updates, 'id': workOrderId},
    );
  }

  @override
  Future<void> deleteWorkOrder({required String workOrderId}) async {
    final ditto = _dittoOrThrow('deleteWorkOrder');

    // Cascade to the child outputs: the actual-outputs stream is branch-wide,
    // so orphans would keep inflating the variance-by-reason breakdown with no
    // work order left to clear them from.
    await ditto.store.transaction((txn) async {
      await txn.execute(
        'DELETE FROM actual_outputs WHERE workOrderId = :id',
        arguments: {'id': workOrderId},
      );
      await txn.execute(
        'DELETE FROM work_orders WHERE (_id = :id OR id = :id)',
        arguments: {'id': workOrderId},
      );
    });
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
        whereClauses.add('recordedAt >= :startDate');
        arguments['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        whereClauses.add('recordedAt <= :endDate');
        arguments['endDate'] = endDate.toIso8601String();
      }

      final query =
          "SELECT * FROM actual_outputs WHERE ${whereClauses.join(' AND ')}";

      final preparedAo = prepareDqlSyncSubscription(query, arguments);
      ditto.sync.registerSubscription(
        preparedAo.dql,
        arguments: preparedAo.arguments,
      );

      final result = await ditto.store.execute(query, arguments: arguments);

      return result.items.map((item) {
        return ActualOutput.fromJson(Map<String, dynamic>.from(item.value));
      }).toList();
    } catch (e) {
      talker.error('Error getting actual outputs from Capella: $e');
      return [];
    }
  }

  /// Sum of `actualQuantity` across the given docs, optionally substituting a
  /// new value for one of them (used when an existing output is edited).
  double _sumOutputs(
    Iterable<dynamic> items, {
    double seed = 0,
    String? overrideId,
    double? overrideQuantity,
  }) {
    return items.fold<double>(seed, (sum, item) {
      final row = Map<String, dynamic>.from(item.value);
      final id = (row['_id'] ?? row['id']) as String?;
      if (overrideId != null && id == overrideId) {
        return sum + (overrideQuantity ?? 0);
      }
      return sum + ((row['actualQuantity'] as num?)?.toDouble() ?? 0);
    });
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
    final ditto = _dittoOrThrow('recordActualOutput');

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

    // Sum what's already recorded and seed with the new quantity, so the
    // rollup needs no read-back of the document we're about to write.
    final existing = await ditto.store.execute(
      'SELECT * FROM actual_outputs WHERE workOrderId = :workOrderId',
      arguments: {'workOrderId': workOrderId},
    );
    final total = _sumOutputs(existing.items, seed: actualQuantity);

    final doc = await ActualOutputDittoAdapter.instance.toDittoDocument(output);
    final nowIso = DateTime.now().toUtc().toIso8601String();

    // One transaction so the two observers can't fire out of step and render a
    // frame where the variance breakdown moved but the total hasn't.
    await ditto.store.transaction((txn) async {
      await txn.execute(
        'INSERT INTO actual_outputs DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
        arguments: {'doc': doc},
      );
      await txn.execute(
        'UPDATE work_orders SET actualQuantity = :quantity, lastTouched = :lastTouched '
        'WHERE _id = :id OR id = :id',
        arguments: {'quantity': total, 'lastTouched': nowIso, 'id': workOrderId},
      );
    });

    return output;
  }

  @override
  Future<void> updateActualOutput({
    required String outputId,
    double? actualQuantity,
    String? varianceReason,
    String? notes,
  }) async {
    final ditto = _dittoOrThrow('updateActualOutput');

    final result = await ditto.store.execute(
      'SELECT * FROM actual_outputs WHERE (_id = :id OR id = :id) LIMIT 1',
      arguments: {'id': outputId},
    );
    if (result.items.isEmpty) return;
    final current = ActualOutput.fromJson(
      Map<String, dynamic>.from(result.items.first.value),
    );

    final updates = <String, dynamic>{};
    if (actualQuantity != null) updates['actualQuantity'] = actualQuantity;
    if (varianceReason != null) updates['varianceReason'] = varianceReason;
    if (notes != null) updates['notes'] = notes;
    if (updates.isEmpty) return;
    final nowIso = DateTime.now().toUtc().toIso8601String();
    updates['lastTouched'] = nowIso;

    // Re-sum the siblings rather than applying a delta: deltas compound any
    // drift, and both approaches need the same read.
    double? newTotal;
    if (actualQuantity != null && actualQuantity != current.actualQuantity) {
      final siblings = await ditto.store.execute(
        'SELECT * FROM actual_outputs WHERE workOrderId = :workOrderId',
        arguments: {'workOrderId': current.workOrderId},
      );
      newTotal = _sumOutputs(
        siblings.items,
        overrideId: outputId,
        overrideQuantity: actualQuantity,
      );
    }

    await ditto.store.transaction((txn) async {
      await txn.execute(
        'UPDATE actual_outputs SET ${_setClause(updates)} '
        'WHERE _id = :id OR id = :id',
        arguments: {...updates, 'id': outputId},
      );
      if (newTotal != null) {
        await txn.execute(
          'UPDATE work_orders SET actualQuantity = :quantity, lastTouched = :lastTouched '
          'WHERE _id = :id OR id = :id',
          arguments: {
            'quantity': newTotal,
            'lastTouched': nowIso,
            'id': current.workOrderId,
          },
        );
      }
    });
  }

  @override
  Stream<List<WorkOrder>> workOrdersStream({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final List<String> whereClauses = ['branchId = :branchId'];
    final Map<String, dynamic> arguments = {'branchId': branchId};

    if (startDate != null) {
      whereClauses.add('targetDate >= :startDate');
      arguments['startDate'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      whereClauses.add('targetDate <= :endDate');
      arguments['endDate'] = endDate.toIso8601String();
    }

    return _observeDitto<WorkOrder>(
      query: "SELECT * FROM work_orders WHERE ${whereClauses.join(' AND ')}",
      arguments: arguments,
      fromMap: WorkOrder.fromJson,
      label: 'workOrdersStream',
    );
  }

  @override
  Stream<List<ActualOutput>> actualOutputsStream({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final List<String> whereClauses = ['branchId = :branchId'];
    final Map<String, dynamic> arguments = {'branchId': branchId};

    if (startDate != null) {
      whereClauses.add('recordedAt >= :startDate');
      arguments['startDate'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      whereClauses.add('recordedAt <= :endDate');
      arguments['endDate'] = endDate.toIso8601String();
    }

    return _observeDitto<ActualOutput>(
      query: "SELECT * FROM actual_outputs WHERE ${whereClauses.join(' AND ')}",
      arguments: arguments,
      fromMap: ActualOutput.fromJson,
      label: 'actualOutputsStream',
    );
  }

  /// Live view of a Ditto query: subscribe for replication, observe for local
  /// changes, and seed the first emission from a one-shot read.
  ///
  /// The seed matters because `registerObserver` may not deliver an initial
  /// callback before the provider attaches its listener; without it a fresh
  /// listener would sit in `loading` until the next mutation.
  Stream<List<T>> _observeDitto<T>({
    required String query,
    required Map<String, dynamic> arguments,
    required T Function(Map<String, dynamic>) fromMap,
    required String label,
  }) {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return Stream.value(<T>[]);

    // Single-subscription on purpose: the observer and the seed both land
    // after an await, and a broadcast controller would drop whichever fires
    // before the provider attaches its listener.
    final controller = StreamController<List<T>>();
    dynamic observer;
    var observed = false;

    List<T> decode(Iterable<dynamic> items) => items
        .map<T>((item) => fromMap(Map<String, dynamic>.from(item.value)))
        .toList();

    () async {
      try {
        final prepared = prepareDqlSyncSubscription(query, arguments);
        await ditto.sync.registerSubscription(
          prepared.dql,
          arguments: prepared.arguments,
        );

        observer = ditto.store.registerObserver(
          query,
          arguments: arguments,
          onChange: (result) {
            if (controller.isClosed) return;
            observed = true;
            controller.add(decode(result.items));
          },
        );

        if (!observed) {
          final seed = await ditto.store.execute(query, arguments: arguments);
          if (!observed && !controller.isClosed) {
            controller.add(decode(seed.items));
          }
        }
      } catch (e, st) {
        talker.error('Capella $label failed: $e\n$st');
        if (!controller.isClosed) controller.add(<T>[]);
      }
    }();

    controller.onCancel = () async {
      await observer?.cancel();
      await controller.close();
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
