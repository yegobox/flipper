// Verifies the instant cart clear on sale completion at the provider source.
//
// posCartDisplayItemsProvider feeds every cart consumer (list, totals, count
// badges). When a sale completes, _onQuickSellComplete sets
// suppressedCartTransactionIdProvider to the sold transaction id so the cart
// shows empty in the same frame — instead of lingering until the Ditto
// stream / pending providers reconcile. The reconciliation provider clears the
// flag once a different pending transaction becomes active (the next sale).
//
// Run from `flipper/packages/flipper_dashboard`:
//   flutter test test/pos_cart_display_suppression_test.dart --dart-define=FLUTTER_TEST_ENV=true

import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'test_helpers/mocks.dart';
import 'test_helpers/setup.dart';

const _branchId = '1';

ITransaction _pendingTxn(String id) => ITransaction(
      id: id,
      branchId: _branchId,
      status: PENDING,
      transactionType: 'sale',
      paymentType: 'CASH',
      cashReceived: 0,
      customerChangeDue: 0,
      updatedAt: DateTime.now().toUtc(),
      isIncome: true,
      isExpense: false,
      agentId: 'agent-test',
      subTotal: 0,
    );

TransactionItem _item(String id, String txnId) => TransactionItem(
      id: id,
      name: 'Item $id',
      qty: 1,
      price: 100,
      discount: 0,
      prc: 100,
      ttCatCd: 'B',
      active: true,
      transactionId: txnId,
      branchId: _branchId,
    );

/// Renders the cart line count. Does NOT watch the reconciliation provider, so
/// it isolates the suppression short-circuit in [posCartDisplayItemsProvider].
class _CartCountHarness extends ConsumerWidget {
  const _CartCountHarness();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lines = ref.watch(posCartDisplayItemsProvider);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text('count:${lines.length}'),
    );
  }
}

/// Watches the reconciliation provider so the suppression-clear-on-next-sale
/// wiring runs (it lives in [posCartStreamReconciliationProvider]).
class _ReconHarness extends ConsumerWidget {
  const _ReconHarness();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(posCartStreamReconciliationProvider, (_, __) {});
    ref.watch(posCartDisplayItemsProvider);
    return const SizedBox.shrink();
  }
}

/// Primes the cart to [ticket] exactly once — the resume / till-collect entry
/// point ([_resumeOrder] in tickets_list.dart) — then renders the cart count.
class _PrimeOnceHarness extends ConsumerStatefulWidget {
  const _PrimeOnceHarness({required this.ticket});

  final ITransaction ticket;

  @override
  ConsumerState<_PrimeOnceHarness> createState() => _PrimeOnceHarnessState();
}

class _PrimeOnceHarnessState extends ConsumerState<_PrimeOnceHarness> {
  bool _primed = false;

  // Not initState: WidgetRef.container reads an inherited widget, which is only
  // legal once dependencies are available.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_primed) return;
    _primed = true;
    primePosCartForTransactionWidget(
      ref,
      isExpense: false,
      transaction: widget.ticket,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lines = ref.watch(posCartDisplayItemsProvider);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text('count:${lines.length}'),
    );
  }
}

void main() {
  late TestEnvironment env;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupPathProviderMock();
    env = TestEnvironment();
    await env.init();
  });

  tearDownAll(() async {
    await env.dispose();
  });

  setUp(() {
    env.injectMocks();
    env.stubCommonMethods();
    when(() => env.mockBox.isOrdering()).thenReturn(false);
  });

  tearDown(() {
    env.restore();
  });

  ProviderContainer containerForTxn(
    ITransaction txn,
    List<TransactionItem> items,
  ) {
    return ProviderContainer(
      overrides: [
        cachedPendingCartTransactionProvider(false).overrideWith((ref) => txn),
        pendingTransactionStreamProvider(isExpense: false)
            .overrideWith((ref) => Stream<ITransaction>.value(txn)),
        transactionItemsStreamProvider(
          transactionId: txn.id,
          branchId: _branchId,
        ).overrideWith((ref) => Stream<List<TransactionItem>>.value(items)),
      ],
    );
  }

  testWidgets('cart clears the instant the sold transaction is suppressed',
      (tester) async {
    final txn = _pendingTxn('txn-complete-1');
    final container = containerForTxn(txn, [
      _item('a', txn.id),
      _item('b', txn.id),
    ]);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const _CartCountHarness(),
      ),
    );
    await tester.pump();
    expect(find.text('count:2'), findsOneWidget);

    // Sale completes — even though the items stream still holds the lines.
    container.read(suppressedCartTransactionIdProvider.notifier).state = txn.id;
    await tester.pump();

    expect(
      find.text('count:0'),
      findsOneWidget,
      reason: 'the sold cart must be empty in the same frame',
    );
  });

  testWidgets('suppressing an unrelated id does not hide the active cart',
      (tester) async {
    final txn = _pendingTxn('txn-active-1');
    final container = containerForTxn(txn, [_item('a', txn.id)]);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const _CartCountHarness(),
      ),
    );
    await tester.pump();
    expect(find.text('count:1'), findsOneWidget);

    // Stale suppression for some other transaction must not blank this cart.
    container.read(suppressedCartTransactionIdProvider.notifier).state =
        'some-other-txn';
    await tester.pump();

    expect(find.text('count:1'), findsOneWidget);
  });

  // A resumed parked ticket pins the cart to it (primePosCartForTransaction).
  // The pin outranks the pending-cart cache in
  // posCartPendingTransactionIdProvider and — unlike that cache — is never
  // re-validated against the transaction's status, so a pin left behind on a
  // completed sale keeps resolving the cart to its (still active) lines. That is
  // the "cart never cleared until I restarted the app" report: the pin provider
  // is not autoDispose, so only a relaunch drops it.
  group('stale cart pin on a completed sale', () {
    const nextBranchId = _branchId;

    ProviderContainer containerForSoldAndNext({
      required ITransaction sold,
      required List<TransactionItem> soldItems,
      required ITransaction next,
    }) {
      return ProviderContainer(
        overrides: [
          // Completion primes the cache with the *next* pending cart.
          cachedPendingCartTransactionProvider(false)
              .overrideWith((ref) => next),
          pendingTransactionStreamProvider(isExpense: false)
              .overrideWith((ref) => Stream<ITransaction>.value(next)),
          transactionItemsStreamProvider(
            transactionId: sold.id,
            branchId: nextBranchId,
          ).overrideWith((ref) => Stream<List<TransactionItem>>.value(soldItems)),
          transactionItemsStreamProvider(
            transactionId: next.id,
            branchId: nextBranchId,
          ).overrideWith(
            (ref) => Stream<List<TransactionItem>>.value(const []),
          ),
        ],
      );
    }

    testWidgets(
        'clearing the pin keeps the sold lines away when suppression releases',
        (tester) async {
      final sold = _pendingTxn('txn-sold-1');
      final next = _pendingTxn('txn-next-1');
      final container = containerForSoldAndNext(
        sold: sold,
        soldItems: [_item('a', sold.id), _item('b', sold.id)],
        next: next,
      );
      addTearDown(container.dispose);

      // Resume pinned the cart to the ticket now being sold.
      container.read(pinnedPosCartTransactionIdProvider.notifier).state =
          sold.id;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const _CartCountHarness(),
        ),
      );
      await tester.pump();
      expect(find.text('count:2'), findsOneWidget);

      // Sale completes: suppress the sold id and drop its now-stale pin.
      container.read(suppressedCartTransactionIdProvider.notifier).state =
          sold.id;
      expect(
        clearPinnedPosCartTransactionIfContainer(
          container,
          transactionId: sold.id,
        ),
        isTrue,
        reason: 'the pin still pointed at the sold transaction',
      );
      await tester.pump();
      expect(find.text('count:0'), findsOneWidget);

      // Completion releases suppression once the next pending cart is bound.
      container.read(suppressedCartTransactionIdProvider.notifier).state = null;
      await tester.pump();

      expect(
        find.text('count:0'),
        findsOneWidget,
        reason: 'without the pin the cart resolves the empty next pending cart, '
            'so the sold lines must not come back',
      );
    });

    testWidgets('a pin left on the sold sale resurrects its lines',
        (tester) async {
      final sold = _pendingTxn('txn-sold-2');
      final next = _pendingTxn('txn-next-2');
      final container = containerForSoldAndNext(
        sold: sold,
        soldItems: [_item('a', sold.id)],
        next: next,
      );
      addTearDown(container.dispose);

      container.read(pinnedPosCartTransactionIdProvider.notifier).state =
          sold.id;
      container.read(suppressedCartTransactionIdProvider.notifier).state =
          sold.id;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const _CartCountHarness(),
        ),
      );
      await tester.pump();
      expect(find.text('count:0'), findsOneWidget);

      // Suppression alone is not enough — this is the regression being guarded.
      container.read(suppressedCartTransactionIdProvider.notifier).state = null;
      // Two pumps: suppression short-circuited the provider before it ever
      // subscribed to the sold items stream, so releasing it starts that
      // subscription (loading) and the value lands on the following frame.
      await tester.pump();
      await tester.pump();

      expect(
        find.text('count:1'),
        findsOneWidget,
        reason: 'documents why completion must unwind the pin, not just suppress',
      );
    });

    test('the guarded clear leaves an unrelated pin alone', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(pinnedPosCartTransactionIdProvider.notifier).state =
          'txn-other';

      expect(
        clearPinnedPosCartTransactionIfContainer(
          container,
          transactionId: 'txn-sold-3',
        ),
        isFalse,
      );
      expect(
        container.read(pinnedPosCartTransactionIdProvider),
        'txn-other',
        reason: 'a pin for another transaction (e.g. mobile checkout) must stay',
      );
      expect(
        clearPinnedPosCartTransactionIfContainer(
          container,
          transactionId: '',
        ),
        isFalse,
      );
    });
  });

  // Resuming a parked ticket makes that ticket both the pinned cart and the
  // emitted pending row. `syncPendingTransaction` only releases suppression for a
  // *different* pending id, so suppression left over from the park / send-to-till
  // that hid the ticket earlier can never be released again — the resumed cart
  // renders empty until the app restarts. Priming the cart must drop it.
  group('resuming a suppressed ticket', () {
    ProviderContainer containerForResumedTicket(
      ITransaction ticket,
      List<TransactionItem> items,
    ) {
      return ProviderContainer(
        overrides: [
          // Send-to-till cleared the pending-cart cache; after resume the ticket
          // is the only PENDING row left for this device+agent.
          cachedPendingCartTransactionProvider(false).overrideWith((ref) => null),
          pendingTransactionStreamProvider(isExpense: false)
              .overrideWith((ref) => Stream<ITransaction>.value(ticket)),
          transactionItemsStreamProvider(
            transactionId: ticket.id,
            branchId: _branchId,
          ).overrideWith((ref) => Stream<List<TransactionItem>>.value(items)),
        ],
      );
    }

    testWidgets('reconciliation cannot release suppression on the resumed id',
        (tester) async {
      final ticket = _pendingTxn('txn-ticket-1');
      final container = containerForResumedTicket(ticket, [_item('a', ticket.id)]);
      addTearDown(container.dispose);

      // Left behind by the send-to-till that parked this ticket.
      container.read(suppressedCartTransactionIdProvider.notifier).state =
          ticket.id;
      // Resume pinned the cart to the ticket.
      container.read(pinnedPosCartTransactionIdProvider.notifier).state =
          ticket.id;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const _ReconHarness(),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(
        container.read(suppressedCartTransactionIdProvider),
        ticket.id,
        reason: 'the guard needs a different pending id, so nothing clears it',
      );
      expect(
        container.read(posCartDisplayItemsProvider),
        isEmpty,
        reason: 'this is the empty cart after resume that was reported',
      );
    });

    testWidgets('priming the cart releases suppression so the lines render',
        (tester) async {
      final ticket = _pendingTxn('txn-ticket-2');
      final container = containerForResumedTicket(ticket, [
        _item('a', ticket.id),
        _item('b', ticket.id),
      ]);
      addTearDown(container.dispose);

      container.read(suppressedCartTransactionIdProvider.notifier).state =
          ticket.id;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: _PrimeOnceHarness(ticket: ticket),
        ),
      );
      // Prime defers to a microtask; let it land and the cart rebuild.
      await tester.pump();
      await tester.pump();

      expect(container.read(suppressedCartTransactionIdProvider), isNull);
      expect(
        container.read(pinnedPosCartTransactionIdProvider),
        ticket.id,
        reason: 'the resumed ticket is still the pinned cart',
      );
      expect(find.text('count:2'), findsOneWidget);
    });

    test('the guarded clear leaves suppression for another sale alone', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(suppressedCartTransactionIdProvider.notifier).state =
          'txn-just-sold';

      expect(
        clearSuppressedCartTransactionIfContainer(
          container,
          transactionId: 'txn-ticket-3',
        ),
        isFalse,
      );
      expect(
        container.read(suppressedCartTransactionIdProvider),
        'txn-just-sold',
        reason: 'a sale completed elsewhere must stay suppressed',
      );
      expect(
        clearSuppressedCartTransactionIfContainer(
          container,
          transactionId: '',
        ),
        isFalse,
      );
    });
  });

  testWidgets(
      'reconciliation clears suppression once the next sale becomes active',
      (tester) async {
    final nextTxn = _pendingTxn('txn-next-2');
    final container = containerForTxn(nextTxn, const []);
    addTearDown(container.dispose);

    // A previous sale was suppressed.
    container.read(suppressedCartTransactionIdProvider.notifier).state =
        'txn-completed-1';

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const _ReconHarness(),
      ),
    );
    // Let the reconciliation listener fire + its microtask run.
    await tester.pump();
    await tester.pump();

    expect(
      container.read(suppressedCartTransactionIdProvider),
      isNull,
      reason: 'a different active pending sale should release the flag',
    );
  });
}
