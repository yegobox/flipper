import 'package:flipper_dashboard/transaction_item_adder.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/log.model.dart';
import 'package:supabase_models/cache/cache_manager.dart';

import 'test_helpers/mocks.dart';
import 'test_helpers/setup.dart';

class MockCacheManager extends Mock implements CacheManager {}

class MockStock extends Mock implements Stock {}
// flutter test test/transaction_item_adder_test.dart  --no-test-assets --dart-define=FLUTTER_TEST_ENV=true --coverage 

void main() {
  late TestEnvironment env;
  late MockDatabaseSync mockDbSync;

  setUpAll(() async {
    env = TestEnvironment();
    await env.init();
    
    // Register fallbacks for mocktail
    registerFallbackValue(Variant(
        id: 'fallback', productId: 'fallback', name: 'fallback', branchId: 1));
    registerFallbackValue(ITransaction(
        id: 'fallback',
        branchId: 1,
        status: 'pending',
        subTotal: 0,
        isExpense: false,
        transactionType: 'sale',
        paymentType: 'cash',
        cashReceived: 0,
        customerChangeDue: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isIncome: true));
    registerFallbackValue(Log(
      id: 'fallback',
      message: 'fallback',
      createdAt: DateTime.now(),
    ));
  });

  // Test data
  final branchId = 1;
  final businessId = 1;
  final variant = Variant(
      id: 'variant_1',
      productId: 'prod_1',
      name: 'Variant 1',
      retailPrice: 10.0,
      stock: Stock(currentStock: 5, id: "1", branchId: 1),
      taxTyCd: "A",
      itemTyCd: "1",
      branchId: 1);
  final product = Product(
      id: 'prod_1',
      name: 'Product 1',
      isComposite: false,
      branchId: 1,
      color: "FFFFFF",
      businessId: 1);
  final pendingTransaction = ITransaction(
      id: 'txn_1',
      branchId: branchId,
      status: 'pending',
      subTotal: 0,
      isExpense: false,
      transactionType: "sale",
      paymentType: "Cash",
      cashReceived: 0,
      customerChangeDue: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isIncome: true);

  late MockCacheManager mockCacheManager;

  setUp(() {
    env.injectMocks();
    env.stubCommonMethods();
    mockDbSync = env.mockDbSync;

    // Mock CacheManager to prevent LateInitializationError
    mockCacheManager = MockCacheManager();
    when(() => mockCacheManager.getStockByVariantId(any()))
        .thenAnswer((_) async => Stock(currentStock: 5, id: "1", branchId: 1));
    
    // Stub for logging to prevent test failures on error logging
    when(() => mockDbSync.saveLog(any())).thenAnswer((_) async {});

    // Common stubs for this test group
    when(() => mockDbSync.getProduct(
        businessId: any(named: 'businessId'),
        id: any(named: 'id'),
        branchId: any(named: 'branchId'))).thenAnswer((_) async => product);
    when(() => mockDbSync.saveTransactionItem(
          variation: any(named: 'variation'),
          amountTotal: any(named: 'amountTotal'),
          customItem: any(named: 'customItem'),
          currentStock: any(named: 'currentStock'),
          pendingTransaction: any(named: 'pendingTransaction'),
          partOfComposite: any(named: 'partOfComposite'),
          doneWithTransaction: any(named: 'doneWithTransaction'),
          ignoreForReport: any(named: 'ignoreForReport'),
          compositePrice: any(named: 'compositePrice'),
        )).thenAnswer((_) async => Future.value(true));
    when(() => mockDbSync.activeBranch()).thenAnswer((_) async => Branch(
        id: branchId.toString(),
        name: "Default",
        businessId: businessId,
        description: "desc"));
  });

  group('TransactionItemAdder Tests', () {
    testWidgets('adds a simple item to transaction',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pendingTransactionStreamProvider(isExpense: false)
                .overrideWith((ref) => Stream.value(pendingTransaction)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () {
                      final sut = TransactionItemAdder(context, ref, cacheManager: mockCacheManager);
                      sut.addItemToTransaction(
                          variant: variant, isOrdering: false);
                    },
                    child: Text('Add'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final captured = verify(() => mockDbSync.saveTransactionItem(
            variation: captureAny(named: 'variation'),
            pendingTransaction: captureAny(named: 'pendingTransaction'),
            amountTotal: any(named: 'amountTotal'),
            currentStock: any(named: 'currentStock'),
            customItem: any(named: 'customItem'),
            partOfComposite: any(named: 'partOfComposite'),
            doneWithTransaction: any(named: 'doneWithTransaction'),
            ignoreForReport: any(named: 'ignoreForReport'),
            compositePrice: any(named: 'compositePrice'),
          )).captured;

      expect(captured[0].id, variant.id);
      expect(captured[1].id, pendingTransaction.id);
    });

    testWidgets('does not add item if out of stock',
        (WidgetTester tester) async {
      final outOfStockVariant = Variant(
          id: 'variant_2',
          productId: 'prod_2',
          name: 'Variant 2',
          retailPrice: 20.0,
          stock: Stock(currentStock: 0, id: "2", branchId: 1),
          taxTyCd: "A",
          itemTyCd: "1",
          branchId: 1);
      
      // Mock zero stock for this variant
      when(() => mockCacheManager.getStockByVariantId('variant_2'))
          .thenAnswer((_) async => Stock(currentStock: 0, id: "2", branchId: 1));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pendingTransactionStreamProvider(isExpense: false)
                .overrideWith((ref) => Stream.value(pendingTransaction)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () {
                      final sut = TransactionItemAdder(context, ref, cacheManager: mockCacheManager);
                      sut.addItemToTransaction(
                          variant: outOfStockVariant, isOrdering: false);
                    },
                    child: Text('Add'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verifyNever(() => mockDbSync.saveTransactionItem(
            variation: any(named: 'variation'),
            amountTotal: any(named: 'amountTotal'),
            customItem: any(named: 'customItem'),
            currentStock: any(named: 'currentStock'),
            pendingTransaction: any(named: 'pendingTransaction'),
            partOfComposite: any(named: 'partOfComposite'),
            doneWithTransaction: any(named: 'doneWithTransaction'),
            ignoreForReport: any(named: 'ignoreForReport'),
            compositePrice: any(named: 'compositePrice'),
          ));
    });

    testWidgets('adds a composite item and its components',
        (WidgetTester tester) async {
      final compositeProduct = Product(
          color: "FFFFFF",
          businessId: 1,
          id: 'comp_prod_1',
          name: 'Composite Product',
          isComposite: true,
          branchId: 1);
      final compositeVariant = Variant(
          id: 'comp_var_1',
          productId: 'comp_prod_1',
          name: 'Composite Variant',
          retailPrice: 50.0,
          stock: Stock(currentStock: 10, id: "s3", branchId: 1),
          taxTyCd: "A",
          itemTyCd: "1",
          branchId: 1);

      final subVariant1 = Variant(
          id: 'sub_var_1',
          productId: 'sub_prod_1',
          name: 'Sub Variant 1',
          retailPrice: 15.0,
          stock: Stock(currentStock: 20, id: "s4", branchId: 1),
          branchId: 1);
      final subVariant2 = Variant(
          id: 'sub_var_2',
          productId: 'sub_prod_2',
          name: 'Sub Variant 2',
          retailPrice: 25.0,
          stock: Stock(currentStock: 30, id: "s5", branchId: 1),
          branchId: 1);

      final composites = [
        Composite(
            id: 'c1',
            productId: compositeProduct.id,
            variantId: subVariant1.id,
            actualPrice: 15.0,
            branchId: 1),
        Composite(
            id: 'c2',
            productId: compositeProduct.id,
            variantId: subVariant2.id,
            actualPrice: 25.0,
            branchId: 1),
      ];

      when(() => mockDbSync.getProduct(
          businessId: businessId,
          id: compositeVariant.productId!,
          branchId: branchId)).thenAnswer((_) async => compositeProduct);
      when(() => mockDbSync.composites(productId: compositeProduct.id))
          .thenAnswer((_) async => composites);
      when(() => mockDbSync.getVariant(id: subVariant1.id))
          .thenAnswer((_) async => subVariant1);
      when(() => mockDbSync.getVariant(id: subVariant2.id))
          .thenAnswer((_) async => subVariant2);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pendingTransactionStreamProvider(isExpense: false)
                .overrideWith((ref) => Stream.value(pendingTransaction)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () {
                      final sut = TransactionItemAdder(context, ref, cacheManager: mockCacheManager);
                      sut.addItemToTransaction(
                          variant: compositeVariant, isOrdering: false);
                    },
                    child: Text('Add Composite'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(() => mockDbSync.saveTransactionItem(
            variation: subVariant1,
            pendingTransaction: pendingTransaction,
            partOfComposite: true,
            compositePrice: 15.0,
            amountTotal: 15.0,
            currentStock: 20,
            customItem: false,
            doneWithTransaction: false,
            ignoreForReport: false,
          )).called(1);
      verify(() => mockDbSync.saveTransactionItem(
            variation: subVariant2,
            pendingTransaction: pendingTransaction,
            partOfComposite: true,
            compositePrice: 25.0,
            amountTotal: 25.0,
            currentStock: 30,
            customItem: false,
            doneWithTransaction: false,
            ignoreForReport: false,
          )).called(1);
    });

    testWidgets('concurrent calls are serialized', (WidgetTester tester) async {
      final variant1 = Variant(
          id: 'v1',
          productId: 'p1',
          name: 'V1',
          retailPrice: 10.0,
          stock: Stock(currentStock: 5, id: "s1", branchId: 1),
          taxTyCd: 'A',
          itemTyCd: '1',
          branchId: 1);
      final variant2 = Variant(
          id: 'v2',
          productId: 'p2',
          name: 'V2',
          retailPrice: 20.0,
          stock: Stock(currentStock: 5, id: "s2", branchId: 1),
          taxTyCd: 'A',
          itemTyCd: '1',
          branchId: 1);

      when(() => mockDbSync.saveTransactionItem(
          variation: any(named: 'variation'),
          amountTotal: any(named: 'amountTotal'),
          customItem: any(named: 'customItem'),
          currentStock: any(named: 'currentStock'),
          pendingTransaction: any(named: 'pendingTransaction'),
          partOfComposite: any(named: 'partOfComposite'),
          doneWithTransaction: any(named: 'doneWithTransaction'),
          ignoreForReport: any(named: 'ignoreForReport'),
          compositePrice: any(named: 'compositePrice'))).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 50));
        return true;
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pendingTransactionStreamProvider(isExpense: false)
                .overrideWith((ref) => Stream.value(pendingTransaction)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  final sut = TransactionItemAdder(context, ref, cacheManager: mockCacheManager);
                  return Column(children: [
                    ElevatedButton(
                        key: const Key('v1'),
                        onPressed: () => sut.addItemToTransaction(
                            variant: variant1, isOrdering: false),
                        child: const Text('1')),
                    ElevatedButton(
                        key: const Key('v2'),
                        onPressed: () => sut.addItemToTransaction(
                            variant: variant2, isOrdering: false),
                        child: const Text('2')),
                  ]);
                },
              ),
            ),
          ),
        ),
      );

      final v1Button =
          tester.widget<ElevatedButton>(find.byKey(const Key('v1')));
      final v2Button =
          tester.widget<ElevatedButton>(find.byKey(const Key('v2')));

      // Fire both without awaiting to simulate concurrency
      v1Button.onPressed!();
      v2Button.onPressed!();

      // Wait for all animations and futures to complete
      await tester.pumpAndSettle();

      // Verify that the calls were made in order due to the lock
      verifyInOrder([
        () => mockDbSync.saveTransactionItem(
            variation: variant1,
            amountTotal: 10.0,
            customItem: false,
            currentStock: 5,
            pendingTransaction: pendingTransaction,
            partOfComposite: false,
            doneWithTransaction: false,
            ignoreForReport: false),
        () => mockDbSync.saveTransactionItem(
            variation: variant2,
            amountTotal: 20.0,
            customItem: false,
            currentStock: 5,
            pendingTransaction: pendingTransaction,
            partOfComposite: false,
            doneWithTransaction: false,
            ignoreForReport: false)
      ]);
    });
  });
}
