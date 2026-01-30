import 'dart:async';

/// Interface for production output operations (SAP-inspired Work Order concept)
///
/// This interface defines methods for managing work orders (production plans)
/// and recording actual production output, following patterns from ProductInterface.
abstract class ProductionOutputInterface {
  /// Get work orders for a branch within a date range
  Future<List<dynamic>> getWorkOrders({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  });

  /// Create a new work order
  Future<dynamic> createWorkOrder({
    required String branchId,
    required String businessId,
    required String variantId,
    required double plannedQuantity,
    required DateTime targetDate,
    String? shiftId,
    String? notes,
  });

  /// Update an existing work order
  Future<void> updateWorkOrder({
    required String workOrderId,
    double? plannedQuantity,
    String? status,
    String? notes,
  });

  /// Delete a work order
  Future<void> deleteWorkOrder({required String workOrderId});

  /// Get actual output records for a branch
  Future<List<dynamic>> getActualOutputs({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
    String? workOrderId,
  });

  /// Record actual production output
  Future<dynamic> recordActualOutput({
    required String workOrderId,
    required String branchId,
    required double actualQuantity,
    required String userId,
    String? varianceReason,
    String? notes,
  });

  /// Update an actual output record
  Future<void> updateActualOutput({
    required String outputId,
    double? actualQuantity,
    String? varianceReason,
    String? notes,
  });

  /// Stream of work orders for real-time updates
  Stream<List<dynamic>> workOrdersStream({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get variance summary for a period
  Future<Map<String, dynamic>> getVarianceSummary({
    required String branchId,
    required DateTime startDate,
    required DateTime endDate,
  });
}
