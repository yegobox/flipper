import 'package:flipper_dashboard/features/credits/widgets/credit_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// flutter test test/features/credits/widgets/credit_icon_widget_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('CreditIconWidget Tests', () {
    testWidgets('displays correct credit amount', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditIconWidget(
              credits: 75,
              maxCredits: 100,
            ),
          ),
        ),
      );

      expect(find.text('75'), findsOneWidget);
    });

    testWidgets('calculates percentage correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditIconWidget(
              credits: 50,
              maxCredits: 100,
            ),
          ),
        ),
      );

      expect(find.text('50'), findsOneWidget);
      expect(find.byType(CreditIconWidget), findsOneWidget);
    });

    testWidgets('handles zero maxCredits', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditIconWidget(
              credits: 10,
              maxCredits: 0,
            ),
          ),
        ),
      );

      expect(find.text('10'), findsOneWidget);
      expect(find.byType(CreditIconWidget), findsOneWidget);
    });

    testWidgets('clamps percentage above 1.0', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditIconWidget(
              credits: 150,
              maxCredits: 100,
            ),
          ),
        ),
      );

      expect(find.text('150'), findsOneWidget);
    });

    testWidgets('uses custom text style when provided', (tester) async {
      const customStyle = TextStyle(
        color: Colors.purple,
        fontSize: 20,
        fontWeight: FontWeight.w300,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditIconWidget(
              credits: 25,
              maxCredits: 100,
              textStyle: customStyle,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('25'));
      expect(textWidget.style?.color, Colors.purple);
      expect(textWidget.style?.fontSize, 20);
      expect(textWidget.style?.fontWeight, FontWeight.w300);
    });

    testWidgets('uses custom size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditIconWidget(
              credits: 25,
              maxCredits: 100,
              size: 80.0,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.descendant(
        of: find.byType(CreditIconWidget),
        matching: find.byType(SizedBox),
      ));
      expect(sizedBox.width, 80.0);
      expect(sizedBox.height, 80.0);
    });

    testWidgets('applies correct text color for high credits', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditIconWidget(
              credits: 80,
              maxCredits: 100,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('80'));
      expect(textWidget.style?.color, const Color(0xFF2E7D32));
    });

    testWidgets('applies correct text color for medium credits', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditIconWidget(
              credits: 50,
              maxCredits: 100,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('50'));
      expect(textWidget.style?.color, const Color(0xFFF57F17));
    });

    testWidgets('applies correct text color for low credits', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditIconWidget(
              credits: 20,
              maxCredits: 100,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('20'));
      expect(textWidget.style?.color, const Color(0xFFB71C1C));
    });
  });
}