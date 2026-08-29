import 'package:flipper_models/sync/interfaces/production_output_interface.dart';
import 'package:supabase_models/brick/models/work_order.model.dart';
import 'package:supabase_models/brick/models/actual_output.model.dart';

/// CoreSync (Brick) side of [ProductionOutputInterface] — intentionally inert.
///
/// Production output is **Ditto-only**: `CapellaProductionOutputMixin` owns
/// every read and write, and `SyncStrategy.getStrategy()` returns Capella
/// unconditionally, so nothing can reach these members today. They exist only
/// so `CoreSync` keeps satisfying `DatabaseSyncInterface`.
///
/// They throw rather than silently writing to Brick: a work order that landed
/// in Turso/Supabase without reaching Ditto would be invisible to the entire
/// feature, which is exactly the bug the Ditto-only cutover removed.
mixin ProductionOutputMixin implements ProductionOutputInterface {
  Never _dittoOnly(String member) => throw UnimplementedError(
        'Production output is Ditto-only; $member is served by '
        'CapellaProductionOutputMixin.',
      );

  @override
  Future<List<WorkOrder>> getWorkOrders({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async =>
      _dittoOnly('getWorkOrders');

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
  }) async =>
      _dittoOnly('createWorkOrder');

  @override
  Future<void> updateWorkOrder({
    required String workOrderId,
    double? plannedQuantity,
    String? status,
    String? notes,
  }) async =>
      _dittoOnly('updateWorkOrder');

  @override
  Future<void> deleteWorkOrder({required String workOrderId}) async =>
      _dittoOnly('deleteWorkOrder');

  @override
  Future<List<ActualOutput>> getActualOutputs({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
    String? workOrderId,
  }) async =>
      _dittoOnly('getActualOutputs');

  @override
  Future<ActualOutput?> recordActualOutput({
    required String workOrderId,
    required String branchId,
    required double actualQuantity,
    required String userId,
    String? varianceReason,
    String? notes,
  }) async =>
      _dittoOnly('recordActualOutput');

  @override
  Future<void> updateActualOutput({
    required String outputId,
    double? actualQuantity,
    String? varianceReason,
    String? notes,
  }) async =>
      _dittoOnly('updateActualOutput');

  @override
  Stream<List<WorkOrder>> workOrdersStream({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      _dittoOnly('workOrdersStream');

  @override
  Stream<List<ActualOutput>> actualOutputsStream({
    required String branchId,
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      _dittoOnly('actualOutputsStream');

  @override
  Future<Map<String, dynamic>> getVarianceSummary({
    required String branchId,
    required DateTime startDate,
    required DateTime endDate,
  }) async =>
      _dittoOnly('getVarianceSummary');
}
