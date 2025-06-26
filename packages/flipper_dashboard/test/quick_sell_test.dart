import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_rw/dependencyInitializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';

import 'package:supabase_models/brick/repository/storage.dart';
import 'package:get_it/get_it.dart';

import 'package:flipper_services/constants.dart';
import 'package:flipper_models/sync/interfaces/database_sync_interface.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'TestApp.dart';


class MockLocalStorage implements LocalStorage {
  @override
  String? customerTin() => '123456789';

  @override
  int? getBranchId() => 1;

  @override
  String defaultCurrency() => 'RWF';

  @override
  bool isOrdering() => false;

  @override
  bool readBool({required String key}) => false;

  @override
  Future<void> writeBool({required String key, required bool value}) async {}

  @override
  Future<void> writeString({required String key, required String value}) async {}

  @override
  Future<void> writeDouble({required String key, required double value}) async {}

  // Implement all other abstract methods from LocalStorage if they are called in the tested code
  // For now, I'll add dummy implementations for the ones that were causing issues.
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockDatabaseSyncInterface implements DatabaseSyncInterface {
  @override
  Stream<ITransaction> pendingTransaction({
    int? branchId,
    required String transactionType,
    required bool isExpense,
  }) =>
      Stream.value(ITransaction(
        id: 'testTransactionId',
        branchId: 1,
        transactionType: 'Sale',
        createdAt: DateTime.now().toUtc(),
        status: 'PENDING',
        paymentType: 'cash',
        cashReceived: 0.0,
        customerChangeDue: 0.0,
        updatedAt: DateTime.now().toUtc(),
        isIncome: false,
        isExpense: false,
      ));

  @override
  Stream<List<ITransaction>> transactionsStream({
    String? status,
    String? transactionType,
    int? branchId,
    bool isCashOut = false,
    String? id,
    FilterType? filterType,
    bool includePending = false,
    DateTime? startDate,
    DateTime? endDate,
    required bool removeAdjustmentTransactions,
  }) =>
      Stream.value([]);

  // Implement all other abstract methods from DatabaseSyncInterface if they are called in the tested code
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('QuickSellingView Tests', () {
    late GlobalKey<FormState> formKey;
    late TextEditingController discountController;
    late TextEditingController deliveryNoteCotroller;
    late TextEditingController customerNameController;
    late TextEditingController receivedAmountController;
    late TextEditingController customerPhoneNumberController;
    late TextEditingController paymentTypeController;

    late MockLocalStorage mockLocalStorage;
    late MockDatabaseSyncInterface mockDatabaseSyncInterface;

    

    setUp(() {
      GetIt.I.reset(); // Ensure GetIt is reset before each test

      formKey = GlobalKey<FormState>();
      discountController = TextEditingController();
      receivedAmountController = TextEditingController();
      customerNameController = TextEditingController();
      customerPhoneNumberController = TextEditingController();
      paymentTypeController = TextEditingController();
      deliveryNoteCotroller = TextEditingController();

      mockLocalStorage = MockLocalStorage();
      mockDatabaseSyncInterface = MockDatabaseSyncInterface();

      // Register mocks with GetIt
      GetIt.I.registerSingleton<LocalStorage>(mockLocalStorage);
      GetIt.I.registerSingleton<DatabaseSyncInterface>(mockDatabaseSyncInterface);

      
    });

    tearDown(() {
      // Clean up controllers
      discountController.dispose();
      deliveryNoteCotroller.dispose();
      receivedAmountController.dispose();
      customerNameController.dispose();
      customerPhoneNumberController.dispose();
      paymentTypeController.dispose();
    });

    testWidgets('QuickSellingView displays correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestApp(
          child: QuickSellingView(
            deliveryNoteCotroller: deliveryNoteCotroller,
            formKey: formKey,
            customerNameController: customerNameController,
            discountController: discountController,
            receivedAmountController: receivedAmountController,
            customerPhoneNumberController: customerPhoneNumberController,
            paymentTypeController: paymentTypeController,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Ensure that the initial values of the text fields are shown
      expect(find.byWidgetPredicate(
        (widget) => widget is TextField && widget.decoration?.labelText == 'Received Amount',
      ), findsOneWidget);
      expect(find.text('Customer Phone number'), findsOneWidget);
    });

    testWidgets('QuickSellingView validates form fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TestApp(
          child: QuickSellingView(
            deliveryNoteCotroller: deliveryNoteCotroller,
            formKey: formKey,
            customerNameController: customerNameController,
            discountController: discountController,
            receivedAmountController: receivedAmountController,
            customerPhoneNumberController: customerPhoneNumberController,
            paymentTypeController: paymentTypeController,
          ),
        ),
      );

      // Set an invalid phone number to trigger format validation
      customerPhoneNumberController.text = '123';
      receivedAmountController.text = ''; // Set to empty to trigger validation

      // Trigger form validation
      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      // Verify error messages for invalid inputs
      expect(find.text('Please enter received amount'), findsOneWidget);
      expect(
          find.text(
              'Please enter a valid 9-digit phone number without a leading zero'),
          findsOneWidget);
      expect(find.text('Please enter an amount'), findsOneWidget);
    });

    // Additional tests for user interactions and state updates can be added here
  });
}
