import 'dart:async';

import 'package:flipper_dashboard/itemRow.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
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
import 'package:supabase_models/brick/models/variant.model.dart';

import '../test_helpers/mocks.dart';
import '../test_helpers/setup.dart';
import 'pos_cart_tap_widget_test.dart' show stubPosCartTapPersist;

class MockProductViewModel extends Mock implements ProductViewModel {}

class MockSettingsService extends Mock implements SettingsService {}

/// Cold POS cart: the pending transaction id has *not* resolved yet, so
/// [posCartPendingTransactionIdProvider] is null and the optimistic cart runs on
/// [OptimisticCartBootstrap.txnId]. The catalog row's +/- must still appear —
/// it used to render a plus-only button for the whole of that window.
///
/// Run from `flipper/packages/flipper_dashboard`:
/// `flutter test test/widgets/pos_catalog_stepper_widget_test.dart --dart-define=FLUTTER_TEST_ENV=true`
void main() {
  late TestEnvironment env;
  late MockProductViewModel mockProductViewModel;
  late MockSettingsService mockSettingsService;

  const variantId = 'var-stepper-1';
  const productName = 'Stepper Test Product';
  const variantName = 'Stepper Test SKU';

  late Variant variant;

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

    variant = Variant(
      id: variantId,
      name: variantName,
      retailPrice: 99,
      branchId: '1',
      stockId: 'stock-$variantId',
    );
  });

  tearDown(() => env.restore());

  Future<ProviderContainer> pumpRow(WidgetTester tester) async {
    // Narrow viewport => RowItem renders the compact mPOS catalog row, which is
    // the layout that carries the inline +/- control.
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final container = ProviderContainer(
      overrides: [
        // RBAC gate on PosCartAddService.tapAdd. It resolves through async
        // access providers that never settle under this harness, and it fails
        // closed, so without this every tap is silently dropped.
        canSellProvider.overrideWithValue(true),
        // Never emits: the pending sale has not been resolved from Ditto yet.
        pendingTransactionStreamProvider(isExpense: false).overrideWith((ref) {
          final controller = StreamController<ITransaction>();
          ref.onDispose(controller.close);
          return controller.stream;
        }),
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
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: RowItem(
              color: '#2563EB',
              productName: productName,
              variantName: variantName,
              stock: 25,
              forceRemoteUrl: false,
              forceListView: true,
              model: mockProductViewModel,
              variant: variant,
              isComposite: false,
              isOrdering: false,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    return container;
  }

  group('catalog row qty control on a cold cart', () {
    testWidgets('starts as a plus-only button', (tester) async {
      await pumpRow(tester);

      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
      expect(find.byIcon(Icons.remove_rounded), findsNothing);
    });

    testWidgets('becomes a full stepper on the frame after the tap', (
      tester,
    ) async {
      final container = await pumpRow(tester);

      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();

      // The pending id is still unresolved — that is the whole point.
      expect(container.read(posCartPendingTransactionIdProvider(false)), isNull);
      expect(
        container.read(optimisticCartProvider).activeTransactionId,
        OptimisticCartBootstrap.txnId,
      );

      // ...and the stepper is nonetheless rendered, so `-` is reachable.
      expect(
        find.byIcon(Icons.remove_rounded),
        findsOneWidget,
        reason: 'qty control still showing plus-only after the tap',
      );
      expect(container.read(posCartQtyForVariantProvider(variantId)), 1);
    });

    testWidgets('the minus button removes the optimistic line', (tester) async {
      final container = await pumpRow(tester);

      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
      expect(container.read(posCartQtyForVariantProvider(variantId)), 1);

      await tester.tap(find.byIcon(Icons.remove_rounded));
      await tester.pump();

      // Used to be a silent no-op: the rollback carried the real/bootstrap id
      // mismatch and was rejected by the strict equality guard.
      expect(container.read(posCartQtyForVariantProvider(variantId)), 0);
      expect(find.byIcon(Icons.remove_rounded), findsNothing);
    });
  });
}
