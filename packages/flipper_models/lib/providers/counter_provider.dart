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
      // Sort by invcNo descending and take the first
      final sortedCounters = [...counters];
      sortedCounters.sort((a, b) => b.invcNo!.compareTo(a.invcNo!));
      return sortedCounters.first.invcNo!;
    },
    loading: () => 0,
    error: (err, stack) => 0,
  );
}
