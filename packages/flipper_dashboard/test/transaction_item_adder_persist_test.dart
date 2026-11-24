import 'package:flipper_dashboard/transaction_item_adder_persist.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

// flutter test test/transaction_item_adder_persist_test.dart --dart-define=FLUTTER_TEST_ENV=true
//
// A cart line whose save returns false is rolled back, and the add reports
// failure. The failure is seen inside the write lock, where a `return` leaves
// only the lock's callback, so it used to report success.

class _MockDb extends Mock implements DatabaseSyncInterface {}

class _FakeContext extends Fake implements BuildContext {
  @override
  bool get mounted => false;
}

class _MockSettings extends Mock implements SettingsService {}

final _refProvider = Provider<Ref>((ref) => ref);

void main() {
  late _MockDb db;

  final pending = ITransaction(
    id: 'txn-pending',
    branchId: 'b1',
    agentId: 'agent-1',
    status: PENDING,
    transactionType: 'sale',
    paymentType: 'CASH',
    cashReceived: 0,
    customerChangeDue: 0,
    updatedAt: DateTime.utc(2026, 11, 23),
    isIncome: true,
    isExpense: false,
    subTotal: 0,
  );
  final variant = Variant(
    id: 'combo-v',
    name: 'Breakfast',
    branchId: 'b1',
    retailPrice: 1500,
  );
  final pendingProv = Provider<AsyncValue<ITransaction>>(
    (ref) => AsyncData(pending),
  );

  setUpAll(() {
    registerFallbackValue(variant);
    registerFallbackValue(pending);
  });

  setUp(() async {
    await getIt.reset();
    db = _MockDb();
    getIt.registerSingleton<SyncStrategy>(
      SyncStrategy(capella: db, cloudSync: db),
      instanceName: 'strategy',
    );
  });

  tearDown(() async => getIt.reset());

  test('a save that returns false reports the add as failed', () async {
    when(
      () => db.saveTransactionItem(
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
        updatePendingTransactionSubtotal: any(
          named: 'updatePendingTransactionSubtotal',
        ),
      ),
    ).thenAnswer((_) async => false);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    final added = await persistItemToTransaction(
      ref: container.read(_refProvider),
      context: _FakeContext(),
      variant: variant,
      // Ordering skips the stock check, which is not under test here.
      isOrdering: true,
      pendingProv: pendingProv,
      pendingTransaction: pending,
      sessionAtStart: 0,
      cartOptimismApplied: false,
    );

    expect(added, isFalse);
  });

  // A combo is checked against every combo in the cart, and a plain item
  // against what the cart's combos already take of it. Reads stay local.
  group('combo stock across the cart', () {
    TransactionItem line(
      String variantId, {
      String? productId,
      String itemTyCd = '3',
      num qty = 1,
    }) => TransactionItem(
      id: 'line-$variantId',
      name: variantId,
      qty: qty,
      price: 100,
      prc: 100,
      discount: 0,
      ttCatCd: 'B',
      variantId: variantId,
      productId: productId,
      itemTyCd: itemTyCd,
    );
    Product product(String id, {bool combo = true}) => Product(
      id: id,
      name: id,
      color: '#000',
      businessId: 'biz1',
      branchId: 'b1',
      isComposite: combo,
    );
    final soda = Variant(
      id: 'soda',
      name: 'Soda',
      branchId: 'b1',
      stockId: 'soda-s',
      itemTyCd: '2',
      taxTyCd: 'B',
    );
    final comboB = Variant(
      id: 'combo-b',
      name: 'Combo B',
      branchId: 'b1',
      productId: 'pb',
      itemTyCd: '3',
      taxTyCd: 'B',
    );
    final delivery = Variant(
      id: 'delivery',
      name: 'Delivery',
      branchId: 'b1',
      productId: 'pd',
      itemTyCd: '3',
      taxTyCd: 'B',
    );

    void stubStore({required double sodaOnHand}) {
      when(() => db.batchGetVariantsByIds(any())).thenAnswer((inv) async {
        final ids = inv.positionalArguments.first as List<String>;
        return {
          // Combo A's cart line has no productId: it is read from the variant.
          if (ids.contains('combo-a'))
            'combo-a': Variant(
              id: 'combo-a',
              name: 'Combo A',
              branchId: 'b1',
              productId: 'pa',
              itemTyCd: '3',
            ),
          if (ids.contains('soda')) 'soda': soda,
        };
      });
      when(
        () => db.getProduct(id: 'pa', branchId: 'b1', businessId: 'biz1'),
      ).thenAnswer((_) async => product('pa'));
      when(
        () => db.getProduct(id: 'pb', branchId: 'b1', businessId: 'biz1'),
      ).thenAnswer((_) async => product('pb'));
      when(
        () => db.getProduct(id: 'pd', branchId: 'b1', businessId: 'biz1'),
      ).thenAnswer((_) async => product('pd', combo: false));
      when(
        () => db.composites(productId: 'pa', localOnly: true),
      ).thenAnswer((_) async => [Composite(variantId: 'soda', qty: 2)]);
      when(
        () => db.composites(productId: 'pb', localOnly: true),
      ).thenAnswer((_) async => [Composite(variantId: 'soda')]);
      final stock = Stock(
        id: 'soda-s',
        branchId: 'b1',
        currentStock: sodaOnHand,
      );
      when(() => db.getStockById(id: 'soda-s')).thenAnswer((_) async => stock);
      when(
        () => db.batchGetStocksByIds(any()),
      ).thenAnswer((_) async => {'soda-s': stock});
    }

    Future<void> tap(
      Variant tapped, {
      required List<TransactionItem> cart,
      String? businessId = 'biz1',
    }) async {
      final settings = _MockSettings();
      when(
        () => settings.isAllowSellingBelowStock(),
      ).thenAnswer((_) async => false);
      if (locator.isRegistered<SettingsService>()) {
        locator.unregister<SettingsService>();
      }
      locator.registerSingleton<SettingsService>(settings);
      addTearDown(() => locator.unregister<SettingsService>());

      final container = ProviderContainer(
        overrides: [posCartDisplayItemsProvider.overrideWithValue(cart)],
      );
      addTearDown(container.dispose);
      await persistItemToTransaction(
        ref: container.read(_refProvider),
        context: _FakeContext(),
        variant: tapped,
        isOrdering: false,
        pendingProv: pendingProv,
        pendingTransaction: pending,
        sessionAtStart: 0,
        cartOptimismApplied: false,
        businessId: businessId,
      );
    }

    void expectSaved(bool saved) {
      final save = () => db.saveTransactionItem(
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
        updatePendingTransactionSubtotal: any(
          named: 'updatePendingTransactionSubtotal',
        ),
      );
      if (saved) {
        verify(save).called(1);
      } else {
        verifyNever(save);
      }
    }

    setUp(() {
      when(
        () => db.saveTransactionItem(
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
          updatePendingTransactionSubtotal: any(
            named: 'updatePendingTransactionSubtotal',
          ),
        ),
      ).thenAnswer((_) async => false);
    });

    final cartWithBothCombos = [
      line('combo-a'),
      line('combo-b', productId: 'pb'),
      line('delivery', productId: 'pd'),
    ];

    test('combo B is blocked by the soda combo A already takes', () async {
      stubStore(sodaOnHand: 2);
      await tap(comboB, cart: cartWithBothCombos);
      expectSaved(false);
      // Local reads only: a tap never waits on the server.
      verifyNever(
        () =>
            db.composites(productId: any(named: 'productId'), localOnly: false),
      );
    });

    test('combo B goes in when the soda covers both combos', () async {
      stubStore(sodaOnHand: 3);
      await tap(comboB, cart: cartWithBothCombos);
      expectSaved(true);
    });

    test('a plain soda counts what the combos take', () async {
      stubStore(sodaOnHand: 3);
      await tap(
        soda,
        cart: [
          line('combo-a'),
          line('soda', itemTyCd: '2'),
        ],
      );
      // 1 soda on its own + 2 in combo A > 3 on hand? No: 3 fits.
      expectSaved(true);
    });

    test('a plain soda is blocked when the combos take the rest', () async {
      stubStore(sodaOnHand: 2);
      await tap(
        soda,
        cart: [
          line('combo-a'),
          line('soda', itemTyCd: '2'),
        ],
      );
      expectSaved(false);
    });

    test('a plain item in a cart without services reads no combos', () async {
      stubStore(sodaOnHand: 2);
      await tap(soda, cart: [line('soda', itemTyCd: '2')]);
      expectSaved(true);
      verifyNever(
        () => db.getProduct(
          id: any(named: 'id'),
          branchId: any(named: 'branchId'),
          businessId: any(named: 'businessId'),
        ),
      );
    });

    test('with no business, combos are not checked', () async {
      stubStore(sodaOnHand: 2);
      await tap(
        soda,
        cart: [
          line('combo-a'),
          line('soda', itemTyCd: '2'),
        ],
        businessId: null,
      );
      expectSaved(true);
    });

    test('a component with no stock record never blocks', () async {
      stubStore(sodaOnHand: 0);
      when(
        () => db.composites(productId: 'pb', localOnly: true),
      ).thenAnswer((_) async => [Composite(variantId: 'napkin', qty: 9)]);
      when(() => db.batchGetVariantsByIds(any())).thenAnswer(
        (_) async => {
          'napkin': Variant(
            id: 'napkin',
            name: 'Napkin',
            branchId: 'b1',
            itemTyCd: '2',
          ),
        },
      );
      await tap(comboB, cart: [line('combo-b', productId: 'pb')]);
      expectSaved(true);
      verifyNever(() => db.batchGetStocksByIds(any()));
    });

    testWidgets('a blocked combo rolls back its line and says why', (
      tester,
    ) async {
      stubStore(sodaOnHand: 0);
      final settings = _MockSettings();
      when(
        () => settings.isAllowSellingBelowStock(),
      ).thenAnswer((_) async => false);
      if (locator.isRegistered<SettingsService>()) {
        locator.unregister<SettingsService>();
      }
      locator.registerSingleton<SettingsService>(settings);
      addTearDown(() => locator.unregister<SettingsService>());

      // The error snack bar needs desktop width.
      tester.view.physicalSize = const Size(1600, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      late BuildContext context;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates:
              FlipperAppLocalizations.localizationsDelegates,
          supportedLocales: FlipperAppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (c) {
                context = c;
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      final container = ProviderContainer(
        overrides: [
          posCartDisplayItemsProvider.overrideWithValue([
            line('combo-b', productId: 'pb'),
          ]),
        ],
      );
      addTearDown(container.dispose);
      container
          .read(optimisticCartProvider.notifier)
          .addPendingLine(transactionId: pending.id, variant: comboB);

      final added = await tester.runAsync(
        () => persistItemToTransaction(
          ref: container.read(_refProvider),
          context: context,
          variant: comboB,
          isOrdering: false,
          pendingProv: pendingProv,
          pendingTransaction: pending,
          sessionAtStart: 0,
          cartOptimismApplied: true,
          businessId: 'biz1',
        ),
      );
      await tester.pump();

      expect(added, isFalse);
      expect(
        container
                .read(optimisticCartProvider)
                .pendingQtyByVariantId['combo-b'] ??
            0,
        0,
      );
      expectSaved(false);
      await tester.pump(const Duration(seconds: 5));
    });

    test('a service that is not a combo needs no components', () async {
      stubStore(sodaOnHand: 0);
      await tap(delivery, cart: [line('delivery', productId: 'pd')]);
      expectSaved(true);
    });
  });
}
