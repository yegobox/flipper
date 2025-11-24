import 'package:supabase_models/brick/models/transaction_delegation.model.dart';

abstract class DelegationInterface {
  Future<void> createDelegation({
    required String transactionId,
    required int branchId,
    required String receiptType,
    String? customerName,
    String? customerTin,
    String? customerBhfId,
    bool isAutoPrint = false,
    double? subTotal,
    String? paymentType,
    Map<String, dynamic>? additionalData,
  });

  /// Watch delegations stream with optional filtering
  Stream<List<TransactionDelegation>> delegationsStream({
    int? branchId,
    String? status,
  });
}
