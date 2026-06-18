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
