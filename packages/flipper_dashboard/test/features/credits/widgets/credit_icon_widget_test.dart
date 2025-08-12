import 'package:flipper_dashboard/features/credits/widgets/credit_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// flutter test test/features/credits/widgets/credit_icon_widget_test.dart
void main() {
  group('CreditIconWidget Tests', () {
    testWidgets('displays credits correctly', (tester) async {
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
    });

    testWidgets('displays zero credits', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditIconWidget(
              credits: 0,
              maxCredits: 100,
            ),
          ),
        ),
      );

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('displays full credits', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditIconWidget(
              credits: 100,
              maxCredits: 100,
            ),
          ),
        ),
      );

      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('handles zero max credits', (tester) async {
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

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 80.0);
      expect(sizedBox.height, 80.0);
    });

    testWidgets('uses default size when not specified', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditIconWidget(
              credits: 25,
              maxCredits: 100,
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, 60.0);
      expect(sizedBox.height, 60.0);
    });

    testWidgets('uses custom text style', (tester) async {
      const customStyle = TextStyle(
        color: Colors.red,
        fontSize: 20,
        fontWeight: FontWeight.w300,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditIconWidget(
              credits: 75,
              maxCredits: 100,
              textStyle: customStyle,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('75'));
      expect(textWidget.style?.color, Colors.red);
      expect(textWidget.style?.fontSize, 20);
      expect(textWidget.style?.fontWeight, FontWeight.w300);
    });

    testWidgets('has correct structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditIconWidget(
              credits: 30,
              maxCredits: 100,
            ),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(CustomPaint), findsAtLeastNWidgets(1));
      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('handles credits exceeding max credits', (tester) async {
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

    testWidgets('handles negative credits', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditIconWidget(
              credits: -10,
              maxCredits: 100,
            ),
          ),
        ),
      );

      expect(find.text('-10'), findsOneWidget);
    });

    testWidgets('centers text correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditIconWidget(
              credits: 99,
              maxCredits: 100,
            ),
          ),
        ),
      );

      expect(find.byType(Center), findsOneWidget);
      expect(find.text('99'), findsOneWidget);
    });
  });
}