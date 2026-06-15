import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/sync/interfaces/counter_interface.dart';
import 'package:brick_offline_first/brick_offline_first.dart' as brick;
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_models/sync/utils/rra_sar_sequence.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/models/sars.model.dart';
import 'package:talker/talker.dart';

mixin CounterMixin implements CounterInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<Counter?> getCounter(
      {required String branchId,
      required String receiptType,
      required bool fetchRemote}) async {
    final query = brick.Query(where: [
      brick.Where('branchId').isExactly(branchId),
      brick.Where('receiptType').isExactly(receiptType),
    ]);
    final counter = await repository.get<Counter>(
        query: query,
        policy: fetchRemote == true
            ? brick.OfflineFirstGetPolicy.awaitRemoteWhenNoneExist
            : brick.OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    return counter.firstOrNull;
  }

  @override
  Future<List<Counter>> getCounters(
      {required String branchId, bool fetchRemote = false}) async {
    final query =
        brick.Query(where: [brick.Where('branchId').isExactly(branchId)]);
    final counters = await repository.get<Counter>(
        query: query,
        policy: fetchRemote == true
            ? brick.OfflineFirstGetPolicy.awaitRemoteWhenNoneExist
            : brick.OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);

    return counters;
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

    // Use receiptSignature as the source of truth for receipt numbers
    final newCurRcptNo = receiptSignature.data?.rcptNo ?? 0;
    final newTotRcptNo = receiptSignature.data?.totRcptNo ?? 0;

    final highestInvcNo = counters.isEmpty
        ? 0
        : counters.map((c) => c.invcNo ?? 0).reduce((a, b) => a > b ? a : b);
    final newInvcNo = (consumedInvcNo != null && consumedInvcNo > 0)
        ? consumedInvcNo + 1
        : highestInvcNo + 1;

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

      await repository.upsert(counter, skipDittoSync: true);
    }

    // NOTE: Do NOT write Sar.sarNo here. `sarNo` is the stock-movement (Stock
    // Activity Report) sequence, owned by the stock-in/out paths
    // (addVariant -> getSar+1; refunds -> getSar+1; sales use the invoice no.).
    // Overwriting it with the receipt counter (totRcptNo) corrupts that sequence
    // and makes RRA reject later stock-in (saveStockItems sarTyCd "06").
  }

  Future<Sar?> getSar({required String branchId}) async {
    return resolveSarForBranch(
      repository: repository,
      branchId: branchId,
      ditto: DittoService.instance.dittoInstance,
    );
  }

  Stream<List<Counter>> listenCounters({required String branchId}) {
    // TODO: implement a safe repository-backed stream/polling observer
    throw UnsupportedError(
        'Streaming is not supported by this strategy. Please use a repository-backed stream or polling observer.');
  }
}
