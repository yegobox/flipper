import 'package:flipper_dashboard/widgets/payment_methods_card.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../test_helpers/setup.dart';

// flutter test test/widgets/payment_methods_card_test.dart --no-test-assets --dart-define=FLUTTER_TEST_ENV=true
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestEnvironment env;
  late PaymentMethodsNotifier notifier;

  setUpAll(() async {
    env = TestEnvironment();
    await env.init();
  });

  setUp(() {
    env.injectMocks();
    env.stubCommonMethods();

    // Stub the specific method call that was causing issues.
    when(() => env.mockDbSync.savePaymentType(
            paymentRecord: any(named: 'paymentRecord'),
            amount: any(named: 'amount'),
            paymentMethod: any(named: 'paymentMethod'),
            transactionId: any(named: 'transactionId'),
            singlePaymentOnly: any(named: 'singlePaymentOnly')))
        .thenAnswer((_) async => Future.value());
  });

  tearDown(() {
    env.restore();
  });

  // Helper to pump the widget with a given state.
  Future<void> pumpWidget(
    WidgetTester tester, {
    required double totalPayable,
    required List<Payment> initialPayments,
  }) async {
    notifier = PaymentMethodsNotifier(initialPayments);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          paymentMethodsProvider.overrideWith((ref) => notifier),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: PaymentMethodsCard(
              transactionId: 'test_transaction',
              totalPayable: totalPayable,
            ),
          ),
        ),
      ),
    );
  }

  group('PaymentMethodsCard Widget Tests', () {
    testWidgets('should correctly distribute amount when one field is edited',
        (WidgetTester tester) async {
      await pumpWidget(tester, totalPayable: 1000, initialPayments: [
        Payment(amount: 1000, method: 'CASH'),
        Payment(amount: 0, method: 'CARD'),
      ]);
      await tester.pumpAndSettle();

      // expect(1, 1);

      final firstAmountField = find.byType(TextFormField).first;
      await tester.enterText(firstAmountField, '700');
      await tester.pumpAndSettle();

      // Assert the state was updated correctly.
      expect(notifier.state[0].amount, 700.0);
      expect(notifier.state[1].amount, 300.0);

      // Assert the UI reflects the new state.
      final secondController = tester
          .widget<TextFormField>(find.byType(TextFormField).last)
          .controller!;
      expect(secondController.text, '300.00');
    });

    testWidgets('should adjust the first field when the last field is edited',
        (WidgetTester tester) async {
      await pumpWidget(tester, totalPayable: 1000, initialPayments: [
        Payment(amount: 500, method: 'CASH'),
        Payment(amount: 300, method: 'CARD'),
        Payment(amount: 200, method: 'MOMO'),
      ]);
      await tester.pumpAndSettle();

      final lastAmountField = find.byType(TextFormField).last;
      await tester.enterText(lastAmountField, '400');
      await tester.pumpAndSettle();

      // Assert the state was updated correctly.
      expect(notifier.state[2].amount, 400.0);
      expect(notifier.state[1].amount, 300.0);
      expect(notifier.state[0].amount, 300.0);

      // Assert the UI reflects the new state.
      final firstController = tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller!;
      expect(firstController.text, '300.00');
    });

    testWidgets('adding a new payment method recalculates amounts',
        (WidgetTester tester) async {
      await pumpWidget(tester, totalPayable: 1500, initialPayments: [
        Payment(amount: 1500, method: 'CASH'),
      ]);
      await tester.pumpAndSettle();

      final addButton = find.byIcon(Icons.add);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Assert the state was updated correctly.
      expect(notifier.state.length, 2);
      expect(notifier.state[0].amount, 1500.0);
      expect(notifier.state[1].amount, 0.0);

      // Assert the UI reflects the new state.
      expect(find.byType(TextFormField), findsNWidgets(2));
      final secondController = tester
          .widget<TextFormField>(find.byType(TextFormField).last)
          .controller!;
      expect(secondController.text, '0.00');
    });

    testWidgets('removing a payment method recalculates amounts',
        (WidgetTester tester) async {
      await pumpWidget(tester, totalPayable: 1000, initialPayments: [
        Payment(amount: 800, method: 'CASH'),
        Payment(amount: 200, method: 'CARD'),
      ]);
      await tester.pumpAndSettle();

      final removeButton = find.byIcon(Icons.close).first;
      await tester.tap(removeButton);
      await tester.pumpAndSettle();

      // Assert the state was updated correctly.
      expect(notifier.state.length, 1);
      expect(notifier.state[0].amount, 1000.0);

      // Assert the UI reflects the new state.
      expect(find.byType(TextFormField), findsOneWidget);
      final firstController = tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller!;
      expect(firstController.text, '1000.00');
    });
  });
}
