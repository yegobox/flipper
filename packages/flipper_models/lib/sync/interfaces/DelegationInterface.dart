import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:supabase_models/brick/models/all_models.dart';

abstract class DelegationInterface {
  Future<void> createDelegation({
    required String transactionId,
    required String branchId,
    required String receiptType,
    String? customerName,
    String? customerTin,
    String? customerBhfId,
    bool isAutoPrint = false,
    double? subTotal,
    String? paymentType,
    Map<String, dynamic>? additionalData,
    String? selectedDelegationDeviceId,
  });

  /// Watch delegations stream with optional filtering
  Stream<List<TransactionDelegation>> delegationsStream({
    String? branchId,
    String? status,
    required String onDeviceId,
  });

  /// Get list of devices by branchId.
  ///
  /// [getPolicy] defaults to [OfflineFirstGetPolicy.awaitRemoteWhenNoneExist].
  /// Delegation pickers should pass [OfflineFirstGetPolicy.awaitRemote] so the
  /// list is refreshed from Supabase instead of stale local-only rows.
  Future<List<Device>> getDevicesByBranch({
    required String branchId,
    OfflineFirstGetPolicy getPolicy =
        OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
  });

  /// Update delegation status in Ditto (delegated → processing → completed/failed).
  Future<void> updateDelegationStatus({
    required String transactionId,
    required String status,
    String? errorMessage,
  });
}
