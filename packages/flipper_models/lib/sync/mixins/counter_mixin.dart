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
    // build brick Counter to pass in to upsert
    for (Counter counter in counters) {
      counter.createdAt = DateTime.now().toUtc();
      counter.lastTouched = DateTime.now().toUtc();

      counter.curRcptNo = receiptSignature!.data?.rcptNo ?? 0;
      counter.totRcptNo = receiptSignature.data?.totRcptNo ?? 0;
      counter.invcNo = counter.invcNo! + 1;
      await repository.upsert(counter);

      /// also update sar
      // get the sar
      final sar = await getSar(branchId: counter.branchId!);
      if (sar != null) {
        sar.sarNo = sar.sarNo + 1;
        await repository.upsert(sar);
      } else {
        final sar = Sar(
          sarNo: counter.totRcptNo!,
          branchId: counter.branchId!,
        );
        await repository.upsert(sar);
      }
      // in erference https://github.com/GetDutchie/brick/issues/580#issuecomment-2845610769
      // Repository().sqliteProvider.upsert<Counter>(upCounter);
    }
  }

  Future<Sar?> getSar({required int branchId}) async {
    return (await repository.get<Sar>(
            query: brick.Query(where: [
      brick.Where('branchId').isExactly(branchId),
    ])))
        .firstOrNull;
  }
}
