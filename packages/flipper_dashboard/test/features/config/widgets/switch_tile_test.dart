import 'package:flipper_dashboard/features/config/widgets/switch_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// flutter test test/features/config/widgets/switch_tile_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  group('TaxConfigSwitchTile Tests', () {
    late ValueChanged<bool> mockOnChanged;
    bool switchValue = false;

    setUp(() {
      switchValue = false;
      mockOnChanged = (value) => switchValue = value;
    });

    testWidgets('displays title correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaxConfigSwitchTile(
              title: 'Test Switch',
              value: false,
              onChanged: mockOnChanged,
            ),
          ),
        ),
      );

      expect(find.text('Test Switch'), findsOneWidget);
    });

    testWidgets('displays title and subtitle correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaxConfigSwitchTile(
              title: 'Test Switch',
              subtitle: 'Test Description',
              value: false,
              onChanged: mockOnChanged,
            ),
          ),
        ),
      );

      expect(find.text('Test Switch'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('displays icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaxConfigSwitchTile(
              title: 'Test Switch',
              value: false,
              onChanged: mockOnChanged,
              icon: Icons.settings,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('handles switch toggle correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return TaxConfigSwitchTile(
                  title: 'Test Switch',
                  value: switchValue,
                  onChanged: (value) {
                    setState(() {
                      switchValue = value;
                    });
                  },
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

    testWidgets('shows correct switch state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaxConfigSwitchTile(
              title: 'Test Switch',
              value: true,
              onChanged: mockOnChanged,
            ),
          ),
        ),
      );

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isTrue);
    });

    testWidgets('has correct structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaxConfigSwitchTile(
              title: 'Test Switch',
              value: false,
              onChanged: mockOnChanged,
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedContainer), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('handles tap on entire tile', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return TaxConfigSwitchTile(
                  title: 'Test Switch',
                  value: switchValue,
                  onChanged: (value) {
                    setState(() {
                      switchValue = value;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(switchValue, isFalse);
      
      await tester.tap(find.byType(TaxConfigSwitchTile));
      await tester.pump();
      
      expect(switchValue, isTrue);
    });

    testWidgets('shows icon container when icon provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaxConfigSwitchTile(
              title: 'Test Switch',
              value: true,
              onChanged: mockOnChanged,
              icon: Icons.receipt,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.receipt), findsOneWidget);
      expect(find.byType(Container), findsAtLeastNWidgets(2)); // Icon container + main container
    });

    testWidgets('handles subtitle correctly when null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaxConfigSwitchTile(
              title: 'Test Switch',
              subtitle: null,
              value: false,
              onChanged: mockOnChanged,
            ),
          ),
        ),
      );

      expect(find.text('Test Switch'), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('applies correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaxConfigSwitchTile(
              title: 'Test Switch',
              value: false,
              onChanged: mockOnChanged,
            ),
          ),
        ),
      );

      final container = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(12));
    });

    testWidgets('handles mouse hover states', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaxConfigSwitchTile(
              title: 'Test Switch',
              value: false,
              onChanged: mockOnChanged,
            ),
          ),
        ),
      );

      expect(find.byType(MouseRegion), findsAtLeastNWidgets(1));
      expect(find.byType(GestureDetector), findsAtLeastNWidgets(1));
    });
  });
}