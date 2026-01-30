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

/// Provider for today's work orders
final todayWorkOrdersProvider = FutureProvider<List<WorkOrder>>((ref) async {
  // ignore: unused_local_variable
  final branchId = ProxyService.box.getBranchId() ?? '';
  // ignore: unused_local_variable
  final now = DateTime.now();
  // ignore: unused_local_variable
  final startOfDay = DateTime(now.year, now.month, now.day);
  // ignore: unused_local_variable
  final endOfDay = startOfDay.add(const Duration(days: 1));

  // Use the service-level production output methods
  // These are mixed into the strategy via ProductionOutputMixin
  try {
    // ignore: unused_local_variable
    final strategy = ProxyService.strategy;
    // For now, return empty list until interface is fully connected
    return <WorkOrder>[];
  } catch (e) {
    return <WorkOrder>[];
  }
});

/// Provider for this week's variance summary
final weeklyVarianceSummaryProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final now = DateTime.now();
  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 7));

  try {
    // For now, return empty map until interface is fully connected
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
  } catch (e) {
    return <String, dynamic>{};
  }
});
