import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

const _txnId = 'txn-real-123';

Variant _variant(String id) => Variant(
      id: id,
      name: 'SKU $id',
      retailPrice: 1000,
      branchId: 'branch-1',
    );

TransactionItem _persisted(String variantId, {required double qty}) =>
    TransactionItem(
      id: 'ti-$variantId',
      ttCatCd: 'TT',
      name: 'SKU $variantId',
      qty: qty,
      price: 1000,
      discount: 0,
      prc: 1000,
      branchId: 'branch-1',
      transactionId: _txnId,
      variantId: variantId,
    );

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  OptimisticCart notifier() => container.read(optimisticCartProvider.notifier);
  OptimisticCartState state() => container.read(optimisticCartProvider);

  group('deferred reconciliation', () {
    test('an emission inside the grace window is replayed, not dropped',
        () async {
      notifier().addPendingLine(transactionId: _txnId, variant: _variant('v1'));
      expect(state().pendingQtyByVariantId['v1'], 1);

      // The save lands well inside the 250ms grace — the common case, since the
      // persist starts two frames after the tap.
      notifier().onStreamEmitted(
        transactionId: _txnId,
        items: [_persisted('v1', qty: 1)],
      );

      // Still pending: the grace has not expired yet.
      expect(state().pendingQtyByVariantId['v1'], 1);

      await Future<void>.delayed(const Duration(milliseconds: 400));

      // Replayed once the window closed — this used to stay pending forever
      // until some unrelated Ditto mutation arrived.
      expect(state().pendingQtyByVariantId.containsKey('v1'), isFalse);
      expect(state().lastStreamQtySumByVariantId['v1'], 1);
    });

    test('a tap during the wait pushes the replay out rather than clearing it',
        () async {
      notifier().addPendingLine(transactionId: _txnId, variant: _variant('v1'));
      notifier().onStreamEmitted(
        transactionId: _txnId,
        items: [_persisted('v1', qty: 1)],
      );

      await Future<void>.delayed(const Duration(milliseconds: 150));
      // Second tap at ~150ms: pending is now 2 and the grace restarts, so the
      // replay must slide from ~250ms out to ~400ms rather than firing early.
      notifier().addPendingLine(transactionId: _txnId, variant: _variant('v1'));

      await Future<void>.delayed(const Duration(milliseconds: 120));
      // ~270ms: past the original deadline, still inside the restarted one.
      expect(state().pendingQtyByVariantId['v1'], 2);

      await Future<void>.delayed(const Duration(milliseconds: 300));
      // ~570ms: the buffered emission only covers the first save, so `inc`
      // accounts for exactly one unit and the second tap stays pending.
      expect(state().pendingQtyByVariantId['v1'], 1);

      notifier().onStreamEmitted(
        transactionId: _txnId,
        items: [_persisted('v1', qty: 2)],
      );
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(state().pendingQtyByVariantId.containsKey('v1'), isFalse);
      expect(state().lastStreamQtySumByVariantId['v1'], 2);
    });

    test('an emission outside the grace window still reconciles immediately',
        () {
      notifier().bindPendingTransaction(_txnId);
      notifier().onStreamEmitted(
        transactionId: _txnId,
        items: [_persisted('v1', qty: 3)],
      );
      expect(state().lastStreamQtySumByVariantId['v1'], 3);
    });
  });

  group('mutations across the bootstrap -> real id bind', () {
    test('rollbackPending works when the caller holds the real id', () {
      notifier().addPendingLine(
        transactionId: OptimisticCartBootstrap.txnId,
        variant: _variant('v1'),
      );
      expect(state().activeTransactionId, OptimisticCartBootstrap.txnId);

      // Callers that resolved the id from the pending-transaction providers
      // hand over the real id; strict equality made this a silent no-op.
      notifier().rollbackPending(transactionId: _txnId, variantId: 'v1');

      expect(state().pendingQtyByVariantId.containsKey('v1'), isFalse);
      expect(state().variantSnapshotByVariantId.containsKey('v1'), isFalse);
    });

    test('rollbackPending works when the caller holds the bootstrap sentinel',
        () {
      notifier().addPendingLine(transactionId: _txnId, variant: _variant('v1'));
      expect(state().activeTransactionId, _txnId);

      // posCartMergeTxnIdProvider returns the sentinel while qty is pending.
      notifier().rollbackPending(
        transactionId: OptimisticCartBootstrap.txnId,
        variantId: 'v1',
      );

      expect(state().pendingQtyByVariantId.containsKey('v1'), isFalse);
    });

    test('clearPendingForVariant survives the same mismatch', () {
      notifier().addPendingLine(
        transactionId: OptimisticCartBootstrap.txnId,
        variant: _variant('v1'),
      );
      notifier().clearPendingForVariant(
        transactionId: _txnId,
        variantId: 'v1',
      );
      expect(state().pendingQtyByVariantId.containsKey('v1'), isFalse);
    });

    test('an unrelated cart id is still rejected', () {
      notifier().addPendingLine(transactionId: _txnId, variant: _variant('v1'));
      notifier().rollbackPending(
        transactionId: 'some-other-sale',
        variantId: 'v1',
      );
      expect(state().pendingQtyByVariantId['v1'], 1);
    });
  });

  group('two adds for one variant (tile tap, then + on the ghost row)', () {
    test('settle at exactly the persisted qty, never above it', () async {
      // `+` on a ghost re-runs the catalog-tap path, so the second add is just
      // a second addPendingLine + a second queued persist. saveTransactionItem
      // does select-then-insert-or-update behind the persist lock, so Ditto
      // ends at 2 — the display must land on 2 as well, not 3.
      notifier().addPendingLine(transactionId: _txnId, variant: _variant('v1'));
      notifier().addPendingLine(transactionId: _txnId, variant: _variant('v1'));
      expect(state().pendingQtyByVariantId['v1'], 2);

      notifier().onStreamEmitted(
        transactionId: _txnId,
        items: [_persisted('v1', qty: 2)],
      );
      await Future<void>.delayed(const Duration(milliseconds: 400));

      expect(state().pendingQtyByVariantId.containsKey('v1'), isFalse);
      expect(state().lastStreamQtySumByVariantId['v1'], 2);

      // The merged cart the checkout renders (and completion reads) must agree.
      final merged = mergeTransactionItemsWithOptimisticCart(
        streamItems: [_persisted('v1', qty: 2)],
        optimistic: state(),
        transactionId: _txnId,
      );
      expect(merged, hasLength(1));
      expect(merged.single.qty, 2);
      expect(OptimisticCartIds.isOptimistic(merged.single.id), isFalse);
    });

    test('while only the first save has landed, display stays at the pending sum',
        () async {
      notifier().addPendingLine(transactionId: _txnId, variant: _variant('v1'));
      notifier().addPendingLine(transactionId: _txnId, variant: _variant('v1'));

      notifier().onStreamEmitted(
        transactionId: _txnId,
        items: [_persisted('v1', qty: 1)],
      );
      await Future<void>.delayed(const Duration(milliseconds: 400));

      // One unit confirmed, one still in flight.
      expect(state().pendingQtyByVariantId['v1'], 1);
      final merged = mergeTransactionItemsWithOptimisticCart(
        streamItems: [_persisted('v1', qty: 1)],
        optimistic: state(),
        transactionId: _txnId,
      );
      expect(merged.single.qty, 2);
    });
  });

  group('cancelling a queued add (the `-` on a not-yet-saved line)', () {
    test('cancels exactly one add and takes back exactly one unit', () {
      notifier().noteAddInFlight('v1');
      notifier().addPendingLine(transactionId: _txnId, variant: _variant('v1'));
      expect(state().hasCancellableAdd('v1'), isTrue);

      expect(notifier().cancelInFlightAdd('v1'), isTrue);
      notifier().rollbackPending(transactionId: _txnId, variantId: 'v1');

      expect(state().pendingQtyByVariantId.containsKey('v1'), isFalse);
      // Nothing left to cancel, so the button must go back to disabled.
      expect(state().hasCancellableAdd('v1'), isFalse);

      // The persist consumes it and skips its write.
      expect(notifier().consumeCancelledAdd('v1'), isTrue);
      notifier().noteAddSettled('v1');
      expect(state().cancelledAddsByVariantId.containsKey('v1'), isFalse);
      expect(state().inFlightAddsByVariantId.containsKey('v1'), isFalse);
    });

    test('cannot cancel more adds than are queued', () {
      notifier().noteAddInFlight('v1');
      expect(notifier().cancelInFlightAdd('v1'), isTrue);
      // Second `-` has nothing to abort: the write would restore the qty, so
      // refusing here is what stops the cart lying about it.
      expect(notifier().cancelInFlightAdd('v1'), isFalse);
    });

    test('a save that already ran leaves no token for a later add to consume',
        () {
      notifier().noteAddInFlight('v1');
      notifier().noteAddSettled('v1');
      expect(state().hasCancellableAdd('v1'), isFalse);
      expect(notifier().cancelInFlightAdd('v1'), isFalse);
      expect(notifier().consumeCancelledAdd('v1'), isFalse);

      // A brand new tap is therefore never silently swallowed.
      notifier().noteAddInFlight('v1');
      expect(notifier().consumeCancelledAdd('v1'), isFalse);
    });

    test('two queued adds, one cancelled: the other still saves', () {
      notifier().noteAddInFlight('v1');
      notifier().addPendingLine(transactionId: _txnId, variant: _variant('v1'));
      notifier().noteAddInFlight('v1');
      notifier().addPendingLine(transactionId: _txnId, variant: _variant('v1'));
      expect(state().pendingQtyByVariantId['v1'], 2);

      expect(notifier().cancelInFlightAdd('v1'), isTrue);
      notifier().rollbackPending(transactionId: _txnId, variantId: 'v1');
      expect(state().pendingQtyByVariantId['v1'], 1);

      // First persist aborts, second writes.
      expect(notifier().consumeCancelledAdd('v1'), isTrue);
      notifier().noteAddSettled('v1');
      expect(notifier().consumeCancelledAdd('v1'), isFalse);
      notifier().noteAddSettled('v1');
      expect(state().inFlightAddsByVariantId.containsKey('v1'), isFalse);
    });

    test('counters survive a cart clear so a stale token cannot leak forward',
        () {
      notifier().noteAddInFlight('v1');
      notifier().addPendingLine(transactionId: _txnId, variant: _variant('v1'));
      notifier().cancelInFlightAdd('v1');

      notifier().clearForTransaction(_txnId);

      expect(state().pendingQtyByVariantId, isEmpty);
      expect(state().activeTransactionId, isNull);
      // The persist for that add is still running; it must still find its token.
      expect(notifier().consumeCancelledAdd('v1'), isTrue);
      notifier().noteAddSettled('v1');
      expect(state().inFlightAddsByVariantId.containsKey('v1'), isFalse);
    });
  });

  group('ghost line id -> variant recovery', () {
    test('round-trips a real transaction id', () {
      final id = OptimisticCartIds.ghostLineId(
        transactionId: _txnId,
        variantId: 'var-abc',
      );
      expect(OptimisticCartIds.variantIdOf(id), 'var-abc');
    });

    test('round-trips the bootstrap sentinel', () {
      final id = OptimisticCartIds.ghostLineId(
        transactionId: OptimisticCartBootstrap.txnId,
        variantId: 'var-abc',
      );
      expect(OptimisticCartIds.variantIdOf(id), 'var-abc');
    });

    test('returns null for a real row id', () {
      expect(OptimisticCartIds.variantIdOf('ti-1234'), isNull);
    });
  });
}
