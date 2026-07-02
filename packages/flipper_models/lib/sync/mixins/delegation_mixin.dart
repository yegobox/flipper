import 'dart:async';

import 'package:brick_offline_first/brick_offline_first.dart' as brick;
import 'package:flipper_models/sync/interfaces/DelegationInterface.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:supabase_models/brick/repository.dart';

mixin DelegationMixin implements DelegationInterface {
  Repository get repository;
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
  }) async {
    final query = brick.Query(
      where: [brick.Where('branchId').isExactly(branchId)],
    );
    return await repository.get<Device>(
      query: query,
      policy: brick.OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
  }

  @override
  Future<void> updateDelegationStatus({
    required String transactionId,
    required String status,
    String? errorMessage,
  }) {
    throw UnimplementedError();
  }
}
