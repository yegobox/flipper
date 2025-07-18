import 'package:flipper_dashboard/features/ai/providers/currency_provider.dart';
import 'package:flipper_dashboard/features/ai/widgets/data_visualization.dart';
import 'package:flipper_dashboard/features/ai/widgets/data_visualization/structured_data_visualization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';

import '../services/mock_currency_service.dart';

void main() {
  // A dummy function for onCopyGraph since the tests don't focus on copy functionality
  void _doNothing() {}

  group('StructuredDataVisualization Widget Tests', () {
    const businessAnalyticsData = '''
The most sold item overall is Mango, with 23858 units sold.

{{VISUALIZATION_DATA}}
{
  "type": "business_analytics",
  "title": "Product Performance (All-Time)",
  "date": "July 15, 2025",
  "revenue": 17686854.96,
  "profit": 10486669.58,
  "unitsSold": 102264,
  "currencyCode": "RWF",
  "bestSellingItems": [
    {"itemName": "Mango", "unitsSold": 102264, "revenue": 17686854.96}
  ],
  "worstSellingItems": [
    {"itemName": "18 MM MARINE BOARD", "unitsSold": 2, "revenue": 200.00},
    {"itemName": "AGATOGO", "unitsSold": 1, "revenue": 2000.00}
  ]
}
{{/VISUALIZATION_DATA}}
''';

    const taxData = '''
{{VISUALIZATION_DATA}}
{
  "type": "tax",
  "title": "Tax Summary",
  "date": "03/04/2025",
  "totalTax": 1035.00,
  "currencyCode": "RWF",
  "items": [
    {"name": "CAUSTIC SODA, ItemNshya", "taxAmount": 180.00},
    {"name": "18 MM MARINE BOARD, Olive", "taxAmount": 378.00},
    {"name": "ItemNshya, Olive", "taxAmount": 450.00}
  ]
}
{{/VISUALIZATION_DATA}}
''';

    const invalidData = 'Some random text without proper summary format';

    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          currencyServiceProvider.overrideWithValue(
            MockCurrencyService(defaultCurrencyCode: 'RWF'),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    // This is a helper to wrap the widget in a testable app.
    Widget buildTestableWidget(Widget child) {
      return UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: ThemeData(primaryColor: Colors.blue),
          home: Scaffold(body: child),
        ),
      );
    }

    testWidgets(
        'renders business analytics chart when valid data is provided',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          DataVisualization(
            data: businessAnalyticsData,
            cardKey: GlobalKey(),
            onCopyGraph: _doNothing,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify chart components are rendered
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(BarChart), findsOneWidget);

      // Verify header
      expect(find.text('Business Analytics'), findsOneWidget);
      expect(find.text('July 15, 2025'), findsOneWidget);

      // Verify metric cards using specific ancestor finders
      final revenueMetricRow = find.widgetWithIcon(Row, Icons.trending_up);
      expect(find.descendant(of: revenueMetricRow, matching: find.text('Revenue')),
          findsOneWidget);
      expect(
          find.descendant(of: revenueMetricRow, matching: find.text('RWF 17.7M')),
          findsOneWidget);

      final profitMetricRow =
          find.widgetWithIcon(Row, Icons.account_balance_wallet);
      expect(find.descendant(of: profitMetricRow, matching: find.text('Profit')),
          findsOneWidget);
      expect(
          find.descendant(of: profitMetricRow, matching: find.text('RWF 10.5M')),
          findsOneWidget);

      final unitsSoldMetricRow = find.widgetWithIcon(Row, Icons.inventory);
      expect(
          find.descendant(
              of: unitsSoldMetricRow, matching: find.text('Units Sold')),
          findsOneWidget);
      expect(
          find.descendant(
              of: unitsSoldMetricRow, matching: find.text('102,264')),
          findsOneWidget);

      // Verify item performance lists
      expect(find.text('Best Selling Items'), findsOneWidget);
      expect(find.text('Mango'), findsOneWidget);
      expect(find.text('102,264 units'), findsOneWidget);

      expect(find.text('Worst Selling Items'), findsOneWidget);
      expect(find.text('18 MM MARINE BOARD'), findsOneWidget);
      expect(find.text('2 units'), findsOneWidget);
      expect(find.text('AGATOGO'), findsOneWidget);
      expect(find.text('1 units'), findsOneWidget);
    });

    testWidgets('renders tax visualization for tax response', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          DataVisualization(
            data: taxData,
            cardKey: GlobalKey(),
            onCopyGraph: _doNothing,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify chart is rendered (could be Pie or Bar based on logic)
      expect(find.byType(Card), findsOneWidget);
      final pieChart = find.byType(PieChart);
      final barChart = find.byType(BarChart);
      expect(pieChart.evaluate().isNotEmpty || barChart.evaluate().isNotEmpty,
          isTrue);

      // Verify tax summary text is displayed
      expect(find.text('Tax Summary for 03/04/2025'), findsOneWidget);
      expect(find.text('Total: RWF 1.0K'), findsOneWidget);

      // Verify item breakdown is shown in legend or chart
      expect(find.textContaining('CAUSTIC SODA'), findsOneWidget);
      expect(find.textContaining('18 MM MARINE BOARD'), findsOneWidget);
    });

    testWidgets('returns empty widget when invalid data is provided',
        (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          DataVisualization(
            data: invalidData,
            cardKey: GlobalKey(),
            onCopyGraph: _doNothing,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify no chart components are rendered
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('copy button shows feedback on tap', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          DataVisualization(
            data: businessAnalyticsData,
            cardKey: GlobalKey(),
            onCopyGraph: _doNothing,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the copy button
      final copyButton = find.byType(CopyButton);
      expect(copyButton, findsOneWidget);

      // Verify initial state
      expect(find.byIcon(Icons.copy_rounded), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsNothing);

      // Tap the button
      await tester.tap(copyButton);
      await tester.pump(); // Start the animation/state change

      // Verify the "copied" state
      expect(find.byIcon(Icons.copy_rounded), findsNothing);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);

      // Wait for the timer to reset the button state
      await tester.pump(const Duration(seconds: 3));

      // Verify it has returned to the initial state
      expect(find.byIcon(Icons.copy_rounded), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsNothing);
    });
  });
}