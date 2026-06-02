import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:supabase_models/brick/models/variant.model.dart';
import 'package:flipper_models/providers/pos_cart_sync_tap.dart';
import 'package:test/test.dart';

/// Capella/Ditto: cart line must appear from memory in microseconds, not from stream I/O.
///
/// Run from `flipper/packages/flipper_models`:
/// `dart test test/pos_cart_tap_sync_perf_test.dart`
void main() {
  const pendingTxnId = 'txn-capella-pending-test';
  const variantId = 'var-tap-perf-1';

  late Variant variant;

  setUp(() {
    variant = Variant(
      id: variantId,
      name: 'Perf SKU',
      retailPrice: 1500,
      branchId: '1',
    );
  });

  group('empty cart → first tap (Capella-free display path)', () {
    test('shows optimistic ghost without Ditto stream rows', () {
      final items = simulatePosCartTapDisplaySync(
        variant: variant,
        pendingTransactionId: pendingTxnId,
      );

      expect(items, hasLength(1));
      expect(items.first.variantId, variantId);
      expect(items.first.qty, 1);
      expect(OptimisticCartIds.isOptimistic(items.first.id), isTrue);
      expect(items.first.transactionId, pendingTxnId);
    });

    test('uses bootstrap merge id while pending (never blocks on stream)', () {
      final optimistic = addOptimisticPendingLine(
        const OptimisticCartState(),
        transactionId: pendingTxnId,
        variant: variant,
      );

      final mergeTxnId = cartTransactionIdForMergeIds(
        pendingTransactionId: pendingTxnId,
        optimisticTransactionId: optimistic.activeTransactionId,
        preferBootstrapWhilePending: true,
      );

      expect(mergeTxnId, OptimisticCartBootstrap.txnId);

      final items = mergePosCartDisplayAfterTap(
        optimistic: optimistic,
        pendingTransactionId: pendingTxnId,
        // Simulates slow Capella stream — must be ignored on display path.
        streamItems: const [],
      );
      expect(items, hasLength(1));
    });

    test(
      'single tap+display under ${kPosCartTapDisplayMaxMicroseconds}µs',
      () {
        final sw = Stopwatch()..start();
        final items = simulatePosCartTapDisplaySync(
          variant: variant,
          pendingTransactionId: pendingTxnId,
        );
        sw.stop();

        expect(items, hasLength(1));
        expect(
          sw.elapsedMicroseconds,
          lessThan(kPosCartTapDisplayMaxMicroseconds),
          reason:
              'tap+display took ${sw.elapsedMicroseconds}µs; '
              'must stay in-memory (Capella persist is post-frame)',
        );
      },
    );

    test(
      'all $kPosCartTapDisplayIterations taps stay under '
      '${kPosCartTapDisplayMaxMicroseconds}µs',
      () {
        final elapsedMicros = <int>[];

        for (var i = 0; i < kPosCartTapDisplayIterations; i++) {
          final sw = Stopwatch()..start();
          final items = simulatePosCartTapDisplaySync(
            variant: variant,
            pendingTransactionId: pendingTxnId,
          );
          sw.stop();

          expect(items, hasLength(1));
          elapsedMicros.add(sw.elapsedMicroseconds);
          expect(
            sw.elapsedMicroseconds,
            lessThan(kPosCartTapDisplayMaxMicroseconds),
            reason: 'iteration $i took ${sw.elapsedMicroseconds}µs',
          );
        }

        final max = elapsedMicros.reduce((a, b) => a > b ? a : b);
        final sorted = [...elapsedMicros]..sort();
        final p50 = sorted[sorted.length ~/ 2];
        // ignore: avoid_print
        print(
          'pos_cart_tap_sync: p50=${p50}µs max=${max}µs '
          '(budget ${kPosCartTapDisplayMaxMicroseconds}µs, n=$kPosCartTapDisplayIterations)',
        );
      },
    );
  });
}
