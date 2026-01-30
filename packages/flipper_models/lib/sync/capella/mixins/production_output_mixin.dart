import 'dart:async';
import 'package:flipper_models/sync/interfaces/production_output_interface.dart';
import 'package:supabase_models/brick/models/work_order.model.dart';
import 'package:supabase_models/brick/models/actual_output.model.dart';

/// Capella (Ditto) implementation of ProductionOutputInterface
///
/// Provides production output functionality using the Ditto sync engine.
/// Following the pattern from CapellaProductMixin.
mixin CapellaProductionOutputMixin implements ProductionOutputInterface {
  @override
  Future<List<WorkOrder>> getWorkOrders({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    throw UnimplementedError(
      'getWorkOrders needs to be implemented for Capella',
    );
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
    throw UnimplementedError(
      'createWorkOrder needs to be implemented for Capella',
    );
  }

  @override
  Future<void> updateWorkOrder({
    required String workOrderId,
    double? plannedQuantity,
    String? status,
    String? notes,
  }) async {
    throw UnimplementedError(
      'updateWorkOrder needs to be implemented for Capella',
    );
  }

  @override
  Future<void> deleteWorkOrder({required String workOrderId}) async {
    throw UnimplementedError(
      'deleteWorkOrder needs to be implemented for Capella',
    );
  }

  @override
  Future<List<ActualOutput>> getActualOutputs({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
    String? workOrderId,
  }) async {
    throw UnimplementedError(
      'getActualOutputs needs to be implemented for Capella',
    );
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
    throw UnimplementedError(
      'recordActualOutput needs to be implemented for Capella',
    );
  }

  @override
  Future<void> updateActualOutput({
    required String outputId,
    double? actualQuantity,
    String? varianceReason,
    String? notes,
  }) async {
    throw UnimplementedError(
      'updateActualOutput needs to be implemented for Capella',
    );
  }

  @override
  Stream<List<WorkOrder>> workOrdersStream({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    throw UnimplementedError(
      'workOrdersStream needs to be implemented for Capella',
    );
  }

  @override
  Future<Map<String, dynamic>> getVarianceSummary({
    required String branchId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    throw UnimplementedError(
      'getVarianceSummary needs to be implemented for Capella',
    );
  }
}
