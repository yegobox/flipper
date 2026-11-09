import 'package:flipper_models/sync/capella/mixins/stock_mixin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

import 'support/fake_ditto.dart';

/// Exercises the stock watchers of [CapellaStockMixin] against [FakeDitto].
class _StockSync with CapellaStockMixin {
  _StockSync(this.fake);

  final FakeDitto? fake;

  @override
  dynamic get dittoHandle => fake;

  @override
  Repository get repository => throw UnimplementedError();

  @override
  final Talker talker = Talker();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// The POS grid restarts these watchers on every search keystroke. Each start
/// registers a Ditto sync subscription; one never cancelled stays for the life
/// of the app, and Ditto's sync re-evaluates every one of them.
void main() {
  late FakeDitto ditto;
  late _StockSync sync;

  setUp(() {
    ditto = FakeDitto();
    sync = _StockSync(ditto);
  });

  test(
    'the batched watcher drops its subscription when the grid moves on',
    () async {
      for (var search = 0; search < 5; search++) {
        final sub = sync
            .watchStocksByIds(['s-$search', 'shared'])
            .listen((_) {});
        expect(ditto.sync.live, hasLength(1));
        await sub.cancel();
      }

      expect(ditto.sync.registered, hasLength(5));
      expect(ditto.sync.live, isEmpty);
      expect(ditto.store.liveObserverCount, 0);
    },
  );

  test(
    'the per-row watcher drops its subscription with its observer',
    () async {
      final rows = [
        for (var i = 0; i < 12; i++)
          sync.watchStockByVariantId(stockId: 'stock-$i').listen((_) {}),
      ];
      expect(ditto.sync.live, hasLength(12));

      for (final row in rows) {
        await row.cancel();
      }

      expect(ditto.sync.live, isEmpty);
      expect(ditto.store.liveObserverCount, 0);
    },
  );

  test(
    'no Ditto yet: both watchers give an empty value and register nothing',
    () async {
      final offline = _StockSync(null);

      expect(await offline.watchStocksByIds(['s-1']).first, isEmpty);
      expect(await offline.watchStockByVariantId(stockId: 's-1').first, isNull);
    },
  );
}
