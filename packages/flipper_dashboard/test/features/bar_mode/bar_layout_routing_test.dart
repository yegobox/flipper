import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_floor_desktop.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_floor_mobile.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_lock_desktop.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_lock_mobile.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_lock_screen.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_keypad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

Widget _barTestApp({
  required Size size,
  required Widget child,
  BarModeState? barState,
  List<BarTable> tables = const [],
}) {
  return ProviderScope(
    overrides: [
      barStaffProvider.overrideWith((ref) async => <Tenant>[]),
      barTablesProvider.overrideWith((ref) => Stream.value(tables)),
      barTabsProvider.overrideWith((ref) => Stream.value([])),
      if (barState != null)
        barModeProvider.overrideWith(() => _FixedBarModeNotifier(barState)),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(size: size),
          child: child,
        ),
      ),
    ),
  );
}

class _FixedBarModeNotifier extends BarModeNotifier {
  _FixedBarModeNotifier(this.initial);

  final BarModeState initial;

  @override
  BarModeState build() => initial;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BarLayoutBreakpoints', () {
    test('mobile below 600px', () {
      expect(BarLayoutBreakpoints.isBarMobileLayout(599), isTrue);
      expect(BarLayoutBreakpoints.isBarMobileLayout(600), isFalse);
      expect(BarLayoutBreakpoints.isBarMobileLayout(1440), isFalse);
    });
  });

  group('breakpoint routing', () {
    testWidgets('BarLockScreen routes to desktop at 1440px', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 912));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _barTestApp(size: const Size(1440, 912), child: const BarLockScreen()),
      );
      await tester.pump();

      expect(find.byType(BarLockDesktopScreen), findsOneWidget);
      expect(find.byType(BarLockMobileScreen), findsNothing);
    });

    testWidgets('BarLockScreen routes to mobile at 390px', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _barTestApp(size: const Size(390, 844), child: const BarLockScreen()),
      );
      await tester.pump();

      expect(find.byType(BarLockMobileScreen), findsOneWidget);
      expect(find.byType(BarLockDesktopScreen), findsNothing);
    });

    testWidgets('desktop lock shows register picker copy', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 912));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _barTestApp(
          size: const Size(1440, 912),
          child: const BarLockDesktopScreen(),
        ),
      );
      await tester.pump();

      expect(find.text("WHO'S ON THE REGISTER?"), findsOneWidget);
    });

    testWidgets('mobile lock shows serving copy', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _barTestApp(
          size: const Size(390, 844),
          child: const BarLockMobileScreen(),
        ),
      );
      await tester.pump();

      expect(find.text("Who's serving?"), findsOneWidget);
    });

    testWidgets('desktop floor shows legend row', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 912));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _barTestApp(
          size: const Size(1440, 912),
          child: const BarFloorDesktopScreen(),
          barState: BarModeState(
            screen: BarScreen.tables,
            activeCashier: Tenant(id: 't1', name: 'Server'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Free'), findsOneWidget);
    });

    testWidgets('mobile floor uses 2-column grid', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _barTestApp(
          size: const Size(390, 844),
          child: const BarFloorMobileScreen(),
          barState: BarModeState(
            screen: BarScreen.tables,
            activeCashier: Tenant(id: 't1', name: 'Server'),
          ),
          tables: const [
            BarTable(
              id: '1',
              branchId: 'b1',
              zoneId: 'z1',
              zoneName: 'Main',
              name: 'T1',
              seats: 4,
            ),
            BarTable(
              id: '2',
              branchId: 'b1',
              zoneId: 'z1',
              zoneName: 'Main',
              name: 'T2',
              seats: 2,
            ),
          ],
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Free'), findsNothing);
      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate = grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);
    });
  });

  testWidgets('BarKeypad mobile uses 62px key height', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BarKeypad(
            mobile: true,
            enabled: true,
            title: 'Test',
            hint: 'Enter PIN',
            onSubmit: (_) {},
          ),
        ),
      ),
    );
    await tester.pump();

    final containers = tester.widgetList<Container>(
      find.descendant(
        of: find.byType(GridView),
        matching: find.byType(Container),
      ),
    );
    final keyContainer = containers.firstWhere(
      (c) => c.constraints?.maxHeight == 62 || c.constraints?.minHeight == 62,
      orElse: () => containers.first,
    );
    expect(
      keyContainer.constraints?.maxHeight ?? keyContainer.constraints?.minHeight,
      62,
    );
  });
}
