import 'package:flipper_dashboard/payment/PaymentPlan.dart';
import 'package:flipper_rw/dependencyInitializer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// flutter test test/payment_plan_test.dart --dart-define=FLUTTER_TEST_ENV=true

void main() {
  group('PaymentPlan Widget Tests', () {
    setUpAll(() async {
      // Initialize dependencies for test environment
      await initializeDependenciesForTest();
      // CreateMockdata().mockBusiness(local: ProxyService.strategy.realm!);
    });

    testWidgets('Initial Price is Correct', (WidgetTester tester) async {
      await tester
          .pumpWidget(ProviderScope(child: MaterialApp(home: PaymentPlanUI())));

      final priceTextFinder = find.text('5,000 RWF/month');
      expect(priceTextFinder, findsOneWidget);
    });

    testWidgets('Monthly Plan Price Updates Correctly',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(ProviderScope(child: MaterialApp(home: PaymentPlanUI())));

      final mobilePlanFinder = find.text('Mobile only');
      await tester.tap(mobilePlanFinder);
      await tester.pumpAndSettle();

      final priceTextFinder = find.text('5,000 RWF/month');
      expect(priceTextFinder, findsOneWidget);

      final yearlyToggleFinder = find.text('Yearly (20% off)');
      await tester.tap(yearlyToggleFinder);
      await tester.pumpAndSettle();

      final updatedPriceFinder = find.text('48,000 RWF/year');
      expect(updatedPriceFinder, findsOneWidget);
    });

    testWidgets('Additional Devices Input Works', (WidgetTester tester) async {
      await tester
          .pumpWidget(ProviderScope(child: MaterialApp(home: PaymentPlanUI())));

      final customPlanFinder = find.text('Custom');
      await tester.scrollUntilVisible(customPlanFinder, 50.0,
          scrollable: find.byType(Scrollable));
      await tester.tap(customPlanFinder);
      await tester.pumpAndSettle();

      final additionalDevicesInputFinder = find.text('Additional devices');
      expect(additionalDevicesInputFinder, findsOneWidget);

      final addButtonFinder = find.byIcon(Icons.add);
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();

      final deviceCountFinder = find.text('1');
      expect(deviceCountFinder, findsOneWidget);

      final removeButtonFinder = find.byIcon(Icons.remove);
      await tester.tap(removeButtonFinder);
      await tester.pumpAndSettle();

      final updatedDeviceCountFinder = find.text('0');
      expect(updatedDeviceCountFinder, findsOneWidget);
    });

    testWidgets('Proceed Button is Tappable', (WidgetTester tester) async {
      await tester
          .pumpWidget(ProviderScope(child: MaterialApp(home: PaymentPlanUI())));

      final proceedButtonFinder = find.text('Proceed to Payment');
      await tester.scrollUntilVisible(proceedButtonFinder, 50.0,
          scrollable: find.byType(Scrollable));
      expect(proceedButtonFinder, findsOneWidget);

      final button = tester.widget<ElevatedButton>(find.ancestor(
          of: proceedButtonFinder, matching: find.byType(ElevatedButton)));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('All Plans Can Be Selected and Price Updates Correctly',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(ProviderScope(child: MaterialApp(home: PaymentPlanUI())));

      final plans = {
        'Mobile only': '5,000 RWF/month',
        'Mobile + Desktop': '30,000 RWF/month',
        '3 Devices': '120,000 RWF/month',
        'Custom': '120,000+ RWF/month',
      };

      for (var plan in plans.keys) {
        final planFinder = find.text(plan);
        await tester.scrollUntilVisible(planFinder, 50.0,
            scrollable: find.byType(Scrollable));
        await tester.tap(planFinder);
        await tester.pumpAndSettle();

        final priceFinder = find.text(plans[plan]!);
        expect(priceFinder, findsOneWidget);
      }
    });

    testWidgets('Additional Devices Input Boundary Conditions',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(ProviderScope(child: MaterialApp(home: PaymentPlanUI())));

      final customPlanFinder = find.text('Custom');
      await tester.scrollUntilVisible(customPlanFinder, 50.0,
          scrollable: find.byType(Scrollable));
      await tester.tap(customPlanFinder);
      await tester.pumpAndSettle();

      final removeButtonFinder = find.byIcon(Icons.remove);
      await tester.tap(removeButtonFinder);
      await tester.pumpAndSettle();
      final minDeviceCountFinder = find.text('0');
      expect(minDeviceCountFinder, findsOneWidget);

      final addButtonFinder = find.byIcon(Icons.add);
      await tester.tap(addButtonFinder);
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();
      final updatedDeviceCountFinder = find.text('2');
      expect(updatedDeviceCountFinder, findsOneWidget);
    });

    testWidgets('Toggle Between Monthly and Yearly Plans',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(ProviderScope(child: MaterialApp(home: PaymentPlanUI())));

      final yearlyToggleFinder = find.text('Yearly (20% off)');
      final monthlyToggleFinder = find.text('Monthly');

      await tester.tap(yearlyToggleFinder);
      await tester.pumpAndSettle();
      final yearlyPriceFinder = find.textContaining('48,000 RWF/year');
      expect(yearlyPriceFinder, findsOneWidget);

      await tester.tap(monthlyToggleFinder);
      await tester.pumpAndSettle();
      final monthlyPriceFinder = find.textContaining('5,000 RWF/month');
      expect(monthlyPriceFinder, findsOneWidget);
    });

    testWidgets('Proceed Button Triggers Action', (WidgetTester tester) async {
      await tester.pumpWidget(ProviderScope(
          overrides: [], child: MaterialApp(home: PaymentPlanUI())));

      final proceedButtonFinder = find.text('Proceed to Payment');
      await tester.scrollUntilVisible(proceedButtonFinder, 50.0,
          scrollable: find.byType(Scrollable));
      await tester.tap(proceedButtonFinder);
      await tester.pumpAndSettle();

      // Note: You may need to add additional assertions here to verify the action triggered by the button
    });
  });
}
