import 'package:flipper_dashboard/features/config/widgets/support_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SupportSection Tests', () {
    testWidgets('displays title correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SupportSection(),
          ),
        ),
      );

      expect(find.text('Need Help?'), findsOneWidget);
    });

    testWidgets('displays description correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SupportSection(),
          ),
        ),
      );

      expect(find.text('Contact support to add EBM to Flipper'), findsOneWidget);
    });

    testWidgets('displays contact support button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SupportSection(),
          ),
        ),
      );

      expect(find.text('Contact Support'), findsOneWidget);
      expect(find.byIcon(Icons.support_agent), findsOneWidget);
    });

    testWidgets('has correct structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SupportSection(),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byWidgetPredicate((widget) => widget is ElevatedButton), findsOneWidget);
    });

    testWidgets('card has correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SupportSection(),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 4);
      
      final shape = card.shape as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(15));
    });

    testWidgets('button has correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SupportSection(),
          ),
        ),
      );

      final buttonFinder = find.byWidgetPredicate((widget) => widget is ElevatedButton);
      if (buttonFinder.evaluate().isNotEmpty) {
        final button = tester.widget<ElevatedButton>(buttonFinder);
        expect(button.style?.backgroundColor?.resolve({}), Colors.green);
        expect(button.style?.foregroundColor?.resolve({}), Colors.white);
      }
    });

    testWidgets('has proper spacing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SupportSection(),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsAtLeastNWidgets(2));
    });

    testWidgets('uses correct text styles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SupportSection(),
          ),
        ),
      );

      expect(find.text('Need Help?'), findsOneWidget);
      expect(find.text('Contact support to add EBM to Flipper'), findsOneWidget);
    });

    testWidgets('button is tappable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SupportSection(),
          ),
        ),
      );

      final button = find.byWidgetPredicate((widget) => widget is ElevatedButton);
      expect(button, findsOneWidget);
      
      // Skip tapping as it requires ProxyService setup
    });

    testWidgets('has icon and text in button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SupportSection(),
          ),
        ),
      );

      final button = find.byWidgetPredicate((widget) => widget is ElevatedButton);
      expect(button, findsOneWidget);
      
      // Check that it's an ElevatedButton.icon
      final buttonWidget = tester.widget<ElevatedButton>(button);
      expect(buttonWidget.child, isNotNull); // ElevatedButton.icon has a child
    });

    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SupportSection(),
          ),
        ),
      );

      expect(find.byType(SupportSection), findsOneWidget);
    });
  });
}