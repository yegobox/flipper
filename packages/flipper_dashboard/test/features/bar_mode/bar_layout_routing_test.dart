import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_localize/flipper_localize.dart';
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
import 'package:supabase_models/brick/models/transaction.model.dart';

Widget _barTestApp({
  required Size size,
  required Widget child,
  BarModeState? barState,
  List<BarTable> tables = const [],
  List<ITransaction> loans = const [],
}) {
  return ProviderScope(
    overrides: [
      barStaffProvider.overrideWith((ref) async => <Tenant>[]),
      barTablesProvider.overrideWith((ref) => Stream.value(tables)),
      barTabsProvider.overrideWith((ref) => Stream.value([])),
      barCreditTabsProvider.overrideWith((ref) => Stream.value(loans)),
      if (barState != null)
        barModeProvider.overrideWith(() => _FixedBarModeNotifier(barState)),
    ],
    child: MaterialApp(
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(size: size),
          child: child,
        ),
      ),
    ),
  );
}

ITransaction _loan(String id) => ITransaction(
  id: id,
  branchId: 'b1',
  status: 'parked',
  transactionType: 'Sale',
  paymentType: 'CREDIT',
  subTotal: 3000,
  cashReceived: 0,
  customerChangeDue: 0,
  isIncome: true,
  isExpense: false,
  agentId: 't1',
  isLoan: true,
  remainingBalance: 3000,
  updatedAt: DateTime.now().toUtc(),
);

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
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);
    });
  });

  group('floor headers', () {
    Future<void> pumpFloor(
      WidgetTester tester,
      Size size,
      Widget screen, {
      required String cashierName,
      List<ITransaction> loans = const [],
    }) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        _barTestApp(
          size: size,
          child: screen,
          barState: BarModeState(
            screen: BarScreen.tables,
            activeCashier: Tenant(id: 't1', name: cashierName),
          ),
          loans: loans,
        ),
      );
      await tester.pump();
      await tester.pump();
    }

    testWidgets('a 320pt phone with loans fits the cashier by the title', (
      tester,
    ) async {
      await pumpFloor(
        tester,
        const Size(320, 700),
        const BarFloorMobileScreen(),
        cashierName: 'Uwimana Jean-Baptiste Nshimiyimana',
        loans: [_loan('loan-1'), _loan('loan-2')],
      );

      expect(tester.takeException(), isNull);
      final chip = tester.getRect(
        find.byKey(const ValueKey('bar_m_cashier_chip')),
      );
      final logout = tester.getRect(find.byIcon(Icons.logout));
      expect(chip.right, lessThanOrEqualTo(320));
      expect(chip.top, greaterThan(logout.bottom));
      expect(logout.right, lessThanOrEqualTo(320));
    });

    testWidgets('desktop keeps logout on the right edge', (tester) async {
      await pumpFloor(
        tester,
        const Size(1440, 912),
        const BarFloorDesktopScreen(),
        cashierName: 'Al',
      );

      expect(tester.takeException(), isNull);
      final logout = find.ancestor(
        of: find.byIcon(Icons.logout),
        matching: find.byType(InkWell),
      );
      // The header pads 30 on each side.
      expect(tester.getRect(logout).right, 1440 - 30);
    });

    testWidgets('desktop gives a long name the free width', (tester) async {
      await pumpFloor(
        tester,
        const Size(1024, 912),
        const BarFloorDesktopScreen(),
        cashierName: 'Uwimana Jean-Baptiste Nshimiyimana wa Kigali',
        loans: [_loan('loan-1')],
      );

      expect(tester.takeException(), isNull);
      final chip = tester.getRect(
        find.byKey(const ValueKey('bar_d_cashier_chip')),
      );
      final logout = tester.getRect(
        find.ancestor(
          of: find.byIcon(Icons.logout),
          matching: find.byType(InkWell),
        ),
      );
      expect(logout.right, 1024 - 30);
      expect(chip.right, lessThan(logout.left));
    });
  });

  testWidgets('BarKeypad mobile uses 62px key height', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
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
      keyContainer.constraints?.maxHeight ??
          keyContainer.constraints?.minHeight,
      62,
    );
  });
}
