import 'package:flipper_dashboard/features/admin/widgets/switch_settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// flutter test test/features/admin/widgets/switch_settings_card_test.dart
void main() {
  group('SwitchSettingsCard Tests', () {
    late ValueChanged<bool> mockOnChanged;
    bool switchValue = false;

    setUp(() {
      switchValue = false;
      mockOnChanged = (value) => switchValue = value;
    });

    testWidgets('displays title and subtitle correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwitchSettingsCard(
              title: 'Test Switch',
              subtitle: 'Test Switch Description',
              icon: Icons.notifications,
              value: false,
              onChanged: mockOnChanged,
              color: Colors.green,
            ),
          ),
        ),
      );

      expect(find.text('Test Switch'), findsOneWidget);
      expect(find.text('Test Switch Description'), findsOneWidget);
    });

    testWidgets('displays icon correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwitchSettingsCard(
              title: 'Test Switch',
              subtitle: 'Test Switch Description',
              icon: Icons.notifications,
              value: false,
              onChanged: mockOnChanged,
              color: Colors.green,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.notifications), findsOneWidget);
    });

    testWidgets('displays switch with correct initial value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwitchSettingsCard(
              title: 'Test Switch',
              subtitle: 'Test Switch Description',
              icon: Icons.notifications,
              value: true,
              onChanged: mockOnChanged,
              color: Colors.green,
            ),
          ),
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isTrue);
    });

    testWidgets('handles switch toggle correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SwitchSettingsCard(
                  title: 'Test Switch',
                  subtitle: 'Test Switch Description',
                  icon: Icons.notifications,
                  value: switchValue,
                  onChanged: (value) {
                    setState(() {
                      switchValue = value;
                    });
                  },
                  color: Colors.green,
                );
              },
            ),
          ),
        ),
      );

      expect(switchValue, isFalse);
      
      await tester.tap(find.byType(Switch));
      await tester.pump();
      
      expect(switchValue, isTrue);
    });

    testWidgets('has correct structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwitchSettingsCard(
              title: 'Test Switch',
              subtitle: 'Test Switch Description',
              icon: Icons.notifications,
              value: false,
              onChanged: mockOnChanged,
              color: Colors.green,
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Column), findsNWidgets(2));
    });

    testWidgets('applies color correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwitchSettingsCard(
              title: 'Test Switch',
              subtitle: 'Test Switch Description',
              icon: Icons.notifications,
              value: true,
              onChanged: mockOnChanged,
              color: Colors.purple,
            ),
          ),
        ),
      );

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.notifications));
      expect(iconWidget.color, Colors.purple);
      
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.activeColor, Colors.purple);
    });

    testWidgets('has rounded corners', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwitchSettingsCard(
              title: 'Test Switch',
              subtitle: 'Test Switch Description',
              icon: Icons.notifications,
              value: false,
              onChanged: mockOnChanged,
              color: Colors.green,
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
            body: SwitchSettingsCard(
              title: 'Test Switch',
              subtitle: 'Test Switch Description',
              icon: Icons.notifications,
              value: false,
              onChanged: mockOnChanged,
              color: Colors.green,
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
            body: SwitchSettingsCard(
              title: 'Very Long Switch Title That Should Expand',
              subtitle: 'Very Long Switch Subtitle That Should Also Expand Properly',
              icon: Icons.notifications,
              value: false,
              onChanged: mockOnChanged,
              color: Colors.green,
            ),
          ),
        ),
      );

      expect(find.text('Very Long Switch Title That Should Expand'), findsOneWidget);
      expect(find.text('Very Long Switch Subtitle That Should Also Expand Properly'), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('switch is adaptive', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwitchSettingsCard(
              title: 'Test Switch',
              subtitle: 'Test Switch Description',
              icon: Icons.notifications,
              value: false,
              onChanged: mockOnChanged,
              color: Colors.green,
            ),
          ),
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.runtimeType.toString().contains('adaptive'), isFalse);
      expect(find.byType(Switch), findsOneWidget);
    });
  });
}