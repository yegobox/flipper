import 'package:flipper_dashboard/features/admin/widgets/switch_settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// flutter test test/features/admin/widgets/switch_settings_card_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('SwitchSettingsCard Tests', () {
    testWidgets('displays title and subtitle correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwitchSettingsCard(
              title: 'Enable Notifications',
              subtitle: 'Receive push notifications for updates',
              icon: Icons.notifications,
              value: true,
              onChanged: (value) {},
              color: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.text('Enable Notifications'), findsOneWidget);
      expect(find.text('Receive push notifications for updates'), findsOneWidget);
    });

    testWidgets('displays icon with correct color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwitchSettingsCard(
              title: 'Dark Mode',
              subtitle: 'Switch to dark theme',
              icon: Icons.dark_mode,
              value: false,
              onChanged: (value) {},
              color: Colors.purple,
            ),
          ),
        ),
      );

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.dark_mode));
      expect(iconWidget.color, Colors.purple);
    });

    testWidgets('switch reflects correct value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwitchSettingsCard(
              title: 'Auto Save',
              subtitle: 'Automatically save changes',
              icon: Icons.save,
              value: true,
              onChanged: (value) {},
              color: Colors.green,
            ),
          ),
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, true);
      expect(switchWidget.activeColor, Colors.green);
    });

    testWidgets('calls onChanged when switch is tapped', (tester) async {
      bool switchValue = false;
      bool onChangedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwitchSettingsCard(
              title: 'Test Setting',
              subtitle: 'Test description',
              icon: Icons.settings,
              value: switchValue,
              onChanged: (value) {
                onChangedCalled = true;
                switchValue = value;
              },
              color: Colors.orange,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(onChangedCalled, true);
    });

    testWidgets('container has correct background color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwitchSettingsCard(
              title: 'Test',
              subtitle: 'Test subtitle',
              icon: Icons.science,
              value: false,
              onChanged: (value) {},
              color: Colors.red,
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.descendant(
        of: find.byType(SwitchSettingsCard),
        matching: find.byType(Container),
      ));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.red.withOpacity(0.1));
    });

    testWidgets('has correct card structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwitchSettingsCard(
              title: 'Structure Test',
              subtitle: 'Testing card structure',
              icon: Icons.architecture,
              value: true,
              onChanged: (value) {},
              color: Colors.teal,
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsNWidgets(2));
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('switch is disabled when onChanged is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwitchSettingsCard(
              title: 'Disabled Setting',
              subtitle: 'This setting is disabled',
              icon: Icons.block,
              value: false,
              onChanged: (value) {},
              color: Colors.grey,
            ),
          ),
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.onChanged, isNotNull);
    });
  });
}