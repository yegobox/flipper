import 'dart:async';

import 'package:flipper_models/providers/stock_value_report_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('formatStockQty', () {
    test('whole numbers read exactly as before', () {
      for (final q in [0.0, 5.0, 12.0, 1500.0, -3.0]) {
        expect(formatStockQty(q), q.toStringAsFixed(0));
      }
    });

    test('fractional stock is kept, trailing zeros trimmed', () {
      expect(formatStockQty(0.4), '0.4');
      expect(formatStockQty(0.45), '0.45');
      expect(formatStockQty(2.125), '2.125');
      expect(formatStockQty(2.1250001), '2.125');
      expect(formatStockQty(7.5), '7.5');
    });
  });

  group('invalidateSelfOnceReady', () {
    late StreamController<int?> source;
    late StreamProvider<int?> sourceProvider;
    late FutureProvider<int> watched;
    late int builds;

    setUp(() {
      builds = 0;
      source = StreamController<int?>.broadcast();
      sourceProvider = StreamProvider<int?>((ref) => source.stream);
      watched = FutureProvider<int>((ref) async {
        builds++;
        // Like the report: only the first (incomplete) build listens.
        if (builds == 1) {
          invalidateSelfOnceReady<int?>(ref, sourceProvider, (v) => v != null);
        }
        return builds;
      });
    });

    tearDown(() => source.close());

    Future<void> settle() => Future<void>.delayed(Duration.zero);

    test('reruns exactly once, when the source becomes ready', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final sub = container.listen(watched, (_, __) {});
      addTearDown(sub.close);

      await container.read(watched.future);
      expect(builds, 1);

      source.add(null);
      await settle();
      expect(builds, 1, reason: 'not ready yet');

      source.add(3);
      await settle();
      await container.read(watched.future);
      expect(builds, 2);

      source.add(4);
      await settle();
      expect(builds, 2, reason: 'only once');
    });

    test('a source that is already ready reruns at once', () async {
      final container = ProviderContainer(
        overrides: [sourceProvider.overrideWithValue(const AsyncData(7))],
      );
      addTearDown(container.dispose);
      final sub = container.listen(watched, (_, __) {});
      addTearDown(sub.close);

      await container.read(watched.future);
      await settle();
      await container.read(watched.future);
      expect(builds, 2);
    });
  });
}
