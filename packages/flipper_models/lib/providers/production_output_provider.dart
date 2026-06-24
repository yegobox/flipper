import 'package:flipper_models/SyncStrategy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/work_order.model.dart';

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

/// Provider for today's work orders
final todayWorkOrdersProvider = FutureProvider<List<WorkOrder>>((ref) async {
  final branchId = ProxyService.box.getBranchId() ?? '';
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  try {
    final workOrders = await ProxyService.getStrategy(Strategy.capella)
        .getWorkOrders(
          branchId: branchId,
          startDate: startOfDay,
          endDate: endOfDay,
        );
    return workOrders.cast<WorkOrder>().toList();
  } catch (e) {
    return <WorkOrder>[];
  }
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
