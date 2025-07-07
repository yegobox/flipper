import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_dashboard/features/ai/widgets/data_visualization.dart';
import 'package:flipper_dashboard/features/ai/providers/currency_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/mock_currency_service.dart';

void main() {
  // A dummy function for onCopyGraph since the tests don't focus on copy functionality
  void _doNothing() {}

  group('DataVisualization Widget Tests', () {
    const testData = '''
**[SUMMARY]**
Total Revenue: \$3,002,663.24
Total Profit: \$576,784.92
Total Units Sold: 83,621
**[DETAILS]**
Additional details here...
''';

    const taxData = '''
Tax Summary for 03/04/2025

Total Tax Payable Today: **RWF 1,035.00**

***

Detailed Tax Breakdown for 03/04/2025

| Item Name             | Price (RWF) | Units Sold | Tax Rate | Total Tax (RWF) |
|----------------------|-------------|------------|----------|------------------|
| CAUSTIC SODA, ItemNshya | 500.00      | 2          | 18%      | 180.00          |
| 18 MM MARINE BOARD, Olive | 1050.00     | 2          | 18%      | 378.00          |
| ItemNshya, Olive      | 1250.00     | 2          | 18%      | 450.00          |
| Olive, ItemNshya      | 1250.00     | 2          | 18%      | 450.00          |
| ItemNshya             | 500.00      | 1          | 18%      | 90.00           |
| ItemNshya             | 500.00      | 1          | 18%      | 90.00           |
| **Total**             |             |            |          | **1,035.00**     |
''';

    const invalidData = '''
Some random text without proper summary format
''';

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

    testWidgets('renders chart when valid data is provided', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: ThemeData(primaryColor: Colors.blue),
            home: Scaffold(
              body: DataVisualization(
                data: testData,
                cardKey: GlobalKey(),
                onCopyGraph: _doNothing,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Verify chart components are rendered
      expect(find.byType(BarChart), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);

      // Verify summary text contains all values
      final summaryText =
          'Summary: Total Revenue: RWF 3.00M, Total Profit: RWF 576.78K, Total Units Sold: 83621';
      expect(find.text(summaryText), findsOneWidget);
    });

    testWidgets('returns empty widget when invalid data is provided',
        (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: DataVisualization(
                data: invalidData,
                cardKey: GlobalKey(),
                onCopyGraph: _doNothing,
              ),
            ),
          ),
        ),
      );

      // Verify no chart components are rendered
      expect(find.byType(BarChart), findsNothing);
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('handles empty summary section gracefully', (tester) async {
      const emptyData = '''
**[SUMMARY]**
**[DETAILS]**
Some details...
''';

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: ThemeData(primaryColor: Colors.blue),
            home: Scaffold(
              body: DataVisualization(
                data: invalidData,
                cardKey: GlobalKey(),
                onCopyGraph: _doNothing,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Verify no chart is rendered for empty summary
      expect(find.byType(BarChart), findsNothing);
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('formats currency values correctly with default currency',
        (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: ThemeData(primaryColor: Colors.blue),
            home: Scaffold(
              body: DataVisualization(
                data: testData,
                cardKey: GlobalKey(),
                onCopyGraph: _doNothing,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Verify summary text with default RWF currency
      final summaryText =
          'Summary: Total Revenue: RWF 3.00M, Total Profit: RWF 576.78K, Total Units Sold: 83621';
      expect(find.text(summaryText), findsOneWidget);
    });

    testWidgets('formats currency values correctly with custom currency',
        (tester) async {
      final customContainer = ProviderContainer(
        overrides: [
          currencyServiceProvider.overrideWithValue(
            MockCurrencyService(defaultCurrencyCode: 'USD'),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: customContainer,
          child: MaterialApp(
            theme: ThemeData(primaryColor: Colors.blue),
            home: Scaffold(
              body: DataVisualization(
                data: testData,
                currency: 'USD',
                cardKey: GlobalKey(),
                onCopyGraph: _doNothing,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Verify summary text with custom USD currency
      final summaryText =
          'Summary: Total Revenue: USD 3.00M, Total Profit: USD 576.78K, Total Units Sold: 83621';
      expect(find.text(summaryText), findsOneWidget);

      customContainer.dispose();
    });

    testWidgets('parses numerical data correctly', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: ThemeData(primaryColor: Colors.blue),
            home: Scaffold(
              body: DataVisualization(
                data: testData,
                cardKey: GlobalKey(),
                onCopyGraph: _doNothing,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final barChart = find.byType(BarChart);
      expect(barChart, findsOneWidget);

      final chartWidget = tester.widget<BarChart>(barChart);
      final barGroups = chartWidget.data.barGroups;

      // Verify number of bar groups matches data points
      expect(barGroups.length, 3); // Three data points in test data

      // Verify bar styling
      for (var group in barGroups) {
        expect(group.barRods.length, 1);
        expect(group.barRods.first.width, 20);
        expect(
          group.barRods.first.borderRadius,
          const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        );
      }

      // Verify the values are parsed correctly
      expect(barGroups[0].barRods.first.toY, closeTo(3002663.24, 0.01));
      expect(barGroups[1].barRods.first.toY, closeTo(576784.92, 0.01));
      expect(barGroups[2].barRods.first.toY, closeTo(83621.0, 0.01));
    });

    testWidgets('renders tax visualization for tax response', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: ThemeData(primaryColor: Colors.blue),
            home: Scaffold(
              body: DataVisualization(
                data: taxData,
                cardKey: GlobalKey(),
                onCopyGraph: _doNothing,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Verify pie chart is rendered for tax data
      expect(find.byType(PieChart), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);

      // Verify tax summary text is displayed
      expect(find.text('Tax Summary for 03/04/2025'), findsOneWidget);
      expect(find.text('Total: RWF 1035.00'), findsOneWidget);

      // Verify item breakdown is shown
      expect(find.text('CAUSTIC SODA'), findsOneWidget);
      expect(find.text('18 MM MARINE BOARD'), findsOneWidget);
    });
  });
}
