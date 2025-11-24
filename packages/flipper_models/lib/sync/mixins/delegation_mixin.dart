import 'dart:async';

import 'package:flipper_models/sync/interfaces/DelegationInterface.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_models/brick/models/all_models.dart';

mixin DelegationMixin implements DelegationInterface {
  DittoService get dittoService => DittoService.instance;
  static const String _collectionName = 'transaction_delegations';

  @override
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
  }) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        debugPrint('❌ Ditto not initialized');
        return;
      }
      final deviceId = ditto.deviceName;
      final now = DateTime.now().toIso8601String();

      final delegationData = {
        '_id': transactionId,
        'transactionId': transactionId,
        'id': transactionId,
        'branchId': branchId,
        'status': 'delegated',
        'receiptType': receiptType,
        'delegatedAt': now,
        'delegatedFromDevice': deviceId,
        'customerName': customerName,
        'customerTin': customerTin,
        'customerBhfId': customerBhfId,
        'isAutoPrint': isAutoPrint,
        'subTotal': subTotal,
        'paymentType': paymentType,
        'updatedAt': now,
        'additionalData': additionalData,
      };

      // Use DQL INSERT with conflict resolution (upsert)
      await ditto.store.execute(
        "INSERT INTO $_collectionName DOCUMENTS (:delegation) ON ID CONFLICT DO UPDATE",
        arguments: {
          "delegation": delegationData,
        },
      );

      debugPrint(
          '✅ Delegation created in Ditto: $transactionId (status: delegated)');
      debugPrint(
          '   Branch: $branchId, Receipt: $receiptType, Device: $deviceId');
    } catch (e) {
      debugPrint('❌ Error creating delegation: $e');
      rethrow;
    }
  }

  @override
  Stream<List<TransactionDelegation>> delegationsStream({
    int? branchId,
    String? status,
  }) {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        debugPrint('❌ Ditto not initialized');
        return Stream.value([]);
      }

      final controller =
          StreamController<List<TransactionDelegation>>.broadcast();
      dynamic observer;

      // Build query with optional filters
      final whereParts = <String>[];
      final arguments = <String, dynamic>{};

      if (branchId != null) {
        whereParts.add('branchId = :branchId');
        arguments['branchId'] = branchId;
      }

      if (status != null) {
        whereParts.add('status = :status');
        arguments['status'] = status;
      }

      final whereClause =
          whereParts.isNotEmpty ? 'WHERE ${whereParts.join(' AND ')}' : '';

      final query = 'SELECT * FROM $_collectionName $whereClause';

      debugPrint('🔍 Watching delegations with query: $query');
      debugPrint('   Arguments: $arguments');

      observer = ditto.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (queryResult) {
          if (controller.isClosed) return;

          final delegations = queryResult.items.map((doc) {
            final data = Map<String, dynamic>.from(doc.value);
            return TransactionDelegation.fromJson(data);
          }).toList();

          debugPrint(
              '📋 Delegations stream updated: ${delegations.length} records');
          controller.add(delegations);
        },
      );

      controller.onCancel = () async {
        debugPrint('🛑 Delegations stream cancelled');
        await observer?.cancel();
        await controller.close();
      };

      return controller.stream;
    } catch (e) {
      debugPrint('❌ Error watching delegations: $e');
      return Stream.value([]);
    }
  }
}
