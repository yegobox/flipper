import 'package:flipper_models/providers/production_output_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_models/brick/models/actual_output.model.dart';
import 'package:supabase_models/brick/models/work_order.model.dart';

import '../models/production_output_models.dart';

/// Number of days plotted by the variance chart, the selected day inclusive.
const int kVarianceChartDays = 7;

const _kVarianceReasons = <String>[
  'machine',
  'material',
  'labor',
  'quality',
  'planning',
  'other',
];

/// Midnight of [date]'s local calendar day.
DateTime localDay(DateTime date) {
  final local = date.toLocal();
  return DateTime(local.year, local.month, local.day);
}

/// The day the Production Output screen is showing (local midnight). The
/// cards, the list and the chart all follow it, so they always count the same
/// orders. Starts at today each time the screen opens.
final productionDayProvider = StateProvider.autoDispose<DateTime>(
  (ref) => localDay(DateTime.now()),
);

/// What has been produced against each order: the higher of the total saved on
/// the order and the sum of its output records.
///
/// The saved total is rewritten by whichever till records last, so two tills
/// recording at once can leave it short; the records themselves are never
/// lost. The sum can only be short when some records haven't synced yet, and
/// then the saved total covers it. Old app versions still read the saved total,
/// so it is kept, not replaced.
List<WorkOrder> withOutputTotals(
  List<WorkOrder> workOrders,
  List<ActualOutput> outputs,
) {
  if (outputs.isEmpty) return workOrders;
  final recorded = <String, double>{};
  for (final output in outputs) {
    recorded[output.workOrderId] =
        (recorded[output.workOrderId] ?? 0) + output.actualQuantity;
  }
  return [
    for (final wo in workOrders)
      (recorded[wo.id] ?? 0) > wo.actualQuantity
          ? wo.copyWith(actualQuantity: recorded[wo.id])
          : wo,
  ];
}

/// The orders on screen for one day.
class ProductionDayOrders {
  const ProductionDayOrders({required this.due, required this.carriedOver});

  static const empty = ProductionDayOrders(due: [], carriedOver: []);

  /// Orders due on the day. These are what the cards count.
  final List<WorkOrder> due;

  /// Only when the day is today: orders due on an earlier day that are still
  /// planned or in progress. Listed so they aren't lost, never counted in the
  /// day's numbers (the daily email counts a day the same way).
  final List<WorkOrder> carriedOver;
}

/// Splits [workOrders] into what [day] shows. [today] is local midnight.
ProductionDayOrders ordersForDay(
  List<WorkOrder> workOrders, {
  required DateTime day,
  required DateTime today,
}) {
  final due = <WorkOrder>[];
  final carriedOver = <WorkOrder>[];
  for (final wo in workOrders) {
    final target = localDay(wo.targetDate);
    if (target == day) {
      due.add(wo);
    } else if (day == today &&
        target.isBefore(today) &&
        (wo.status == 'planned' || wo.status == 'in_progress')) {
      carriedOver.add(wo);
    }
  }
  carriedOver.sort((a, b) => a.targetDate.compareTo(b.targetDate));
  return ProductionDayOrders(due: due, carriedOver: carriedOver);
}

/// Work orders with their output totals applied ([withOutputTotals]).
final workOrdersWithTotalsProvider = Provider<AsyncValue<List<WorkOrder>>>((
  ref,
) {
  final outputs = ref.watch(actualOutputsStreamProvider).asData?.value;
  return ref
      .watch(workOrdersStreamProvider)
      .whenData((orders) => withOutputTotals(orders, outputs ?? const []));
});

/// The orders for [productionDayProvider]'s day.
final productionDayOrdersProvider = Provider<AsyncValue<ProductionDayOrders>>((
  ref,
) {
  final day = ref.watch(productionDayProvider);
  final today = localDay(DateTime.now());
  return ref
      .watch(workOrdersWithTotalsProvider)
      .whenData((orders) => ordersForDay(orders, day: day, today: today));
});

/// KPI summary for the orders due on the selected day. Variance reasons come
/// from the output records made that day, as in the daily email
/// (data-connector `production_daily.rs`).
final productionSummaryProvider = Provider<AsyncValue<ProductionSummary>>((
  ref,
) {
  final day = ref.watch(productionDayProvider);
  final outputs =
      ref.watch(actualOutputsStreamProvider).asData?.value ?? const [];
  return ref
      .watch(productionDayOrdersProvider)
      .whenData(
        (orders) => summarizeWorkOrders(
          orders.due,
          outputs.where((o) => localDay(o.recordedAt) == day).toList(),
        ),
      );
});

/// Variance chart: one point per day for the [kVarianceChartDays] days ending
/// on the selected day, bucketed by work-order target date.
final varianceChartDataProvider = Provider<AsyncValue<List<VarianceDataPoint>>>(
  (ref) {
    final day = ref.watch(productionDayProvider);
    return ref
        .watch(workOrdersWithTotalsProvider)
        .whenData((orders) => buildVarianceSeries(orders, now: day));
  },
);

/// Pure roll-up of work orders into the KPI shape the cards render.
ProductionSummary summarizeWorkOrders(
  List<WorkOrder> workOrders,
  List<dynamic> actualOutputs,
) {
  double totalPlanned = 0;
  double totalActual = 0;
  int completedOrders = 0;

  for (final wo in workOrders) {
    totalPlanned += wo.plannedQuantity;
    totalActual += wo.actualQuantity;
    if (wo.status == 'completed') completedOrders++;
  }

  final varianceByReason = <String, double>{
    for (final r in _kVarianceReasons) r: 0,
  };
  for (final output in actualOutputs) {
    final reason = (output.varianceReason as String?)?.toLowerCase();
    if (reason == null) continue;
    final key = varianceByReason.containsKey(reason) ? reason : 'other';
    varianceByReason[key] = varianceByReason[key]! + 1;
  }

  final totalOrders = workOrders.length;
  final variance = totalActual - totalPlanned;

  return ProductionSummary(
    totalPlanned: totalPlanned,
    totalActual: totalActual,
    variance: variance,
    variancePercentage: totalPlanned > 0
        ? (variance / totalPlanned) * 100
        : 0.0,
    efficiency: totalPlanned > 0 ? (totalActual / totalPlanned) * 100 : 0.0,
    totalOrders: totalOrders,
    completedOrders: completedOrders,
    completionRate: totalOrders > 0
        ? (completedOrders / totalOrders) * 100
        : 0.0,
    varianceByReason: varianceByReason,
  );
}

/// Buckets [workOrders] by local target date into the trailing
/// [kVarianceChartDays]-day series the chart expects, oldest first.
List<VarianceDataPoint> buildVarianceSeries(
  List<WorkOrder> workOrders, {
  required DateTime now,
  int days = kVarianceChartDays,
}) {
  final today = DateTime(now.year, now.month, now.day);

  final planned = <DateTime, double>{};
  final actual = <DateTime, double>{};
  for (final wo in workOrders) {
    final day = localDay(wo.targetDate);
    planned[day] = (planned[day] ?? 0) + wo.plannedQuantity;
    actual[day] = (actual[day] ?? 0) + wo.actualQuantity;
  }

  return List<VarianceDataPoint>.generate(days, (i) {
    final day = today.subtract(Duration(days: days - 1 - i));
    final p = planned[day] ?? 0;
    final a = actual[day] ?? 0;
    return VarianceDataPoint(date: day, planned: p, actual: a, variance: a - p);
  });
}
