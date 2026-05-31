import 'package:flipper_dashboard/widgets/analytics_gauge/dashboard_home_gauge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../TestApp.dart';

void main() {
  group('DashboardHomeGauge', () {
    Future<void> pumpGauge(
      WidgetTester tester, {
      required bool isEmpty,
      double value = 500000,
      double revenue = 1000000,
    }) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: DashboardHomeGauge(
              value: isEmpty ? 0 : value,
              revenue: isEmpty ? 0 : revenue,
              grossProfit: isEmpty ? 0 : 800000,
              deductions: isEmpty ? 0 : 200000,
              profitType: 'Net Profit',
              periodLabel: 'This Month',
              isEmpty: isEmpty,
            ),
          ),
        ),
      );
    }

    testWidgets('shows empty state when no transactions', (tester) async {
      await pumpGauge(tester, isEmpty: true);
      await tester.pump();

      expect(find.text('No transactions yet'), findsOneWidget);
      expect(find.text('0'), findsWidgets);
    });

    testWidgets('shows formatted value when data present', (tester) async {
      await pumpGauge(tester, isEmpty: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));

      expect(find.text('500.0K'), findsOneWidget);
      expect(find.text('No transactions yet'), findsNothing);
    });

    testWidgets('uses 700ms animation controller', (tester) async {
      await pumpGauge(tester, isEmpty: false);
      await tester.pump();

      final state = tester.state(find.byType(DashboardHomeGauge));
      expect(state, isNotNull);

      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(find.text('500.0K'), findsOneWidget);
    });
  });
}
