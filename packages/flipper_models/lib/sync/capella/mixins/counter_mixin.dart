import 'dart:async';
import 'dart:math' as math;

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/sync/interfaces/counter_interface.dart';
import 'package:flipper_models/sync/branch_catalog_cloud_sync.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaCounterMixin implements CounterInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<Counter?> getCounter(
      {required String branchId,
      required String receiptType,
      required bool fetchRemote}) async {
    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) return null;

    final result = await ditto.store.execute(
      "SELECT * FROM counters WHERE branchId = :branchId AND receiptType = :receiptType LIMIT 1",
      arguments: {"branchId": branchId, "receiptType": receiptType},
    );

    if (result.items.isEmpty) return null;

    final data = Map<String, dynamic>.from(result.items.first.value);
    return Counter(
      id: data['id'],
      branchId: data['branchId'],
      curRcptNo: data['curRcptNo'],
      totRcptNo: data['totRcptNo'],
      invcNo: data['invcNo'],
      businessId: data['businessId'],
      createdAt:
          data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
      lastTouched: data['lastTouched'] != null
          ? DateTime.parse(data['lastTouched'])
          : null,
      receiptType: data['receiptType'],
      bhfId: data['bhfId'] ?? '',
    );
  }

  @override
  Future<List<Counter>> getCounters(
      {required String branchId, bool fetchRemote = false}) async {
    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) return [];

    final result = await ditto.store.execute(
      "SELECT * FROM counters WHERE branchId = :branchId",
      arguments: {"branchId": branchId},
    );

    return result.items.map((doc) {
      final data = Map<String, dynamic>.from(doc.value);
      return Counter(
        id: data['id'],
        branchId: data['branchId'],
        curRcptNo: data['curRcptNo'],
        totRcptNo: data['totRcptNo'],
        invcNo: data['invcNo'],
        businessId: data['businessId'],
        createdAt: data['createdAt'] != null
            ? DateTime.parse(data['createdAt'])
            : null,
        lastTouched: data['lastTouched'] != null
            ? DateTime.parse(data['lastTouched'])
            : null,
        receiptType: data['receiptType'],
        bhfId: data['bhfId'] ?? '',
      );
    }).toList();
  }

  @override
  Future<void> updateCounters({
    required List<Counter> counters,
    RwApiResponse? receiptSignature,
    int? consumedInvcNo,
  }) async {
    if (counters.isEmpty && consumedInvcNo == null) return;

    if (receiptSignature == null) {
      talker.warning("receiptSignature is null, skipping counter update.");
      return;
    }

    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) {
      talker.warning('Ditto not initialized, skipping counter update.');
      return;
    }

    final branchId = counters.isNotEmpty
        ? counters.first.branchId
        : ProxyService.box.getBranchId();
    if (branchId == null || branchId.isEmpty) {
      talker.warning('updateCounters: missing branchId, skipping.');
      return;
    }

    final countersToWrite = await getCounters(
      branchId: branchId,
      fetchRemote: false,
    );
    if (countersToWrite.isEmpty) {
      talker.warning('updateCounters: no Ditto counters for branch $branchId');
      return;
    }

    // Use receiptSignature as the source of truth for receipt numbers
    final newCurRcptNo = receiptSignature.data?.rcptNo ?? 0;
    final newTotRcptNo = receiptSignature.data?.totRcptNo ?? 0;

    final dittoMaxInvc = countersToWrite.fold<int>(
      0,
      (prev, c) => math.max(prev, c.invcNo ?? 0),
    );
    final int newInvcNo;
    if (consumedInvcNo != null && consumedInvcNo > 0) {
      newInvcNo = math.max(consumedInvcNo + 1, dittoMaxInvc);
    } else {
      newInvcNo = dittoMaxInvc + 1;
    }

    final now = DateTime.now().toUtc();

    // Update all counters to the same values
    for (final counter in countersToWrite) {
      if (counter.branchId == null) {
        talker.warning("Counter with null branchId found, skipping.");
        continue;
      }
      counter.createdAt = now;
      counter.lastTouched = now;
      counter.curRcptNo = newCurRcptNo;
      counter.totRcptNo = newTotRcptNo;
      counter.invcNo = newInvcNo;

      final doc = counter.toDittoDocument();
      await ditto.store.execute(
        'INSERT INTO counters DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
        arguments: {'doc': doc},
      );
    }

    // NOTE: Do NOT write Sar.sarNo here. `sarNo` is the stock-movement (Stock
    // Activity Report) sequence, owned by the stock-in/out paths
    // (addVariant -> getSar+1; refunds -> getSar+1; sales use the invoice no.).
    // Overwriting it with the receipt counter (totRcptNo) corrupts that sequence
    // and makes RRA reject later stock-in (saveStockItems sarTyCd "06").
  }

  Stream<List<Counter>> listenCounters({required String branchId}) {
    try {
      final ditto = DittoService.instance.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized');
        return Stream.value([]);
      }

      final controller = StreamController<List<Counter>>.broadcast();
      dynamic observer;

      unawaited(
        ensureBranchCounterCloudSubscription(ditto: ditto, branchId: branchId),
      );

      observer = ditto.store.registerObserver(
        'SELECT * FROM counters WHERE branchId = :branchId',
        arguments: {'branchId': branchId},
        onChange: (queryResult) {
          if (controller.isClosed) return;

          final counters = queryResult.items.map((doc) {
            final data = Map<String, dynamic>.from(doc.value);
            return Counter(
              id: data['id'],
              branchId: data['branchId'],
              curRcptNo: data['curRcptNo'],
              totRcptNo: data['totRcptNo'],
              invcNo: data['invcNo'],
              businessId: data['businessId'],
              createdAt: data['createdAt'] != null
                  ? DateTime.parse(data['createdAt'])
                  : null,
              lastTouched: data['lastTouched'] != null
                  ? DateTime.parse(data['lastTouched'])
                  : null,
              receiptType: data['receiptType'],
              bhfId: data['bhfId'] ?? '',
            );
          }).toList();

          controller.add(counters);
        },
      );

      controller.onCancel = () async {
        await observer?.cancel();
        await controller.close();
      };

      return controller.stream;
    } catch (e) {
      talker.error('Error watching counters: $e');
      return Stream.value([]);
    }
  }
}
