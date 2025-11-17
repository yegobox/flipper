import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/sync/interfaces/counter_interface.dart';
import 'package:brick_offline_first/brick_offline_first.dart' as brick;
import 'package:supabase_models/brick/repository.dart';
import 'package:supabase_models/brick/models/sars.model.dart';
import 'package:talker/talker.dart';

mixin CounterMixin implements CounterInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<Counter?> getCounter(
      {required int branchId,
      required String receiptType,
      required bool fetchRemote}) async {
    final query = brick.Query(where: [
      brick.Where('branchId').isExactly(branchId),
      brick.Where('receiptType').isExactly(receiptType),
    ]);
    final counter = await repository.get<Counter>(
        query: query,
        policy: fetchRemote == true
            ? brick.OfflineFirstGetPolicy.alwaysHydrate
            : brick.OfflineFirstGetPolicy.localOnly);
    return counter.firstOrNull;
  }

  @override
  Future<List<Counter>> getCounters(
      {required int branchId, bool fetchRemote = false}) async {
    final query =
        brick.Query(where: [brick.Where('branchId').isExactly(branchId)]);
    final counters = await repository.get<Counter>(
        query: query,
        policy: fetchRemote == true
            ? brick.OfflineFirstGetPolicy.alwaysHydrate
            : brick.OfflineFirstGetPolicy.localOnly);

    return counters;
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

    // Use receiptSignature as the source of truth for receipt numbers
    final newCurRcptNo = receiptSignature.data?.rcptNo ?? 0;
    final newTotRcptNo = receiptSignature.data?.totRcptNo ?? 0;

    // Find the highest invoice number and increment it
    final highestInvcNo =
        counters.map((c) => c.invcNo ?? 0).reduce((a, b) => a > b ? a : b);
    final newInvcNo = highestInvcNo + 1;

    final Set<int> uniqueBranchIds = {};

    // Update all counters to the same values
    for (Counter counter in counters) {
      if (counter.branchId == null) {
        talker.warning("Counter with null branchId found, skipping.");
        continue;
      }
      counter.createdAt = DateTime.now().toUtc();
      counter.lastTouched = DateTime.now().toUtc();
      counter.curRcptNo = newCurRcptNo;
      counter.totRcptNo = newTotRcptNo;
      counter.invcNo = newInvcNo;

      await repository.upsert(counter);
      uniqueBranchIds.add(counter.branchId!);
    }

    // Update SAR once per unique branch
    for (final branchId in uniqueBranchIds) {
      final sar = await getSar(branchId: branchId);
      if (sar != null) {
        sar.sarNo = newTotRcptNo;
        await repository.upsert(sar);
      } else {
        final newSar = Sar(
          sarNo: newTotRcptNo,
          branchId: branchId,
        );
        await repository.upsert(newSar);
      }
    }
  }

  Future<Sar?> getSar({required int branchId}) async {
    return (await repository.get<Sar>(
            query: brick.Query(where: [
      brick.Where('branchId').isExactly(branchId),
    ])))
        .firstOrNull;
  }

  Stream<List<Counter>> listenCounters({required int branchId}) {
    // TODO: implement a safe repository-backed stream/polling observer
    throw UnsupportedError(
        'Streaming is not supported by this strategy. Please use a repository-backed stream or polling observer.');
  }
}
