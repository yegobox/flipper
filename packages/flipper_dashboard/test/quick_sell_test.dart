import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_rw/dependency_initializer.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

// Mocks
class MockBoxService extends Mock implements LocalStorage {}

class MockITransaction extends Mock implements ITransaction {}

class MockTransactionItem extends Mock implements TransactionItem {}

class MockBranch extends Mock implements Branch {}

class MockCustomer extends Mock implements Customer {}

class MockCoreViewModel extends Mock implements CoreViewModel {}

class TestApp extends StatelessWidget {
  final Widget child;
  final MockBoxService mockBoxService;
  final MockITransaction mockTransaction;
  final List<MockTransactionItem> mockTransactionItems;
  final MockBranch mockBranch;

  TestApp({
    required this.child,
    required this.mockBoxService,
    required this.mockTransaction,
    required this.mockTransactionItems,
    required this.mockBranch,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        pendingTransactionStreamProvider(isExpense: false)
            .overrideWith((ref) => Stream.value(mockTransaction)),
        // Mock the transactionItemsStreamProvider
        transactionItemsStreamProvider(transactionId: "test_transaction_id")
            .overrideWith((ref) => Stream.value(mockTransactionItems)),
        activeBranchProvider.overrideWith((ref) => Stream.value(mockBranch)),
      ],
      child: MaterialApp(
        home: Scaffold(body: child),
      ),
    );
  }
}

void main() {
  late MockBoxService mockBoxService;
  late MockITransaction mockTransaction;
  late MockBranch mockBranch;
  late TextEditingController discountController;
  late TextEditingController deliveryNoteController;
  late TextEditingController receivedAmountController;
  late TextEditingController customerPhoneNumberController;
  late TextEditingController paymentTypeController;
  late TextEditingController countryCodeController;
  late GlobalKey<FormState> formKey;

  setUpAll(() async {
    await initializeDependenciesForTest();
    registerFallbackValue(MockITransaction());
    registerFallbackValue(MockTransactionItem());
    registerFallbackValue(MockBranch());
    registerFallbackValue(MockCustomer());
    registerFallbackValue(MockCoreViewModel());
  });

  setUp(() {
    mockBoxService = MockBoxService();
    mockTransaction = MockITransaction();
    mockBranch = MockBranch();

    // Initialize controllers first
    discountController = TextEditingController();
    deliveryNoteController = TextEditingController();
    receivedAmountController = TextEditingController();
    customerPhoneNumberController = TextEditingController();
    paymentTypeController = TextEditingController();
    countryCodeController = TextEditingController();
    formKey = GlobalKey<FormState>();

    // Common mocks
    when(() => mockBoxService.isOrdering()).thenReturn(false);
    when(() => mockBoxService.defaultCurrency()).thenReturn("RWF");
    when(() => mockBoxService.getBusinessId()).thenReturn(1);
    when(() => mockBoxService.getBranchId()).thenReturn(1);
    when(() => mockBoxService.customerTin()).thenReturn(null);
    when(() => mockBoxService.writeString(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenAnswer((_) async {});
    when(() => mockBoxService.writeDouble(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenAnswer((_) async {});
    when(() => mockBoxService.writeBool(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenAnswer((_) async {});
    when(() => mockBoxService.paymentMethodCode(any())).thenReturn("01");

    ProxyService.box = mockBoxService;
  });

  tearDown(() {
    // discountController.dispose();
    // deliveryNoteController.dispose();
    // receivedAmountController.dispose();
    // customerPhoneNumberController.dispose();
    // paymentTypeController.dispose();
    // countryCodeController.dispose();
  });

  group('QuickSellingView Tests', () {
    testWidgets('displays correctly on small device', (tester) async {
      // Setup device size
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // Mock transaction data
      when(() => mockTransaction.id).thenReturn("test_transaction_id");
      when(() => mockTransaction.createdAt).thenReturn(DateTime.now());
      when(() => mockBranch.id).thenReturn("1");

      // Mock transaction item
      final mockItem = MockTransactionItem();
      when(() => mockItem.id).thenReturn("1");
      when(() => mockItem.name).thenReturn("Test Item");
      when(() => mockItem.price).thenReturn(100.0);
      when(() => mockItem.qty).thenReturn(1.0);

      await tester.pumpWidget(
        MediaQuery.fromView(
          view: tester.view,
          child: TestApp(
            child: QuickSellingView(
              formKey: formKey,
              discountController: discountController,
              receivedAmountController: receivedAmountController,
              deliveryNoteCotroller: deliveryNoteController,
              customerPhoneNumberController: customerPhoneNumberController,
              paymentTypeController: paymentTypeController,
              countryCodeController: countryCodeController,
            ),
            mockBoxService: mockBoxService,
            mockTransaction: mockTransaction,
            mockTransactionItems: [mockItem],
            mockBranch: mockBranch,
          ),
        ),
      );

      // Wait for initial build and animations
      await tester
          .pumpAndSettle(); // Wait for the UI to rebuild after stream emission

      // Verify key elements are displayed
      expect(find.byKey(const Key('items-section')),
          findsOneWidget); // Check for a known element in the small device layout
      expect(find.text('Total Amount'), findsOneWidget);
    });

    // testWidgets('handles item quantity update', (tester) async {
    //   // Setup mocks
    //   when(() => mockTransaction.id).thenReturn("test_transaction_id");
    //   when(() => mockTransaction.createdAt).thenReturn(DateTime.now());
    //   when(() => mockBranch.id).thenReturn("1");

    //   final mockItem = MockTransactionItem();
    //   when(() => mockItem.id).thenReturn("1");
    //   when(() => mockItem.name).thenReturn("Test Item");
    //   when(() => mockItem.price).thenReturn(100.0);
    //   when(() => mockItem.qty).thenReturn(1.0);

    //   await tester.pumpWidget(
    //     MediaQuery.fromView(
    //       view: tester.view,
    //       child: TestApp(
    //         child: QuickSellingView(
    //           formKey: formKey,
    //           discountController: discountController,
    //           receivedAmountController: receivedAmountController,
    //           deliveryNoteCotroller: deliveryNoteController,
    //           customerPhoneNumberController: customerPhoneNumberController,
    //           paymentTypeController: paymentTypeController,
    //           countryCodeController: countryCodeController,
    //         ),
    //         mockBoxService: mockBoxService,
    //         mockTransaction: mockTransaction,
    //         mockTransactionItems: [mockItem],
    //         mockBranch: mockBranch,
    //       ),
    //     ),
    //   );

    //   await tester.pumpAndSettle();

    //   // Tap the add quantity button
    //   await tester.tap(find.byKey(const Key('quantity-add-1')));
    //   await tester.pumpAndSettle();

    //   // Verify update was called
    //   verify(() => ProxyService.strategy.updateTransactionItem(
    //         transactionItemId: "1",
    //         ignoreForReport: false,
    //         qty: 2.0,
    //         active: any(named: 'active'),
    //       )).called(1);
    // });

    // testWidgets('handles item deletion', (tester) async {
    //   // Setup mocks
    //   when(() => mockTransaction.id).thenReturn("test_transaction_id");
    //   when(() => mockTransaction.createdAt).thenReturn(DateTime.now());
    //   when(() => mockBranch.id).thenReturn("1");

    //   final mockItem = MockTransactionItem();
    //   when(() => mockItem.id).thenReturn("1");
    //   when(() => mockItem.name).thenReturn("Test Item");
    //   when(() => mockItem.price).thenReturn(100.0);
    //   when(() => mockItem.qty).thenReturn(1.0);

    //   await tester.pumpWidget(
    //     MediaQuery.fromView(
    //       view: tester.view,
    //       child: TestApp(
    //         child: QuickSellingView(
    //           formKey: formKey,
    //           discountController: discountController,
    //           receivedAmountController: receivedAmountController,
    //           deliveryNoteCotroller: deliveryNoteController,
    //           customerPhoneNumberController: customerPhoneNumberController,
    //           paymentTypeController: paymentTypeController,
    //           countryCodeController: countryCodeController,
    //         ),
    //         mockBoxService: mockBoxService,
    //         mockTransaction: mockTransaction,
    //         mockTransactionItems: [mockItem],
    //         mockBranch: mockBranch,
    //       ),
    //     ),
    //   );

    //   await tester.pumpAndSettle();

    //   // Tap delete button
    //   await tester.tap(find.byKey(const Key('delete-item-1')));
    //   await tester.pumpAndSettle();

    //   // Verify confirmation dialog
    //   expect(find.text('Remove Item'), findsOneWidget);
    //   expect(find.text('Are you sure you want to remove "Test Item"'),
    //       findsOneWidget);

    //   // Confirm deletion
    //   await tester.tap(find.text('Remove'));
    //   await tester.pumpAndSettle();

    //   // Verify update was called
    //   verify(() => ProxyService.strategy.updateTransactionItem(
    //         transactionItemId: "1",
    //         active: false,
    //         ignoreForReport: false,
    //         qty: any(named: 'qty'),
    //       )).called(1);
    // });

    // testWidgets('handles received amount input', (tester) async {
    //   // Setup mocks
    //   when(() => mockTransaction.id).thenReturn("test_transaction_id");
    //   when(() => mockTransaction.createdAt).thenReturn(DateTime.now());
    //   when(() => mockBranch.id).thenReturn("1");

    //   final mockItem = MockTransactionItem();
    //   when(() => mockItem.id).thenReturn("1");
    //   when(() => mockItem.name).thenReturn("Test Item");
    //   when(() => mockItem.price).thenReturn(100.0);
    //   when(() => mockItem.qty).thenReturn(1.0);

    //   await tester.pumpWidget(
    //     TestApp(
    //       child: QuickSellingView(
    //         discountController: discountController,
    //         receivedAmountController: receivedAmountController,
    //         deliveryNoteCotroller: deliveryNoteController,
    //         customerPhoneNumberController: customerPhoneNumberController,
    //         paymentTypeController: paymentTypeController,
    //         countryCodeController: countryCodeController,
    //         formKey: formKey,
    //       ),
    //       mockBoxService: mockBoxService,
    //       mockTransaction: mockTransaction,
    //       mockTransactionItems: [mockItem],
    //       mockBranch: mockBranch,
    //     ),
    //   );

    //   await tester.pumpAndSettle();

    //   // Enter amount
    //   await tester.enterText(
    //       find.byKey(const Key('received-amount-field')), '150.0');
    //   await tester.pumpAndSettle();

    //   // Verify write was called
    //   verify(() => mockBoxService.writeDouble(
    //         key: 'getCashReceived',
    //         value: 150.0,
    //       )).called(1);
    // });
  });
}
