import 'dart:async';

import 'package:flipper_dashboard/itemRow.dart';
import 'package:flipper_dashboard/widgets/pos_cart_table_host.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/view_models/product_viewmodel.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

import '../test_helpers/mocks.dart';
import '../test_helpers/setup.dart';

class MockProductViewModel extends Mock implements ProductViewModel {}

class MockSettingsService extends Mock implements SettingsService {}

/// Capella persist runs post-frame; stub so optimistic lines are not rolled back.
void stubPosCartTapPersist(TestEnvironment env) {
  when(
    () => env.mockSyncStrategy.getStrategy(Strategy.capella),
  ).thenReturn(env.mockDbSync);
  when(() => env.mockBox.isOrdering()).thenReturn(false);
  when(
    () => env.mockDbSync.getStockById(id: any(named: 'id')),
  ).thenAnswer(
    (_) async => Stock(
      id: 'stock-widget-tap-1',
      branchId: '1',
      currentStock: 25,
      lowStock: 10,
    ),
  );
  when(
    () => env.mockDbSync.saveTransactionItem(
      variation: any(named: 'variation'),
      amountTotal: any(named: 'amountTotal'),
      ignoreForReport: any(named: 'ignoreForReport'),
      customItem: any(named: 'customItem'),
      doneWithTransaction: any(named: 'doneWithTransaction'),
      pendingTransaction: any(named: 'pendingTransaction'),
      currentStock: any(named: 'currentStock'),
      partOfComposite: any(named: 'partOfComposite'),
      compositePrice: any(named: 'compositePrice'),
      updatableQty: any(named: 'updatableQty'),
      item: any(named: 'item'),
      invoiceNumber: any(named: 'invoiceNumber'),
      sarTyCd: any(named: 'sarTyCd'),
      useTransactionItemForQty: any(named: 'useTransactionItemForQty'),
      updatePendingTransactionSubtotal:
          any(named: 'updatePendingTransactionSubtotal'),
    ),
  ).thenAnswer((_) async => true);
}

/// Desktop checkout slice: catalog tile (left) + cart host (right).
class PosCartTapTestHarness extends ConsumerWidget {
  const PosCartTapTestHarness({
    super.key,
    required this.variant,
    required this.productName,
    required this.model,
  });

  final Variant variant;
  final String productName;
  final ProductViewModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(posCartStreamReconciliationProvider, (_, __) {});
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 300,
          height: 280,
          child: RowItem(
            color: '#2563EB',
            productName: productName,
            variantName: variant.name ?? '',
            stock: 25,
            forceRemoteUrl: false,
            forceListView: false,
            usePosCatalogTile: true,
            model: model,
            variant: variant,
            isComposite: false,
            isOrdering: false,
          ),
        ),
        Expanded(
          child: PosCartTableHost(
            builder: (lines) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                key: const Key('pos-cart-test-host'),
                children: [
                  Text(
                    '${lines.length}',
                    key: const Key('pos-cart-line-count'),
                  ),
                  if (lines.isNotEmpty)
                    Text(
                      lines.first.name ?? '',
                      key: const Key('pos-cart-first-line-name'),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Run from `flipper/packages/flipper_dashboard`:
/// `flutter test test/widgets/pos_cart_tap_widget_test.dart --dart-define=FLUTTER_TEST_ENV=true`
void main() {
  late TestEnvironment env;
  late MockProductViewModel mockProductViewModel;
  late MockSettingsService mockSettingsService;

  const pendingTxnId = 'txn-widget-pending';
  const variantId = 'var-widget-tap-1';
  const productName = 'Widget Test Product';
  const variantName = 'Widget Test SKU';

  late Variant variant;
  late ITransaction pendingTxn;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupPathProviderMock();
    env = TestEnvironment();
    await env.init();
    registerFallbackValue(
      ITransaction(
        id: 'fallback-txn',
        branchId: '1',
        status: PENDING,
        transactionType: 'sale',
        paymentType: 'CASH',
        cashReceived: 0,
        customerChangeDue: 0,
        updatedAt: DateTime.now().toUtc(),
        isIncome: true,
        isExpense: false,
        agentId: 'agent-fallback',
        subTotal: 0,
      ),
    );
    mockProductViewModel = MockProductViewModel();
    mockSettingsService = MockSettingsService();
    when(() => mockSettingsService.isAllowSellingBelowStock())
        .thenAnswer((_) async => true);
    if (locator.isRegistered<SettingsService>()) {
      locator.unregister<SettingsService>();
    }
    locator.registerLazySingleton<SettingsService>(() => mockSettingsService);
  });

  tearDownAll(() async {
    if (locator.isRegistered<SettingsService>()) {
      locator.unregister<SettingsService>();
    }

    await env.dispose();
  });

  setUp(() {
    env.injectMocks();
    env.stubCommonMethods();
    stubPosCartTapPersist(env);

    pendingTxn = ITransaction(
      id: pendingTxnId,
      branchId: '1',
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
    variant = Variant(
      id: variantId,
      name: variantName,
      retailPrice: 99,
      branchId: '1',
      stockId: 'stock-$variantId',
    );
  });

  tearDown(() {
    env.restore();
  });

  Future<void> pumpHarness(WidgetTester tester) {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;

    return tester.pumpWidget(
      ProviderScope(
        overrides: [
          cachedPendingCartTransactionProvider(false).overrideWith(
            (ref) => pendingTxn,
          ),
          pendingTransactionStreamProvider(isExpense: false).overrideWith(
            (ref) => Stream<ITransaction>.value(pendingTxn),
          ),
          stockByVariantProvider('stock-$variantId').overrideWith(
            (ref) => Stream<Stock?>.value(
              Stock(
                id: 'stock-$variantId',
                branchId: '1',
                currentStock: 25,
                lowStock: 10,
              ),
            ),
          ),
          // Capella items stream is intentionally slow — cart must not wait for it.
          // Never completes — cart must not wait on Ditto/Capella stream emission.
          transactionItemsStreamProvider(
            transactionId: pendingTxnId,
            branchId: '1',
          ).overrideWith((ref) {
            final controller = StreamController<List<TransactionItem>>();
            ref.onDispose(controller.close);
            return controller.stream;
          }),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: PosCartTapTestHarness(
              variant: variant,
              productName: productName,
              model: mockProductViewModel,
            ),
          ),
        ),
      ),
    );
  }

  group('RowItem tap → cart (Capella/Ditto mocked slow)', () {
    testWidgets('shows cart line on next frame after catalog tap', (
      tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      await pumpHarness(tester);
      await tester.pump();

      expect(find.byKey(const Key('pos-cart-line-count')), findsOneWidget);
      expect(
        tester.widget<Text>(find.byKey(const Key('pos-cart-line-count'))).data,
        '0',
      );
      expect(find.byKey(const Key('pos-cart-first-line-name')), findsNothing);

      await tester.tap(find.byKey(Key('pos-catalog-tap-$variantId')));
      await tester.pump();
      await tester.pump();

      expect(
        tester.widget<Text>(find.byKey(const Key('pos-cart-line-count'))).data,
        '1',
      );
      expect(find.text(variantName), findsOneWidget);
      expect(
        find.byKey(const Key('pos-cart-first-line-name')),
        findsOneWidget,
      );
    });

    testWidgets('cart appears before Capella stream would return', (
      tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      await pumpHarness(tester);
      await tester.pump();

      final sw = Stopwatch()..start();
      await tester.tap(find.byKey(Key('pos-catalog-tap-$variantId')));
      await tester.pump();
      await tester.pump();
      sw.stop();

      expect(find.text(variantName), findsOneWidget);
      // Widget test frame budget (not unit-test µs): must not wait on Ditto stream.
      expect(
        sw.elapsedMilliseconds,
        lessThan(500),
        reason: 'cart took ${sw.elapsedMilliseconds}ms — likely blocked on Ditto',
      );
    });

    testWidgets('uses bootstrap display path while optimistic pending', (
      tester,
    ) async {
      addTearDown(tester.view.resetPhysicalSize);
      await pumpHarness(tester);
      await tester.pump();

      await tester.tap(find.byKey(Key('pos-catalog-tap-$variantId')));
      await tester.pump();
      await tester.pump();

      expect(find.text(variantName), findsOneWidget);
      final container = ProviderScope.containerOf(
        tester.element(find.byKey(const Key('pos-cart-test-host'))),
      );
      final lines = container.read(posCartDisplayItemsProvider);
      expect(lines, hasLength(1));
      expect(OptimisticCartIds.isOptimistic(lines.single.id), isTrue);
      expect(
        container.read(optimisticCartProvider).pendingQtyByVariantId[variantId],
        1,
      );
      expect(
        container.read(posCartMergeTxnIdProvider(false)),
        OptimisticCartBootstrap.txnId,
      );
    });
  });
}
