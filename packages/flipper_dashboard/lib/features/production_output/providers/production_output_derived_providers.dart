import 'package:flipper_models/providers/production_output_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_models/brick/models/work_order.model.dart';

import '../models/production_output_models.dart';

/// Number of days plotted by the variance chart, today inclusive.
const int kVarianceChartDays = 7;

const _kVarianceReasons = <String>[
  'machine',
  'material',
  'labor',
  'quality',
  'planning',
  'other',
];

/// Live KPI summary for the whole branch.
///
/// Derived from [workOrdersStreamProvider] / [actualOutputsStreamProvider]
/// rather than re-queried, so the header, the analytical cards and the table
/// can never disagree about what has been produced.
final productionSummaryProvider = Provider<AsyncValue<ProductionSummary>>((
  ref,
) {
  final workOrders = ref.watch(workOrdersStreamProvider);
  final outputs = ref.watch(actualOutputsStreamProvider);

  // Outputs only refine the variance-reason breakdown; don't hold the KPIs
  // hostage to that stream still loading.
  return workOrders.whenData(
    (orders) => summarizeWorkOrders(orders, outputs.asData?.value ?? const []),
  );
});

/// Live data for the variance chart: one point per day for the last
/// [kVarianceChartDays] days, bucketed by work-order target date.
final varianceChartDataProvider = Provider<AsyncValue<List<VarianceDataPoint>>>(
  (ref) {
    final now = DateTime.now();
    return ref
        .watch(workOrdersStreamProvider)
        .whenData((orders) => buildVarianceSeries(orders, now: now));
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

  final varianceByReason = <String, double>{for (final r in _kVarianceReasons) r: 0};
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
    variancePercentage: totalPlanned > 0 ? (variance / totalPlanned) * 100 : 0.0,
    efficiency: totalPlanned > 0 ? (totalActual / totalPlanned) * 100 : 0.0,
    totalOrders: totalOrders,
    completedOrders: completedOrders,
    completionRate: totalOrders > 0 ? (completedOrders / totalOrders) * 100 : 0.0,
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
    final local = wo.targetDate.toLocal();
    final day = DateTime(local.year, local.month, local.day);
    planned[day] = (planned[day] ?? 0) + wo.plannedQuantity;
    actual[day] = (actual[day] ?? 0) + wo.actualQuantity;
  }

  return List<VarianceDataPoint>.generate(days, (i) {
    final day = today.subtract(Duration(days: days - 1 - i));
    final p = planned[day] ?? 0;
    final a = actual[day] ?? 0;
    return VarianceDataPoint(
      date: day,
      planned: p,
      actual: a,
      variance: a - p,
    );
  });
}
