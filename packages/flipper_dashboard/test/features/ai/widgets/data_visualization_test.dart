import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_dashboard/features/ai/widgets/data_visualization.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  group('DataVisualization Widget Tests', () {
    const testData = '''
**[SUMMARY]**
Total Revenue: \$3,002,663.24
Total Profit: \$576,784.92
Total Units Sold: 83,621
**[DETAILS]**
Additional details here...
''';

    const invalidData = '''
Some random text without proper summary format
''';

    testWidgets('renders chart when valid data is provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: Colors.blue),
          home: Scaffold(
            body: DataVisualization(data: testData),
          ),
        ),
      );
      await tester.pump();

      // Verify chart components are rendered
      expect(find.byType(BarChart), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      
      // Verify summary text contains all values
      final summaryText = 'Summary: Total Revenue: RWF 3.00M, Total Profit: RWF 576.78K, Total Units Sold: RWF 83.62K';
      expect(find.text(summaryText), findsOneWidget);
    });

    testWidgets('returns empty widget when invalid data is provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DataVisualization(data: invalidData),
          ),
        ),
      );
      await tester.pump();

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
        MaterialApp(
          home: Scaffold(
            body: DataVisualization(data: emptyData),
          ),
        ),
      );
      await tester.pump();

      // Verify no chart is rendered for empty summary
      expect(find.byType(BarChart), findsNothing);
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('formats currency values correctly with default currency', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: Colors.blue),
          home: Scaffold(
            body: DataVisualization(data: testData),
          ),
        ),
      );
      await tester.pump();

      // Verify summary text with default RWF currency
      final summaryText = 'Summary: Total Revenue: RWF 3.00M, Total Profit: RWF 576.78K, Total Units Sold: RWF 83.62K';
      expect(find.text(summaryText), findsOneWidget);
    });

    testWidgets('formats currency values correctly with custom currency', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: Colors.blue),
          home: Scaffold(
            body: DataVisualization(
              data: testData,
              currency: 'USD',
            ),
          ),
        ),
      );
      await tester.pump();

      // Verify summary text with custom USD currency
      final summaryText = 'Summary: Total Revenue: USD 3.00M, Total Profit: USD 576.78K, Total Units Sold: USD 83.62K';
      expect(find.text(summaryText), findsOneWidget);
    });

    testWidgets('parses numerical data correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: Colors.blue),
          home: Scaffold(
            body: DataVisualization(data: testData),
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
  });
}
