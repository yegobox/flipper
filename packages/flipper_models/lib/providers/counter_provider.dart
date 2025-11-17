import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_models/brick/models/counter.model.dart';

part 'counter_provider.g.dart';

@riverpod
Stream<List<Counter>> counters(Ref ref, int branchId) async* {
  ref.keepAlive();
  final capella = await ProxyService.getStrategy(Strategy.capella);
  yield* capella.listenCounters(branchId: branchId);
}

@riverpod
int highestCounter(Ref ref, int branchId) {
  final countersStream = ref.watch(countersProvider(branchId));
  return countersStream.when(
    data: (counters) {
      if (counters.isEmpty) {
        return 0;
      }
      // Filter out null invcNo values and extract non-null integers
      final validInvcNos = counters
          .where((counter) => counter.invcNo != null)
          .map((counter) => counter.invcNo as int)
          .toList();

      // Return 0 if no valid invcNo values exist
      if (validInvcNos.isEmpty) {
        return 0;
      }

      // Find and return the maximum value
      return validInvcNos.reduce((a, b) => a > b ? a : b);
    },
    loading: () => 0,
    error: (err, stack) => 0,
  );
}
