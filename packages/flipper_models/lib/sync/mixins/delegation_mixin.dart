import 'dart:async';

import 'package:flipper_models/sync/interfaces/DelegationInterface.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/models/all_models.dart';

mixin DelegationMixin implements DelegationInterface {
  DittoService get dittoService => DittoService.instance;

  @override
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
  }) async {
    throw UnimplementedError();
  }

  @override
  Stream<List<TransactionDelegation>> delegationsStream({
    String? branchId,
    String? status,
    required String onDeviceId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<Device>> getDevicesByBranch({
    required String branchId,
  }) {
    throw UnimplementedError();
  }
}
