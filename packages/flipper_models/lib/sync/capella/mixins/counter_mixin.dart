import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/sync/interfaces/counter_interface.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:supabase_models/brick/models/sars.model.dart';
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
  Future<void> updateCounters(
      {required List<Counter> counters,
      RwApiResponse? receiptSignature}) async {
    if (counters.isEmpty) return;

    if (receiptSignature == null) {
      talker.warning("receiptSignature is null, skipping counter update.");
      return;
    }

    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) {
      talker.warning('Ditto not initialized, skipping counter update.');
      return;
    }

    // Use receiptSignature as the source of truth for receipt numbers
    final newCurRcptNo = receiptSignature.data?.rcptNo ?? 0;
    final newTotRcptNo = receiptSignature.data?.totRcptNo ?? 0;

    // Find the highest invoice number and increment it
    final highestInvcNo =
        counters.map((c) => c.invcNo ?? 0).reduce((a, b) => a > b ? a : b);
    final newInvcNo = highestInvcNo + 1;

    final Set<String> uniqueBranchIds = {};
    final now = DateTime.now().toUtc();

    // Update all counters to the same values
    for (Counter counter in counters) {
      if (counter.branchId == null) {
        talker.warning("Counter with null branchId found, skipping.");
        continue;
      }
      counter.createdAt = now;
      counter.lastTouched = now;
      counter.curRcptNo = newCurRcptNo;
      counter.totRcptNo = newTotRcptNo;
      counter.invcNo = newInvcNo;

      final doc =
          await CounterDittoAdapter.instance.toDittoDocument(counter);
      await ditto.store.execute(
        'INSERT INTO counters DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
        arguments: {'doc': doc},
      );
      uniqueBranchIds.add(counter.branchId!);
    }

    // Update SAR once per unique branch
    for (final branchId in uniqueBranchIds) {
      final sar = await _getSarFromDitto(branchId: branchId);
      if (sar != null) {
        await _upsertSarInDitto(
          sar.copyWith(sarNo: newTotRcptNo),
        );
      } else {
        await _upsertSarInDitto(
          Sar(
            id: 'sar_$branchId',
            sarNo: newTotRcptNo,
            branchId: branchId,
            createdAt: now,
          ),
        );
      }
    }
  }

  Future<Sar?> _getSarFromDitto({required String branchId}) async {
    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) return null;

    final result = await ditto.store.execute(
      'SELECT * FROM sars WHERE branchId = :branchId ORDER BY sarNo DESC LIMIT 1',
      arguments: {'branchId': branchId},
    );
    if (result.items.isEmpty) return null;

    final data = Map<String, dynamic>.from(result.items.first.value);
    final id = data['id'] ?? data['_id'];
    if (id == null) return null;

    return Sar(
      id: id.toString(),
      sarNo: (data['sarNo'] as num?)?.toInt() ?? 0,
      branchId: branchId,
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'].toString()) ?? DateTime.now().toUtc()
          : DateTime.now().toUtc(),
    );
  }

  Future<void> _upsertSarInDitto(Sar sar) async {
    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) {
      talker.warning('Ditto not initialized, skipping SAR upsert.');
      return;
    }

    await ditto.store.execute(
      'INSERT INTO sars DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {
        'doc': {
          '_id': sar.id,
          'id': sar.id,
          'branchId': sar.branchId,
          'sarNo': sar.sarNo,
          'createdAt': sar.createdAt.toIso8601String(),
        },
      },
    );
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

      final preparedCnt = prepareDqlSyncSubscription(
        "SELECT * FROM counters WHERE branchId = :branchId",
        {'branchId': branchId},
      );
      ditto.sync.registerSubscription(
        preparedCnt.dql,
        arguments: preparedCnt.arguments,
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
