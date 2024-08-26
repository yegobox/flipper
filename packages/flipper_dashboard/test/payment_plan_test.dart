import 'package:flipper_dashboard/payment/PaymentPlan.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

// flutter test test/payment_plan_test.dart --dart-define=FLUTTER_TEST_ENV=true

void main() {
  group('PaymentPlan Widget Tests', () {
    testWidgets('Initial Price is Correct', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: PaymentPlanUI(),
      ));

      // Find the price summary text widget
      final priceTextFinder = find.text('5,000 RWF/month');
      expect(priceTextFinder, findsOneWidget);
    });

    testWidgets('Monthly Plan Price Updates Correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: PaymentPlanUI(),
      ));

      // Tap on the 'Mobile' plan card
      final mobilePlanFinder =
          find.widgetWithText(GestureDetector, 'Mobile only');
      await tester.tap(mobilePlanFinder);
      await tester.pumpAndSettle(); // Wait for animations to finish

      // Verify the price is still 5,000 RWF/month
      final priceTextFinder = find.text('5,000 RWF/month');
      expect(priceTextFinder, findsOneWidget);

      // Tap on 'Yearly' toggle
      final yearlyToggleFinder = find.text('Yearly (20% off)');
      await tester.tap(yearlyToggleFinder);
      await tester.pumpAndSettle();

      // Verify the price updates to 48,000 RWF/year
      final updatedPriceFinder = find.text('48,000 RWF/year');
      expect(updatedPriceFinder, findsOneWidget);
    });

    testWidgets('Additional Devices Input Works', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: PaymentPlanUI(),
      ));

      await tester.scrollUntilVisible(
        find.text('Custom'),
        200.0, // Adjust this value if necessary based on your UI layout
        scrollable: find.byType(Scrollable),
      );
      await tester.pumpAndSettle();

      // Find the 'Custom' plan card
      final customPlanFinder = find.textContaining('Custom');
      // Tap on 'More than 3 Devices' plan card
      expect(customPlanFinder, findsOneWidget); // Ensure the widget is found
      await tester.tap(customPlanFinder);
      await tester.pumpAndSettle();

      // Verify the additional devices input is visible
      final additionalDevicesInputFinder =
          find.widgetWithText(Row, 'Additional devices');
      expect(additionalDevicesInputFinder, findsOneWidget);

      // Find the '+' button (it's a GestureDetector with an Icon)
      final addButtonFinder = find.descendant(
        of: additionalDevicesInputFinder,
        matching: find.byIcon(Icons.add),
      );
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();

      // Verify the device count updates to 1
      final deviceCountFinder = find.text('1');
      expect(deviceCountFinder, findsOneWidget);

      // Find the '-' button
      final removeButtonFinder = find.descendant(
        of: additionalDevicesInputFinder,
        matching: find.byIcon(Icons.remove),
      );
      await tester.tap(removeButtonFinder);
      await tester.pumpAndSettle();

      // Verify the device count updates to 0
      final updatedDeviceCountFinder = find.text('0');
      expect(updatedDeviceCountFinder, findsOneWidget);
    });

    testWidgets('Proceed Button is Tappable', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: PaymentPlanUI(),
      ));

      // Find the Proceed button
      final proceedButtonFinder =
          find.widgetWithText(ElevatedButton, 'Proceed to Payment');
      expect(proceedButtonFinder, findsOneWidget);

      // Verify the button is tappable
      expect(tester.widget<ElevatedButton>(proceedButtonFinder).onPressed,
          isNotNull);
    });
    testWidgets('All Plans Can Be Selected and Price Updates Correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: PaymentPlanUI()));

      // Define a map of plans and expected prices
      final plans = {
        'Mobile only': '5,000 RWF/month',
        'Mobile + Desktop': '30,000 RWF/month',
        '3 Devices': '120,000 RWF/month',
        'Custom': '120,000+ RWF/month',
      };

      for (var plan in plans.keys) {
        if (plan == '3 Devices') {
          /// first scroll for it to be visible
          await tester.scrollUntilVisible(
            find.text('3 Devices'),
            200.0, // Adjust this value if necessary based on your UI layout
            scrollable: find.byType(Scrollable),
          );
          await tester.pumpAndSettle();
          final planFinder = find.widgetWithText(GestureDetector, plan);
          await tester.tap(planFinder);
          await tester.pumpAndSettle();

          final priceFinder = find.text(plans[plan]!);
          expect(priceFinder, findsOneWidget);
        } else {
          final planFinder = find.widgetWithText(GestureDetector, plan);
          await tester.tap(planFinder);
          await tester.pumpAndSettle();

          final priceFinder = find.text(plans[plan]!);
          expect(priceFinder, findsOneWidget);
        }
      }
    });
    testWidgets('Additional Devices Input Boundary Conditions',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: PaymentPlanUI()));

      await tester.scrollUntilVisible(find.text('Custom'), 200.0,
          scrollable: find.byType(Scrollable));
      await tester.pumpAndSettle();

      final customPlanFinder = find.widgetWithText(GestureDetector, 'Custom');
      await tester.tap(customPlanFinder);
      await tester.pumpAndSettle();

      // Test minimum value (0)
      final removeButtonFinder = find.byIcon(Icons.remove);
      await tester.tap(removeButtonFinder);
      await tester.pumpAndSettle();
      final minDeviceCountFinder = find.text('0');
      expect(minDeviceCountFinder, findsOneWidget);

      // Test adding devices
      final addButtonFinder = find.byIcon(Icons.add);
      await tester.tap(addButtonFinder);
      await tester.tap(addButtonFinder); // Add twice
      await tester.pumpAndSettle();
      final updatedDeviceCountFinder = find.text('2');
      expect(updatedDeviceCountFinder, findsOneWidget);
    });
    testWidgets('Toggle Between Monthly and Yearly Plans',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: PaymentPlanUI()));

      final yearlyToggleFinder = find.text('Yearly (20% off)');
      final monthlyToggleFinder = find.text('Monthly');

      // Test Yearly Toggle
      await tester.tap(yearlyToggleFinder);
      await tester.pumpAndSettle();
      final yearlyPriceFinder = find.textContaining('48,000 RWF/year');
      expect(yearlyPriceFinder, findsWidgets);

      // Test Monthly Toggle
      await tester.tap(monthlyToggleFinder);
      await tester.pumpAndSettle();
      final monthlyPriceFinder = find.textContaining('5,000 RWF/month');
      expect(monthlyPriceFinder, findsWidgets);
    });
    testWidgets('Proceed Button Triggers Action', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: PaymentPlanUI()));

      final proceedButtonFinder =
          find.widgetWithText(ElevatedButton, 'Proceed to Payment');
      await tester.tap(proceedButtonFinder);
      await tester.pumpAndSettle();

      // Verify that the proceed action was triggered (if any action is tied to this button)
      // e.g., Navigator.push or any other logic can be tested here
    });
  });
}
