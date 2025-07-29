import 'package:flipper_dashboard/widgets/analytics_gauge/gauge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import '../../TestApp.dart';
// flutter test test/widgets/analytics_gauge/gauge_test.dart --dart-define=FLUTTER_TEST_ENV=true

void main() {
  group('SemiCircleGauge', () {
    // Helper function to pump the widget with a consistent app wrapper
    Future<void> pumpGauge(
      WidgetTester tester, {
      required double dataOnGreenSide,
      required double dataOnRedSide,
      required String profitType,
      bool areValueColumnsVisible = true,
    }) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: SemiCircleGauge(
                  dataOnGreenSide: dataOnGreenSide,
                  dataOnRedSide: dataOnRedSide,
                  profitType: profitType,
                  areValueColumnsVisible: areValueColumnsVisible,
                ),
              ),
            ),
          ),
        ),
      );
      // Wait for the animation to complete
      await tester.pumpAndSettle();
    }

    testWidgets('displays profit correctly when green side is larger',
        (WidgetTester tester) async {
      await pumpGauge(
        tester,
        dataOnGreenSide: 1000,
        dataOnRedSide: 500,
        profitType: 'Net Profit',
      );

      // Verify the main profit value and label within the CustomPaint area
      final gaugeFinder = find.byType(CustomPaint);

      // Find the main profit value text (larger font size)
      expect(
        find.descendant(
          of: gaugeFinder,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Text &&
                widget.data ==
                    '500 RWF' && // Corrected: No .0 for numbers < 1000
                widget.style?.fontSize == 28.0, // Main value font size
          ),
        ),
        findsOneWidget,
      );

      // Find the profit type text (smaller font size)
      expect(
        find.descendant(
          of: gaugeFinder,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Text &&
                widget.data == 'Net Profit' &&
                widget.style?.fontSize == 16.0, // Profit type font size
          ),
        ),
        findsOneWidget,
      );

      // Verify the color of the main profit text is green
      final profitText = tester.widget<Text>(
        find.descendant(
          of: gaugeFinder,
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Text &&
                widget.data ==
                    '500 RWF' && // Corrected: No .0 for numbers < 1000
                widget.style?.fontSize == 28.0,
          ),
        ),
      );
      expect(profitText.style?.color, Colors.green);

      // Verify the bottom value columns are visible and correct
      expect(find.text('Gross Profit'), findsOneWidget);
      expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Text &&
                widget.data == '1.0K RWF' && // Expect summarized format
                widget.style?.fontSize == 16.0, // Column value font size
          ),
          findsOneWidget);
      expect(find.text('Expenses'), findsOneWidget);
      expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Text &&
                widget.data ==
                    '500 RWF' && // Corrected: No .0 for numbers < 1000
                widget.style?.fontSize == 16.0, // Column value font size
          ),
          findsOneWidget);
    });

    testWidgets('displays loss correctly when red side is larger',
        (WidgetTester tester) async {
      await pumpGauge(
        tester,
        dataOnGreenSide: 500,
        dataOnRedSide: 1200,
        profitType: 'Net Profit',
      );

      // Verify the main loss value and label
      expect(find.text('700 RWF'),
          findsOneWidget); // Corrected: No .0 for numbers < 1000
      expect(find.text('Loss'), findsOneWidget);

      // Verify the color of the loss text is red
      final lossText = tester.widget<Text>(
          find.text('700 RWF')); // Corrected: No .0 for numbers < 1000
      expect(lossText.style?.color, Colors.red);
    });

    testWidgets('displays balanced state correctly when sides are equal',
        (WidgetTester tester) async {
      await pumpGauge(
        tester,
        dataOnGreenSide: 750,
        dataOnRedSide: 750,
        profitType: 'Net Profit',
      );

      // Verify the main value and label
      expect(find.text('0 RWF'), findsOneWidget);
      expect(find.text('Balanced'), findsOneWidget);

      // Verify the color of the text is grey
      final balancedText = tester.widget<Text>(find.text('0 RWF'));
      expect(balancedText.style?.color, Colors.grey);
    });

    testWidgets('displays no transactions state correctly when data is zero',
        (WidgetTester tester) async {
      await pumpGauge(
        tester,
        dataOnGreenSide: 0,
        dataOnRedSide: 0,
        profitType: 'Net Profit',
      );

      // Verify the main value (0 RWF with larger font size) and label
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data == '0 RWF' &&
              widget.style?.fontSize == 28.0, // Main value font size
        ),
        findsOneWidget,
      );
      expect(find.text('No transactions'), findsOneWidget);

      // Verify the column values (0 RWF with smaller font size)
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data == '0 RWF' &&
              widget.style?.fontSize == 16.0, // Column value font size
        ),
        findsNWidgets(2), // Expect two such widgets (Gross Profit and Expenses)
      );
    });

    testWidgets(
        'does not display value columns when areValueColumnsVisible is false',
        (WidgetTester tester) async {
      await pumpGauge(
        tester,
        dataOnGreenSide: 1000,
        dataOnRedSide: 500,
        profitType: 'Net Profit',
        areValueColumnsVisible: false,
      );

      // Verify the main profit value is still there
      expect(find.text('500 RWF'),
          findsOneWidget); // Corrected: No .0 for numbers < 1000

      // Verify the bottom value columns are NOT visible
      expect(find.text('Total Sales'), findsNothing);
      expect(find.text('Expenses'), findsNothing);
      expect(find.byType(Divider), findsNothing);
    });

    testWidgets(
        'displays gross profit correctly when profitType is "Gross Profit"',
        (WidgetTester tester) async {
      await pumpGauge(
        tester,
        dataOnGreenSide: 1500,
        dataOnRedSide: 500,
        profitType: 'Gross Profit',
      );

      // Verify the main value (1500 RWF) appears twice:
      // once as the large gauge value, and once as the column value.
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data == '1.5K RWF' && // Expect summarized format
              (widget.style?.fontSize == 28.0 ||
                  widget.style?.fontSize == 16.0),
        ),
        findsNWidgets(2),
      );

      // Verify the main label is "Gross Profit" (this is the text below the main value)
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data == 'Gross Profit' &&
              widget.style?.fontSize ==
                  16.0, // The label below the main value has this font size
        ),
        findsOneWidget,
      );

      // Verify the bottom value columns use the correct labels
      expect(find.text('Total Sales'), findsOneWidget);
      expect(find.text('Expenses'), findsOneWidget);
    });

    testWidgets('formats large numbers correctly', (WidgetTester tester) async {
      await pumpGauge(
        tester,
        dataOnGreenSide: 1234567890123,
        dataOnRedSide: 1000000000000,
        profitType: 'Net Profit',
      );

      // Expect the main value to be formatted as Trillions
      expect(find.text('234.6B RWF'), findsOneWidget);

      // Expect the column values to be formatted as Trillions
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data == '1.2T RWF' &&
              widget.style?.fontSize == 16.0,
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data == '1.0T RWF' &&
              widget.style?.fontSize == 16.0,
        ),
        findsOneWidget,
      );
    });
  });
}
