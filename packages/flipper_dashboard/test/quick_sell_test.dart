
import 'package:flipper_dashboard/QuickSellingView.dart';
import 'package:flipper_rw/dependencyInitializer.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'TestApp.dart';

// flutter test test/quick_sell_test.dart  --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('QuickSellingView Tests', () {
    late GlobalKey<FormState> formKey;
    late TextEditingController discountController;
    late TextEditingController deliveryNoteCotroller;

    late TextEditingController receivedAmountController;
    late TextEditingController customerPhoneNumberController;
    late TextEditingController paymentTypeController;

    setUpAll(() async {
      // Initialize dependencies for test environment
      await initializeDependenciesForTest();
      ProxyService.local.configureLocal(useInMemory: true);
    });

    setUp(() {
      formKey = GlobalKey<FormState>();
      discountController = TextEditingController();
      receivedAmountController = TextEditingController();
      customerPhoneNumberController = TextEditingController();
      paymentTypeController = TextEditingController();
      deliveryNoteCotroller = TextEditingController();
    });

    testWidgets('QuickSellingView displays correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: TestApp(
            child: QuickSellingView(
              deliveryNoteCotroller: deliveryNoteCotroller,
              formKey: formKey,
              discountController: discountController,
              receivedAmountController: receivedAmountController,
              customerPhoneNumberController: customerPhoneNumberController,
              paymentTypeController: paymentTypeController,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Ensure that the initial values of the text fields are shown
      // (You'll need to verify these based on how your app handles initial values)
      // expect(find.text('Grand Total: \ 0'), findsOneWidget);
      expect(find.text('Discount'), findsOneWidget);
      expect(find.text('Received Amount'), findsOneWidget);
      expect(find.text('Customer Phone number'), findsOneWidget);
      expect(find.text('Payment Method'), findsOneWidget);
    });

    // Test for updating the total when an item is added
    // (This will need to be implemented with a mock item and triggering the addition logic)
    testWidgets('QuickSellingView updates total when item added',
        (WidgetTester tester) async {
      // TODO: Implement this test after setting up your item addition logic
    });

    /// Validating form fields
    testWidgets('QuickSellingView validates form fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: TestApp(
            child: QuickSellingView(
              deliveryNoteCotroller: deliveryNoteCotroller,
              formKey: formKey,
              discountController: discountController,
              receivedAmountController: receivedAmountController,
              customerPhoneNumberController: customerPhoneNumberController,
              paymentTypeController: paymentTypeController,
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      // Verify error messages for invalid inputs
      expect(find.text('Please enter received amount'), findsOneWidget);
      expect(find.text('Please enter a phone number'), findsOneWidget);
      expect(
          find.text('Please select or enter a payment method'), findsOneWidget);
    });
  });
}
