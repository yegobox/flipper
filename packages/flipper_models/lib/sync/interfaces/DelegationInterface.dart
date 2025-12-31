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

  /// Get list of devices by branchId
  Future<List<Device>> getDevicesByBranch({
    required String branchId,
  });
}
