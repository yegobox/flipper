import 'dart:async';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/branch_catalog_cloud_sync.dart';
import 'package:flipper_models/sync/interfaces/DelegationInterface.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_models/brick/models/all_models.dart';

mixin CapellaDelegationMixin implements DelegationInterface {
  DittoService get dittoService => DittoService.instance;
  static const String _collectionName = 'transaction_delegations';

  /// Logs observer/sync params plus a snapshot of local Ditto rows so you can
  /// compare against manual DQL in the Ditto debugger.
  Future<void> _logDelegationStreamDiagnostics({
    required dynamic ditto,
    required String? branchId,
    required String? status,
    required String onDeviceId,
    required String observerQuery,
    required Map<String, dynamic> observerArgs,
    required String syncQuery,
    required Map<String, dynamic> syncArgs,
  }) async {
    final lines = <String>[
      '[delegation-ditto] stream params:',
      '  branchId=$branchId',
      '  status=$status',
      '  onDeviceId(thisDeviceId)=$onDeviceId',
      '  selectedDelegationDeviceId(setting)=${ProxyService.box.selectedDelegationDeviceId()}',
      '  dittoDeviceName=${ditto.deviceName}',
      '  dittoReady=${dittoService.isReady()}',
      '  observerQuery=$observerQuery',
      '  observerArgs=$observerArgs',
      '  syncQuery=$syncQuery',
      '  syncArgs=$syncArgs',
      '  compare SQL:',
      "    SELECT * FROM $_collectionName WHERE branchId = '$branchId'"
      "${status != null ? " AND status = '$status'" : ''}"
      " AND selectedDelegationDeviceId = '$onDeviceId'",
    ];

    if (branchId == null) {
      talker.info(lines.join('\n'));
      return;
    }

    try {
      final branchRows = await ditto.store.execute(
        'SELECT * FROM $_collectionName WHERE branchId = :branchId',
        arguments: {'branchId': branchId},
      );
      lines.add('  branchLocalCount=${branchRows.items.length}');
      for (final doc in branchRows.items) {
        final row = Map<String, dynamic>.from(doc.value);
        lines.add(
          '    _id=${row['_id']} status=${row['status']} '
          'selectedDelegationDeviceId=${row['selectedDelegationDeviceId']} '
          'delegatedFromDevice=${row['delegatedFromDevice']}',
        );
      }

      final filteredRows = await ditto.store.execute(
        observerQuery,
        arguments: observerArgs,
      );
      lines.add('  observerLocalCount=${filteredRows.items.length}');
      for (final doc in filteredRows.items) {
        final row = Map<String, dynamic>.from(doc.value);
        lines.add(
          '    match _id=${row['_id']} status=${row['status']} '
          'selectedDelegationDeviceId=${row['selectedDelegationDeviceId']}',
        );
      }
    } catch (e, st) {
      lines.add('  diagnosticQueryError=$e');
      lines.add('  $st');
    }

    talker.info(lines.join('\n'));
  }

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
    try {
      final deviceId = dittoService.dittoInstance!.deviceName;
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
        'selectedDelegationDeviceId': selectedDelegationDeviceId,
      };

      final ditto = dittoService.dittoInstance!;
      await ensureBranchDelegationCloudSubscription(
        ditto: ditto,
        branchId: branchId,
      );

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
          '   Branch: $branchId, Receipt: $receiptType, From: $deviceId, Target deviceId: $selectedDelegationDeviceId');
    } catch (e) {
      debugPrint('❌ Error creating delegation: $e');
      rethrow;
    }
  }

  @override
  Stream<List<TransactionDelegation>> delegationsStream({
    String? branchId,
    String? status,
    required String onDeviceId,
  }) {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null || !dittoService.isReady()) {
        debugPrint(
          '❌ Ditto not ready for delegation monitoring '
          '(instance=${ditto != null})',
        );
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

      whereParts.add('selectedDelegationDeviceId = :onDeviceId');
      arguments['onDeviceId'] = onDeviceId;

      final whereClause =
          whereParts.isNotEmpty ? 'WHERE ${whereParts.join(' AND ')}' : '';

      final query = 'SELECT * FROM $_collectionName $whereClause';

      final syncQuery = branchId != null
          ? 'SELECT * FROM $_collectionName WHERE branchId = :branchId'
          : 'SELECT * FROM $_collectionName';
      final syncArgs = branchId != null
          ? <String, dynamic>{'branchId': branchId}
          : const <String, dynamic>{};

      talker.info(
        '[delegation-ditto] opening stream: branchId=$branchId status=$status '
        'onDeviceId=$onDeviceId observerQuery=$query observerArgs=$arguments',
      );

      // Initialize async to register subscription first
      () async {
        try {
          // Pull all branch delegations from Ditto mesh/cloud; filter by target
          // device locally in the observer (see branch_catalog_cloud_sync.dart).
          if (branchId != null) {
            await ensureBranchDelegationCloudSubscription(
              ditto: ditto,
              branchId: branchId,
            );
          }

          final preparedDel = prepareDqlSyncSubscription(syncQuery, syncArgs);
          await ditto.sync.registerSubscription(
            preparedDel.dql,
            arguments: preparedDel.arguments,
          );

          await _logDelegationStreamDiagnostics(
            ditto: ditto,
            branchId: branchId,
            status: status,
            onDeviceId: onDeviceId,
            observerQuery: query,
            observerArgs: arguments,
            syncQuery: syncQuery,
            syncArgs: syncArgs,
          );

          // Use registerObserver with initial data fetch
          final completer = Completer<List<TransactionDelegation>>();
          observer = ditto.store.registerObserver(
            query,
            arguments: arguments,
            onChange: (queryResult) {
              if (controller.isClosed) return;

              final delegations = queryResult.items.map((doc) {
                final data = Map<String, dynamic>.from(doc.value);
                return TransactionDelegation.fromJson(data);
              }).toList();

              // Complete on first data if not yet completed
              if (!completer.isCompleted) {
                completer.complete(delegations);
              }

              talker.info(
                '[delegation-ditto] observer update: branchId=$branchId '
                'onDeviceId=$onDeviceId status=$status count=${delegations.length}',
              );
              controller.add(delegations);
            },
          );

          // Wait for initial data or timeout
          await completer.future.timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              if (!completer.isCompleted) {
                debugPrint('⏱️ Timeout waiting for delegations');
                completer.complete([]);
              }
              return [];
            },
          );
        } catch (e) {
          debugPrint('❌ Error setting up delegations observer: $e');
          controller.add([]);
        }
      }();

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

  @override
  Future<void> updateDelegationStatus({
    required String transactionId,
    required String status,
    String? errorMessage,
  }) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        debugPrint('❌ Ditto not initialized: cannot update delegation status');
        return;
      }

      final now = DateTime.now().toIso8601String();
      final updateData = <String, dynamic>{
        'status': status,
        'updatedAt': now,
      };
      if (errorMessage != null) {
        updateData['errorMessage'] = errorMessage;
      }
      if (status == 'completed') {
        updateData['completedAt'] = now;
        updateData['processingDevice'] = ditto.deviceName;
      }
      if (status == 'processing') {
        updateData['processingDevice'] = ditto.deviceName;
      }

      final setFields =
          updateData.keys.map((key) => '$key = :$key').join(', ');
      await ditto.store.execute(
        'UPDATE $_collectionName SET $setFields WHERE _id = :transactionId',
        arguments: {
          'transactionId': transactionId,
          ...updateData,
        },
      );

      debugPrint('✅ Delegation status updated in Ditto: $transactionId → $status');
    } catch (e) {
      debugPrint('❌ Error updating delegation status: $e');
      rethrow;
    }
  }

  @override
  Future<List<Device>> getDevicesByBranch({
    required String branchId,
  }) {
    // Device pickers must use Brick/Supabase — Ditto `devices` is send-only
    // mesh state and often stale vs thisDeviceId after desktop re-registration.
    return ProxyService.getStrategy(Strategy.cloudSync).getDevicesByBranch(
      branchId: branchId,
    );
  }
}
