import 'package:flipper_dashboard/transaction_item_adder.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/log.model.dart';

import 'test_helpers/mocks.dart';
import 'test_helpers/setup.dart';

class MockStock extends Mock implements Stock {}

void main() {
  late TestEnvironment env;
  late MockDatabaseSync mockDbSync;

  setUpAll(() async {
    env = TestEnvironment();
    await env.init();

    registerFallbackValue(
      Variant(
        id: 'fallback',
        productId: 'fallback',
        name: 'fallback',
        branchId: "",
      ),
    );
    registerFallbackValue(
      ITransaction(
        agentId: "1",
        id: 'fallback',
        branchId: "",
        status: 'pending',
        subTotal: 0,
        isExpense: false,
        transactionType: 'sale',
        paymentType: 'cash',
        cashReceived: 0,
        customerChangeDue: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isIncome: true,
      ),
    );
    registerFallbackValue(
      Log(id: 'fallback', message: 'fallback', createdAt: DateTime.now()),
    );
  });

  tearDownAll(() async {
    await env.dispose();
  });

  final branchId = "1";
  final businessId = "1";
  final variant = Variant(
    id: 'variant_1',
    productId: 'prod_1',
    name: 'Variant 1',
    retailPrice: 10.0,
    stock: Stock(currentStock: 5, id: "1", branchId: "1"),
    taxTyCd: "A",
    itemTyCd: "1",
    branchId: "",
  );
  final product = Product(
    id: 'prod_1',
    name: 'Product 1',
    isComposite: false,
    branchId: "",
    color: "FFFFFF",
    businessId: "1",
  );
  final pendingTransaction = ITransaction(
    agentId: "1",
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
    isIncome: true,
  );

  setUp(() {
    env.injectMocks();
    env.stubCommonMethods();
    mockDbSync = env.mockDbSync;

    when(
      () => mockDbSync.getStockById(id: any()),
    ).thenAnswer((_) async => Stock(currentStock: 5, id: "1", branchId: "1"));

    when(() => mockDbSync.saveLog(any())).thenAnswer((_) async {});

    when(
      () => mockDbSync.manageTransactionStream(
        isExpense: any(named: 'isExpense'),
        branchId: any(named: 'branchId'),
        transactionType: any(named: 'transactionType'),
      ),
    ).thenAnswer((_) => Stream.value(pendingTransaction));

    when(
      () => mockDbSync.getProduct(
        businessId: any(named: 'businessId'),
        id: any(named: 'id'),
        branchId: any(named: 'branchId'),
      ),
    ).thenAnswer((_) async => product);
    when(
      () => mockDbSync.saveTransactionItem(
        variation: any(named: 'variation'),
        amountTotal: any(named: 'amountTotal'),
        customItem: any(named: 'customItem'),
        currentStock: any(named: 'currentStock'),
        pendingTransaction: any(named: 'pendingTransaction'),
        partOfComposite: any(named: 'partOfComposite'),
        doneWithTransaction: any(named: 'doneWithTransaction'),
        ignoreForReport: any(named: 'ignoreForReport'),
        compositePrice: any(named: 'compositePrice'),
      ),
    ).thenAnswer((_) async => Future.value(true));
    when(() => mockDbSync.activeBranch(branchId: any())).thenAnswer(
      (_) async => Branch(
        id: branchId.toString(),
        name: "Default",
        businessId: businessId,
        description: "desc",
      ),
    );
  });

  group('TransactionItemAdder Tests', () {
    testWidgets('adds a simple item to transaction', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pendingTransactionStreamProvider(
              isExpense: false,
            ).overrideWith((ref) => Stream.value(pendingTransaction)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () {
                      final sut = TransactionItemAdder(context, ref);
                      sut.addItemToTransaction(
                        variant: variant,
                        isOrdering: false,
                      );
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

      final captured = verify(
        () => mockDbSync.saveTransactionItem(
          variation: captureAny(named: 'variation'),
          pendingTransaction: captureAny(named: 'pendingTransaction'),
          amountTotal: any(named: 'amountTotal'),
          currentStock: any(named: 'currentStock'),
          customItem: any(named: 'customItem'),
          partOfComposite: any(named: 'partOfComposite'),
          doneWithTransaction: any(named: 'doneWithTransaction'),
          ignoreForReport: any(named: 'ignoreForReport'),
          compositePrice: any(named: 'compositePrice'),
        ),
      ).captured;

      expect(captured[0].id, variant.id);
      expect(captured[1].id, pendingTransaction.id);
    });

    testWidgets('does not add item if out of stock', (
      WidgetTester tester,
    ) async {
      final outOfStockVariant = Variant(
        id: 'variant_2',
        productId: 'prod_2',
        name: 'Variant 2',
        retailPrice: 20.0,
        stock: Stock(currentStock: 0, id: "2", branchId: "1"),
        taxTyCd: "A",
        itemTyCd: "1",
        branchId: "",
      );

      when(
        () => mockDbSync.getStockById(id: 'variant_2'),
      ).thenAnswer((_) async => Stock(currentStock: 0, id: "2", branchId: "1"));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pendingTransactionStreamProvider(
              isExpense: false,
            ).overrideWith((ref) => Stream.value(pendingTransaction)),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () {
                      final sut = TransactionItemAdder(context, ref);
                      sut.addItemToTransaction(
                        variant: outOfStockVariant,
                        isOrdering: false,
                      );
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

      verifyNever(
        () => mockDbSync.saveTransactionItem(
          variation: any(named: 'variation'),
          amountTotal: any(named: 'amountTotal'),
          customItem: any(named: 'customItem'),
          currentStock: any(named: 'currentStock'),
          pendingTransaction: any(named: 'pendingTransaction'),
          partOfComposite: any(named: 'partOfComposite'),
          doneWithTransaction: any(named: 'doneWithTransaction'),
          ignoreForReport: any(named: 'ignoreForReport'),
          compositePrice: any(named: 'compositePrice'),
        ),
      );
    });
  });
}
