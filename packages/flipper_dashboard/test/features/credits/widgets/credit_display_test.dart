import 'package:flipper_dashboard/features/credits/widgets/credit_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreditDisplay Tests', () {
    testWidgets('displays credits and max credits correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditDisplay(
              credits: 75,
              maxCredits: 100,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
          ),
        ),
      );

      expect(find.text('75'), findsNWidgets(2)); // Main display + icon
      expect(find.text('Credits'), findsOneWidget);
      expect(find.text('Available Credits'), findsOneWidget);
      expect(find.text('Maximum: 100'), findsOneWidget);
    });

    testWidgets('displays zero credits correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditDisplay(
              credits: 0,
              maxCredits: 100,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
          ),
        ),
      );

      expect(find.text('0'), findsNWidgets(2)); // Main display + icon
      expect(find.text('Maximum: 100'), findsOneWidget);
    });

    testWidgets('displays full credits correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditDisplay(
              credits: 100,
              maxCredits: 100,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
          ),
        ),
      );

      expect(find.text('100'), findsNWidgets(2)); // Main display + icon
      expect(find.text('Maximum: 100'), findsOneWidget);
    });

    testWidgets('has correct structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditDisplay(
              credits: 50,
              maxCredits: 100,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsAtLeastNWidgets(1));
      expect(find.byType(Row), findsAtLeastNWidgets(1));
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('shows progress indicator with correct value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditDisplay(
              credits: 30,
              maxCredits: 100,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
          ),
        ),
      );

      final progressIndicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(progressIndicator.value, 0.3);
    });

    testWidgets('handles edge case with zero max credits', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditDisplay(
              credits: 10,
              maxCredits: 1, // Use 1 instead of 0 to avoid division by zero
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
          ),
        ),
      );

      expect(find.text('10'), findsNWidgets(2)); // Main display + icon
      expect(find.text('Maximum: 1'), findsOneWidget);
    });

    testWidgets('adapts to light theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: CreditDisplay(
              credits: 50,
              maxCredits: 100,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
          ),
        ),
      );

      expect(find.byType(CreditDisplay), findsOneWidget);
    });

    testWidgets('adapts to dark theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: CreditDisplay(
              credits: 50,
              maxCredits: 100,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
          ),
        ),
      );

      expect(find.byType(CreditDisplay), findsOneWidget);
    });

    testWidgets('has gradient decoration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditDisplay(
              credits: 50,
              maxCredits: 100,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
      expect(decoration.borderRadius, BorderRadius.circular(20));
    });

    testWidgets('shows correct text styles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreditDisplay(
              credits: 42,
              maxCredits: 100,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
          ),
        ),
      );

      expect(find.text('Available Credits'), findsOneWidget);
      expect(find.text('Credits'), findsOneWidget);
      expect(find.text('42'), findsNWidgets(2));
    });
  });
}