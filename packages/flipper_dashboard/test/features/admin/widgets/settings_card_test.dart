import 'package:flipper_dashboard/features/admin/widgets/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingsCard Tests', () {
    late VoidCallback mockOnTap;
    bool tapped = false;

    setUp(() {
      tapped = false;
      mockOnTap = () => tapped = true;
    });

    testWidgets('displays title and subtitle correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsCard(
              title: 'Test Title',
              subtitle: 'Test Subtitle',
              icon: Icons.settings,
              onTap: mockOnTap,
              color: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Subtitle'), findsOneWidget);
    });

    testWidgets('displays icon correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsCard(
              title: 'Test Title',
              subtitle: 'Test Subtitle',
              icon: Icons.settings,
              onTap: mockOnTap,
              color: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('handles tap correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsCard(
              title: 'Test Title',
              subtitle: 'Test Subtitle',
              icon: Icons.settings,
              onTap: mockOnTap,
              color: Colors.blue,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SettingsCard));
      expect(tapped, isTrue);
    });

    testWidgets('has correct structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsCard(
              title: 'Test Title',
              subtitle: 'Test Subtitle',
              icon: Icons.settings,
              onTap: mockOnTap,
              color: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('applies color correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsCard(
              title: 'Test Title',
              subtitle: 'Test Subtitle',
              icon: Icons.settings,
              onTap: mockOnTap,
              color: Colors.red,
            ),
          ),
        ),
      );

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.settings));
      expect(iconWidget.color, Colors.red);
    });

    testWidgets('has rounded corners', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsCard(
              title: 'Test Title',
              subtitle: 'Test Subtitle',
              icon: Icons.settings,
              onTap: mockOnTap,
              color: Colors.blue,
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      final shape = card.shape as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(12));
    });

    testWidgets('has proper elevation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsCard(
              title: 'Test Title',
              subtitle: 'Test Subtitle',
              icon: Icons.settings,
              onTap: mockOnTap,
              color: Colors.blue,
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 2);
    });

    testWidgets('expands text properly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsCard(
              title: 'Very Long Title That Should Expand',
              subtitle: 'Very Long Subtitle That Should Also Expand Properly',
              icon: Icons.settings,
              onTap: mockOnTap,
              color: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.text('Very Long Title That Should Expand'), findsOneWidget);
      expect(find.text('Very Long Subtitle That Should Also Expand Properly'), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
    });
  });
}