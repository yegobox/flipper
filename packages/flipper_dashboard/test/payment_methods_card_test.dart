import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../lib/widgets/payment_methods_card.dart';
import 'test_helpers/setup.dart';

// flutter test test/payment_methods_card_test.dart  --no-test-assets --dart-define=FLUTTER_TEST_ENV=true
void main() {
  late TestEnvironment env;

  setUpAll(() async {
    env = TestEnvironment();
    await env.init();
  });

  setUp(() {
    env.injectMocks();
    env.stubCommonMethods();

    // Default mocks for these tests
    // when(() => env.mockBox.defaultCurrency()).thenReturn('RWF'); // already overridden in MockBox
    when(() => env.mockBox.paymentMethodCode(any())).thenReturn('CASH');
    when(
      () => env.mockBox.writeString(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async => true);
  });

  tearDown(() {
    env.restore();
  });

  group('PaymentMethodsCard Tests', () {
    test('PaymentMethodsCard properties are correctly assigned', () {
      const key = Key('test-key');
      const transactionId = '12345';
      const totalPayable = 250.75;
      const isCardView = true;

      final widget = PaymentMethodsCard(
        key: key,
        transactionId: transactionId,
        totalPayable: totalPayable,
        isCardView: isCardView,
      );

      expect(widget.key, equals(key));
      expect(widget.transactionId, equals(transactionId));
      expect(widget.totalPayable, equals(totalPayable));
      expect(widget.isCardView, equals(isCardView));
    });

    test('PaymentMethodsCard widget rejects negative totalPayable', () {
      expect(
        () => PaymentMethodsCard(
          transactionId: 'negative-total',
          totalPayable: -10.0,
        ),
        throwsAssertionError,
      );
    });

    testWidgets('Payment field rejects negative and non-numeric input', (
      WidgetTester tester,
    ) async {
      // Set fixed screen size to ensure desktop layout (where we'll look for the field)
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: PaymentMethodsCard(
                transactionId: 'test-id',
                totalPayable: 1000.0,
                isCardView: true,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the TextFormField
      final textFieldFinder = find.byType(TextFormField);
      expect(textFieldFinder, findsOneWidget);

      final textField = tester.widget<TextFormField>(textFieldFinder);
      final controller = textField.controller!;

      // 1. Try entering a negative number
      // We use enterText which simulates user input including formatters
      await tester.enterText(textFieldFinder, '-50');
      await tester.pump();
      // It should be empty or just '50' if the '-' was filtered
      expect(controller.text, isNot(contains('-')));

      // 2. Try entering non-numeric characters
      await tester.enterText(textFieldFinder, 'abc');
      await tester.pump();
      expect(controller.text, isNot(contains('a')));
      expect(controller.text, isNot(contains('b')));
      expect(controller.text, isNot(contains('c')));

      // 3. Try entering a valid positive number
      await tester.enterText(textFieldFinder, '123.45');
      await tester.pump();
      expect(controller.text, equals('123.45'));
    });

    testWidgets(
      'Payment field rejects negative and non-numeric input (Mobile)',
      (WidgetTester tester) async {
        // Set small screen size for mobile layout
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: PaymentMethodsCard(
                  transactionId: 'test-id',
                  totalPayable: 1000.0,
                  isCardView: true,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // On mobile, we need to tap the toggle button to show payment methods
        final toggleFinder = find.byKey(const Key('mobile_toggle_button'));
        expect(toggleFinder, findsOneWidget);
        await tester.tap(toggleFinder);
        await tester.pumpAndSettle();

        // Find the TextFormField
        final textFieldFinder = find.byType(TextFormField);
        expect(textFieldFinder, findsOneWidget);

        final textField = tester.widget<TextFormField>(textFieldFinder);
        final controller = textField.controller!;

        // 1. Try entering a negative number
        await tester.enterText(textFieldFinder, '-50');
        await tester.pump();
        expect(controller.text, isNot(contains('-')));

        // 2. Try entering non-numeric characters
        await tester.enterText(textFieldFinder, 'abc');
        await tester.pump();
        expect(controller.text, isNot(contains('a')));

        // 3. Try entering a valid positive number
        await tester.enterText(textFieldFinder, '123.45');
        await tester.pump();
        expect(controller.text, equals('123.45'));
      },
    );
  });
}
