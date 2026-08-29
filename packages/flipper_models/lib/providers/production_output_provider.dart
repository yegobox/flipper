import 'package:flipper_models/SyncStrategy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/work_order.model.dart';
import 'package:supabase_models/brick/models/actual_output.model.dart';

/// Parameters for fetching work orders
class WorkOrdersParams {
  final String? branchId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? status;

  const WorkOrdersParams({
    this.branchId,
    this.startDate,
    this.endDate,
    this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkOrdersParams &&
          runtimeType == other.runtimeType &&
          branchId == other.branchId &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          status == other.status;

  @override
  int get hashCode =>
      branchId.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      status.hashCode;
}

/// Parameters for variance summary
class VarianceSummaryParams {
  final String? branchId;
  final DateTime startDate;
  final DateTime endDate;

  const VarianceSummaryParams({
    this.branchId,
    required this.startDate,
    required this.endDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VarianceSummaryParams &&
          runtimeType == other.runtimeType &&
          branchId == other.branchId &&
          startDate == other.startDate &&
          endDate == other.endDate;

  @override
  int get hashCode => branchId.hashCode ^ startDate.hashCode ^ endDate.hashCode;
}

/// Live work orders for the active branch, backed by a Ditto observer.
///
/// Everything on the production dashboard derives from this one stream. Writes
/// are Ditto-native and committed before `createWorkOrder` returns, so the
/// observer fires for local edits immediately; the stream also carries changes
/// made on other devices without anyone hitting refresh.
///
/// Deliberately unfiltered by date: `targetDate` windows are applied by the
/// derived providers below, which keeps one observer per branch instead of one
/// per window and lets a work order move between windows without a refetch.
final workOrdersStreamProvider = StreamProvider<List<WorkOrder>>((ref) {
  final branchId = ProxyService.box.getBranchId() ?? '';
  if (branchId.isEmpty) return Stream.value(<WorkOrder>[]);

  return ProxyService.getStrategy(Strategy.capella)
      .workOrdersStream(branchId: branchId)
      .map((rows) => rows.cast<WorkOrder>().toList())
      .handleError((_) => <WorkOrder>[]);
});

/// Live actual-output records for the active branch.
///
/// Work orders already carry the rolled-up `actualQuantity`; this stream is what
/// keeps the variance-by-reason breakdown current.
final actualOutputsStreamProvider = StreamProvider<List<ActualOutput>>((ref) {
  final branchId = ProxyService.box.getBranchId() ?? '';
  if (branchId.isEmpty) return Stream.value(<ActualOutput>[]);

  return ProxyService.getStrategy(Strategy.capella)
      .actualOutputsStream(branchId: branchId)
      .map((rows) => rows.cast<ActualOutput>().toList())
      .handleError((_) => <ActualOutput>[]);
});

/// True when [date] falls on the same calendar day as [now] in local time.
bool isSameLocalDay(DateTime date, DateTime now) {
  final local = date.toLocal();
  return local.year == now.year &&
      local.month == now.month &&
      local.day == now.day;
}

/// Provider for today's work orders — a live view over [workOrdersStreamProvider].
final todayWorkOrdersProvider = Provider<AsyncValue<List<WorkOrder>>>((ref) {
  final now = DateTime.now();
  return ref.watch(workOrdersStreamProvider).whenData(
        (workOrders) => workOrders
            .where((wo) => isSameLocalDay(wo.targetDate, now))
            .toList(),
      );
});

/// Provider for this week's variance summary
final weeklyVarianceSummaryProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final branchId = ProxyService.box.getBranchId() ?? '';
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 7));

  try {
    return await ProxyService.getStrategy(Strategy.capella).getVarianceSummary(
      branchId: branchId,
      startDate: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      endDate: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day),
    );
  } catch (e) {
    return <String, dynamic>{
      'totalPlanned': 0.0,
      'totalActual': 0.0,
      'variance': 0.0,
      'variancePercentage': 0.0,
      'efficiency': 0.0,
      'totalOrders': 0,
      'completedOrders': 0,
      'completionRate': 0.0,
      'varianceByReason': <String, double>{},
    };
  }
});
