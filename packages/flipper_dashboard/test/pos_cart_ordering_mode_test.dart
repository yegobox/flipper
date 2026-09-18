// Verifies the ordering (purchase) cart and the ordering button agree.
//
// Both the preview list and the "Preview cart (n)" button are fed by
// posCartDisplayItemsProvider (the button through posCartSummaryProvider). That
// provider is keepAlive and used to read ProxyService.box.isOrdering() straight
// from its body, so the mode active the first time it built — POS checkout
// warms it with isExpense: false — stayed latched: after switching to ordering
// it kept resolving the *sale* pending cart, and the purchase cart rendered
// empty while the button counted the purchase lines. posCartIsExpenseProvider
// makes the mode reactive; syncPosCartIsExpense* republishes the box value.
//
// Run from `flipper/packages/flipper_dashboard`:
//   flutter test test/pos_cart_ordering_mode_test.dart --dart-define=FLUTTER_TEST_ENV=true

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'test_helpers/mocks.dart';
import 'test_helpers/setup.dart';

const _branchId = '1';

ITransaction _pendingTxn(String id, {required bool isExpense}) => ITransaction(
      id: id,
      branchId: _branchId,
      status: PENDING,
      transactionType: isExpense ? 'purchase' : 'sale',
      paymentType: 'CASH',
      cashReceived: 0,
      customerChangeDue: 0,
      updatedAt: DateTime.now().toUtc(),
      isIncome: !isExpense,
      isExpense: isExpense,
      agentId: 'agent-test',
      subTotal: 0,
    );

TransactionItem _item(String id, String txnId, {num qty = 1}) =>
    TransactionItem(
      id: id,
      name: 'Item $id',
      qty: qty,
      price: 100,
      discount: 0,
      prc: 100,
      ttCatCd: 'B',
      active: true,
      transactionId: txnId,
      branchId: _branchId,
    );

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

  /// An empty sale cart plus a purchase cart holding [purchaseItems] — the state
  /// behind the report: POS open, then ordering entered and items added.
  ProviderContainer containerForBothCarts({
    required ITransaction sale,
    required ITransaction purchase,
    required List<TransactionItem> purchaseItems,
  }) {
    return ProviderContainer(
      overrides: [
        cachedPendingCartTransactionProvider(false).overrideWith((ref) => sale),
        cachedPendingCartTransactionProvider(true)
            .overrideWith((ref) => purchase),
        pendingTransactionStreamProvider(isExpense: false)
            .overrideWith((ref) => Stream<ITransaction>.value(sale)),
        pendingTransactionStreamProvider(isExpense: true)
            .overrideWith((ref) => Stream<ITransaction>.value(purchase)),
        transactionItemsStreamProvider(
          transactionId: sale.id,
          branchId: _branchId,
        ).overrideWith((ref) => Stream<List<TransactionItem>>.value(const [])),
        transactionItemsStreamProvider(
          transactionId: purchase.id,
          branchId: _branchId,
        ).overrideWith(
          (ref) => Stream<List<TransactionItem>>.value(purchaseItems),
        ),
      ],
    );
  }

  /// Keeps every stream the cart resolves through subscribed (Riverpod 3
  /// disposes a provider read without a listener) and lets `Stream.value`
  /// deliver.
  Future<void> subscribeAndSettle(
    ProviderContainer container, {
    required ITransaction sale,
    required ITransaction purchase,
  }) async {
    container.listen(posCartDisplayItemsProvider, (_, __) {});
    container.listen(
      pendingTransactionStreamProvider(isExpense: false),
      (_, __) {},
    );
    container.listen(
      pendingTransactionStreamProvider(isExpense: true),
      (_, __) {},
    );
    container.listen(
      transactionItemsStreamProvider(
        transactionId: sale.id,
        branchId: _branchId,
      ),
      (_, __) {},
    );
    container.listen(
      transactionItemsStreamProvider(
        transactionId: purchase.id,
        branchId: _branchId,
      ),
      (_, __) {},
    );
    for (var i = 0; i < 8; i++) {
      await Future<void>.delayed(Duration.zero);
    }
  }

  test('ordering mode rebinds the cart even after POS latched the sale cart',
      () async {
    final sale = _pendingTxn('txn-sale-1', isExpense: false);
    final purchase = _pendingTxn('txn-purchase-1', isExpense: true);
    final container = containerForBothCarts(
      sale: sale,
      purchase: purchase,
      purchaseItems: [
        _item('a', purchase.id),
        _item('b', purchase.id),
        _item('c', purchase.id, qty: 2),
      ],
    );
    addTearDown(container.dispose);

    // POS checkout builds the cart first, latching the sale cart.
    await subscribeAndSettle(container, sale: sale, purchase: purchase);
    expect(container.read(posCartDisplayItemsProvider), isEmpty);

    // Operator opens ordering: the box flips and the flip is published.
    when(() => env.mockBox.isOrdering()).thenReturn(true);
    syncPosCartIsExpenseContainer(container);
    await subscribeAndSettle(container, sale: sale, purchase: purchase);

    expect(
      container.read(posCartDisplayItemsProvider).map((i) => i.id),
      containsAll(<String>['a', 'b', 'c']),
      reason: 'the purchase cart must render its own lines in ordering mode',
    );
    // What the ordering button shows (OrderingView reads unitQtyTotal) must be
    // what the preview list holds — never a count over an empty cart.
    expect(container.read(posCartSummaryProvider).unitQtyTotal, 4);
  });

  test('leaving ordering hands the cart back to the sale side', () async {
    final sale = _pendingTxn('txn-sale-2', isExpense: false);
    final purchase = _pendingTxn('txn-purchase-2', isExpense: true);
    final container = containerForBothCarts(
      sale: sale,
      purchase: purchase,
      purchaseItems: [_item('a', purchase.id)],
    );
    addTearDown(container.dispose);

    when(() => env.mockBox.isOrdering()).thenReturn(true);
    await subscribeAndSettle(container, sale: sale, purchase: purchase);
    expect(container.read(posCartDisplayItemsProvider), hasLength(1));

    when(() => env.mockBox.isOrdering()).thenReturn(false);
    syncPosCartIsExpenseContainer(container);
    await subscribeAndSettle(container, sale: sale, purchase: purchase);

    expect(
      container.read(posCartDisplayItemsProvider),
      isEmpty,
      reason: 'purchase lines must not leak into the sale cart',
    );
    expect(container.read(posCartSummaryProvider).unitQtyTotal, 0);
  });
}
