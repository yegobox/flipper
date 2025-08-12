import 'package:flipper_dashboard/features/config/widgets/switch_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// flutter test test/features/config/widgets/switch_tile_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('TaxConfigSwitchTile Tests', () {
    testWidgets('displays title correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaxConfigSwitchTile(
              title: 'Enable Tax Calculation',
              value: true,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.text('Enable Tax Calculation'), findsOneWidget);
    });

    testWidgets('displays title and subtitle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaxConfigSwitchTile(
              title: 'Auto Tax',
              subtitle: 'Automatically calculate tax on transactions',
              value: false,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.text('Auto Tax'), findsOneWidget);
      expect(find.text('Automatically calculate tax on transactions'), findsOneWidget);
    });

    testWidgets('displays icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaxConfigSwitchTile(
              title: 'Tax Settings',
              value: true,
              onChanged: (value) {},
              icon: Icons.calculate,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.calculate), findsOneWidget);
    });

    testWidgets('switch reflects correct value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaxConfigSwitchTile(
              title: 'Test Switch',
              value: true,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, true);
    });

    testWidgets('calls onChanged when tapped', (tester) async {
      bool switchValue = false;
      bool onChangedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaxConfigSwitchTile(
              title: 'Tap Test',
              value: switchValue,
              onChanged: (value) {
                onChangedCalled = true;
                switchValue = value;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TaxConfigSwitchTile));
      await tester.pumpAndSettle();

      expect(onChangedCalled, true);
    });

    testWidgets('shows different icon colors based on value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TaxConfigSwitchTile(
                  title: 'Enabled',
                  value: true,
                  onChanged: (value) {},
                  icon: Icons.check,
                ),
                TaxConfigSwitchTile(
                  title: 'Disabled',
                  value: false,
                  onChanged: (value) {},
                  icon: Icons.close,
                ),
              ],
            ),
          ),
        ),
      );

      final enabledIcon = tester.widget<Icon>(find.byIcon(Icons.check));
      final disabledIcon = tester.widget<Icon>(find.byIcon(Icons.close));

      expect(enabledIcon.color, const Color(0xFF0078D4));
      expect(disabledIcon.color, isNot(const Color(0xFF0078D4)));
    });

    testWidgets('has correct structure without subtitle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaxConfigSwitchTile(
              title: 'Simple Title',
              value: false,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('switch can be toggled directly', (tester) async {
      bool switchValue = false;
      bool onChangedCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaxConfigSwitchTile(
              title: 'Switch Test',
              value: switchValue,
              onChanged: (value) {
                onChangedCalled = true;
                switchValue = value;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(onChangedCalled, true);
    });
  });
}