import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_rw/dependency_initializer.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'test_helpers/setup.dart';

// Mocks
class MockBoxService extends Mock implements LocalStorage {}

class MockITransaction extends Mock implements ITransaction {}

class MockTransactionItem extends Mock implements TransactionItem {}

class MockBranch extends Mock implements Branch {}

class MockCustomer extends Mock implements Customer {}

class MockCoreViewModel extends Mock implements CoreViewModel {}

// flutter test test/quick_sell_test.dart --no-test-assets --dart-define=FLUTTER_TEST_ENV=true
// Helper widget to provide necessary context for QuickSellingView
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
        // Mock the pendingTransactionStreamProvider
        pendingTransactionStreamProvider(isExpense: any(named: 'isExpense'))
            .overrideWith((ref) => Stream.value(mockTransaction)),
        // Mock the transactionItemsStreamProvider
        transactionItemsStreamProvider(
                transactionId: any(named: 'transactionId'))
            .overrideWith((ref) => Stream.value(mockTransactionItems)),
        // Mock activeBranchProvider
        activeBranchProvider.overrideWith((ref) => Stream.value(mockBranch)),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: child,
        ),
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
  late TestEnvironment env;

  setUpAll(() async {
    // Register fallbacks for any() calls
    await initializeDependenciesForTest();
    env = TestEnvironment();

    registerFallbackValue(MockITransaction());
    registerFallbackValue(MockTransactionItem());
    registerFallbackValue(MockBranch());
    registerFallbackValue(MockCustomer());
    registerFallbackValue(MockCoreViewModel());
  });

  setUp(() {
    env.injectMocks();
    mockBoxService = MockBoxService();
    mockTransaction = MockITransaction();
    mockBranch = MockBranch();

    // Stub common methods for mockBoxService
    when(() => mockBoxService.isOrdering()).thenReturn(false);
    when(() => mockBoxService.defaultCurrency()).thenReturn("RWF");
    when(() => mockBoxService.getBusinessId()).thenReturn(1);
    when(() => mockBoxService.getBranchId()).thenReturn(1);
    when(() => mockBoxService.customerTin()).thenReturn(null);
    when(() => mockBoxService.writeString(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenReturn(Future.value(null));
    when(() => mockBoxService.writeDouble(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenReturn(Future.value(null));
    when(() => mockBoxService.writeBool(
        key: any(named: 'key'),
        value: any(named: 'value'))).thenReturn(Future.value(null));
    when(() => mockBoxService.paymentMethodCode(any()))
        .thenReturn("01"); // Default for CASH

    ProxyService.box = mockBoxService;

    discountController = TextEditingController();
    deliveryNoteController = TextEditingController();
    receivedAmountController = TextEditingController();
    customerPhoneNumberController = TextEditingController();
    paymentTypeController = TextEditingController();
    countryCodeController = TextEditingController();
    formKey = GlobalKey<FormState>();
  });

  tearDown(() {
    discountController.dispose();
    deliveryNoteController.dispose();
    receivedAmountController.dispose();
    customerPhoneNumberController.dispose();
    paymentTypeController.dispose();
    countryCodeController.dispose();
  });

  group('QuickSellingView Tests', () {
    testWidgets('QuickSellingView displays correctly on small device',
        (tester) async {
      // Mock a transaction and items
      when(() => mockTransaction.id).thenReturn("test_transaction_id");
      when(() => mockTransaction.createdAt).thenReturn(DateTime.now());
      when(() => mockBranch.id).thenReturn("1");

      final mockTransactionItem = MockTransactionItem();
      when(() => mockTransactionItem.id).thenReturn("1");
      when(() => mockTransactionItem.name).thenReturn("Test Item");
      when(() => mockTransactionItem.price).thenReturn(100.0);
      when(() => mockTransactionItem.qty).thenReturn(1.0);

      await tester.pumpWidget(
        TestApp(
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
          mockTransactionItems: [mockTransactionItem],
          mockBranch: mockBranch,
        ),
      );

      // Initial pump to build the widget
      await tester.pumpAndSettle();

      // Verify key elements are displayed
      expect(find.text('Total Amount'), findsOneWidget);
      expect(
          find.text('RWF 100.00'), findsOneWidget); // Assuming 1 item at 100.0
      expect(find.text('#test_tran'), findsOneWidget); // Partial transaction ID
      expect(find.text('Items'), findsOneWidget);
      expect(find.text('Test Item'), findsOneWidget);
      expect(find.text('Customer'), findsOneWidget);
      expect(find.text('Payment'), findsOneWidget);
      expect(find.text('Complete Sale • RWF 100.00'), findsOneWidget);
    });

    testWidgets('QuickSellingView handles item quantity update',
        (tester) async {
      when(() => mockTransaction.id).thenReturn("test_transaction_id");
      when(() => mockTransaction.createdAt).thenReturn(DateTime.now());
      when(() => mockBranch.id).thenReturn("1");

      final mockTransactionItem = MockTransactionItem();
      when(() => mockTransactionItem.id).thenReturn("1");
      when(() => mockTransactionItem.name).thenReturn("Test Item");
      when(() => mockTransactionItem.price).thenReturn(100.0);
      when(() => mockTransactionItem.qty).thenReturn(1.0);

      await tester.pumpWidget(
        TestApp(
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
          mockTransactionItems: [mockTransactionItem],
          mockBranch: mockBranch,
        ),
      );

      await tester.pumpAndSettle();

      // Tap the add quantity button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify updateTransactionItem was called with increased quantity
      verify(() => ProxyService.strategy.updateTransactionItem(
            transactionItemId: "1",
            ignoreForReport: false,
            qty: 2.0, // Expecting quantity to be 2.0
            active: any(named: 'active'),
          )).called(1);

      // Tap the remove quantity button
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      // Verify updateTransactionItem was called with decreased quantity
      verify(() => ProxyService.strategy.updateTransactionItem(
            transactionItemId: "1",
            ignoreForReport: false,
            qty: 1.0, // Expecting quantity to be 1.0
            active: any(named: 'active'),
          )).called(1);
    });

    testWidgets('QuickSellingView handles item deletion', (tester) async {
      when(() => mockTransaction.id).thenReturn("test_transaction_id");
      when(() => mockTransaction.createdAt).thenReturn(DateTime.now());
      when(() => mockBranch.id).thenReturn("1");

      final mockTransactionItem = MockTransactionItem();
      when(() => mockTransactionItem.id).thenReturn("1");
      when(() => mockTransactionItem.name).thenReturn("Test Item");
      when(() => mockTransactionItem.price).thenReturn(100.0);
      when(() => mockTransactionItem.qty).thenReturn(1.0);

      await tester.pumpWidget(
        TestApp(
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
          mockTransactionItems: [mockTransactionItem],
          mockBranch: mockBranch,
        ),
      );

      await tester.pumpAndSettle();

      // Tap the delete icon
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle(); // Pump to show the dialog

      // Verify the confirmation dialog is shown
      expect(find.text('Remove Item'), findsOneWidget);
      expect(
          find.text(
              'Are you sure you want to remove "Test Item" from this transaction?'),
          findsOneWidget);

      // Tap the 'Remove' button in the dialog
      await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
      await tester
          .pumpAndSettle(); // Pump to dismiss the dialog and process deletion

      // Verify updateTransactionItem was called to deactivate the item
      verify(() => ProxyService.strategy.updateTransactionItem(
            transactionItemId: "1",
            active: false,
            ignoreForReport: false,
            qty: any(named: 'qty'),
          )).called(1);
    });

    testWidgets('QuickSellingView handles received amount input',
        (tester) async {
      when(() => mockTransaction.id).thenReturn("test_transaction_id");
      when(() => mockTransaction.createdAt).thenReturn(DateTime.now());
      when(() => mockBranch.id).thenReturn("1");

      final mockTransactionItem = MockTransactionItem();
      when(() => mockTransactionItem.id).thenReturn("1");
      when(() => mockTransactionItem.name).thenReturn("Test Item");
      when(() => mockTransactionItem.price).thenReturn(100.0);
      when(() => mockTransactionItem.qty).thenReturn(1.0);

      await tester.pumpWidget(
        TestApp(
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
          mockTransactionItems: [mockTransactionItem],
          mockBranch: mockBranch,
        ),
      );

      await tester.pumpAndSettle();

      // Enter an amount into the received amount field
      await tester.enterText(find.text('Received Amount'), '150.0');
      await tester.pumpAndSettle();

      // Verify that ProxyService.box.writeDouble was called
      verify(() =>
              mockBoxService.writeDouble(key: 'getCashReceived', value: 150.0))
          .called(1);
    });

    testWidgets('QuickSellingView handles customer phone number input',
        (tester) async {
      when(() => mockTransaction.id).thenReturn("test_transaction_id");
      when(() => mockTransaction.createdAt).thenReturn(DateTime.now());
      when(() => mockBranch.id).thenReturn("1");

      final mockTransactionItem = MockTransactionItem();
      when(() => mockTransactionItem.id).thenReturn("1");
      when(() => mockTransactionItem.name).thenReturn("Test Item");
      when(() => mockTransactionItem.price).thenReturn(100.0);
      when(() => mockTransactionItem.qty).thenReturn(1.0);

      await tester.pumpWidget(
        TestApp(
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
          mockTransactionItems: [mockTransactionItem],
          mockBranch: mockBranch,
        ),
      );

      await tester.pumpAndSettle();

      // Enter a phone number
      await tester.enterText(find.text('Phone number'), '788123456');
      await tester.pumpAndSettle();

      // Verify that ProxyService.box.writeString was called
      verify(() => mockBoxService.writeString(
          key: 'currentSaleCustomerPhoneNumber', value: '788123456')).called(1);
    });
  });
}
