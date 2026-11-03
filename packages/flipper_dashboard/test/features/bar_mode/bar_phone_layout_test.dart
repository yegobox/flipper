import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_floor_mobile.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_lock_mobile.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_keypad.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_manager_pin_modal.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_tab_bottom_sheet.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_lock_mobile.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_manager_pin_modal.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/sync/utils/service_mode_access.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

/// A short phone: the tab sheet's footer used to overflow here.
const _phone = Size(360, 640);

void _useView(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Widget _app(Widget body) => MaterialApp(
  localizationsDelegates: FlipperLocalizationDelegates.delegates,
  supportedLocales: FlipperLocalizationDelegates.supportedLocales,
  home: Scaffold(body: body),
);

List<TransactionItem> _lines(int count) => [
  for (var i = 0; i < count; i++)
    TransactionItem(
      name: 'Primus $i',
      qty: 1,
      price: 1500,
      discount: 0,
      prc: 1500,
      ttCatCd: 'B',
      loggedByTenantId: 't1',
    ),
];

Future<void> _pumpTabSheet(WidgetTester tester, List<TransactionItem> lines) {
  final cashier = Tenant(id: 't1', name: 'Server');
  return tester.pumpWidget(
    _app(
      BarTabBottomSheet(
        tableName: 'Muvinga',
        zoneName: 'Main Bar',
        lines: lines,
        grouped: {if (lines.isNotEmpty) 't1': lines},
        staff: [cashier],
        cashier: cashier,
        // Managers skip the settle-PIN setting, which reads the box.
        isManager: true,
        total: 1500.0 * lines.length,
        lineCount: lines.length,
        serverCount: 1,
        myLines: lines.length,
        onClose: () {},
        onQtyDelta: (_, _) {},
        onSaveToTab: () {},
        onBackToTables: () {},
        onSettle: () {},
        onPrint: () {},
      ),
    ),
  );
}

/// The roster the lock screens read; a test edits it, then refreshes.
List<Tenant> _roster = [];

/// No userId: a PIN that does not match locally is rejected without asking
/// the server.
Tenant _staff(String id, String name, int pin) =>
    Tenant(id: id, name: name, pin: pin);

List<Override> _lockOverrides() => [
  barStaffProvider.overrideWith((ref) async => _roster),
  serviceModeGrantsProvider.overrideWith(
    (ref) async => const ServiceModeGrants(),
  ),
  barTablesProvider.overrideWith((ref) => Stream.value([])),
  hotelRoomsProvider.overrideWith((ref) => Stream.value([])),
  hotelStaysProvider.overrideWith((ref) => Stream.value([])),
];

/// Pumps [screen], picks [name] from the people strip, then swaps the roster
/// for [refreshed] as a pull-to-refresh would. Returns the scope's container.
Future<ProviderContainer> _pickThenRefresh(
  WidgetTester tester,
  Widget screen, {
  required String name,
  required List<Tenant> refreshed,
}) async {
  _useView(tester, _phone);
  await tester.pumpWidget(
    ProviderScope(overrides: _lockOverrides(), child: _app(screen)),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text(name));
  await tester.pumpAndSettle();
  final container = ProviderScope.containerOf(
    tester.element(find.byType(screen.runtimeType)),
  );
  _roster = refreshed;
  container.invalidate(barStaffProvider);
  await tester.pumpAndSettle();
  return container;
}

class _SignedInBar extends BarModeNotifier {
  @override
  BarModeState build() => BarModeState(
    screen: BarScreen.tables,
    activeCashier: Tenant(id: 't1', name: 'Server'),
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

Future<void> _enterPin(WidgetTester tester, String pin) async {
  for (final digit in pin.split('')) {
    await tester.tap(find.text(digit).last);
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('tab sheet on a short phone', () {
    testWidgets('lines and actions scroll together without overflow', (
      tester,
    ) async {
      _useView(tester, _phone);
      await _pumpTabSheet(tester, _lines(8));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // The last action is built and reached by scrolling the one list.
      final settle = find.text('Settle bill & close table');
      await tester.scrollUntilVisible(
        settle,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(settle, findsOneWidget);

      // Print sits below Settle and is reached the same way, inside the list.
      final print = find.byKey(const ValueKey('bar_tab_sheet_print'));
      final list = find.byType(Scrollable).first;
      // Built ahead of the viewport already, so scrolled to rather than
      // searched for.
      await tester.ensureVisible(print);
      await tester.pumpAndSettle();
      expect(print, findsOneWidget);
      expect(
        tester.getRect(print).bottom,
        lessThanOrEqualTo(tester.getRect(list).bottom),
      );
    });

    testWidgets('a long tab builds only the lines on screen', (tester) async {
      _useView(tester, _phone);
      await _pumpTabSheet(tester, _lines(200));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Primus 0'), findsOneWidget);
      expect(find.text('Primus 199', skipOffstage: false), findsNothing);
    });

    testWidgets('a tall phone keeps the actions pinned under the lines', (
      tester,
    ) async {
      _useView(tester, const Size(400, 900));
      await _pumpTabSheet(tester, _lines(3));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(Scrollable), findsOneWidget);
      // Pinned: the actions are not inside the lines' list.
      expect(find.text('Settle bill & close table'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(Scrollable),
          matching: find.text('Settle bill & close table'),
        ),
        findsNothing,
      );
    });

    testWidgets('qty buttons are thumb-sized', (tester) async {
      _useView(tester, _phone);
      await _pumpTabSheet(tester, _lines(1));
      await tester.pumpAndSettle();
      final plus = find.ancestor(
        of: find.byIcon(Icons.add),
        matching: find.byType(Container),
      );
      expect(tester.getSize(plus.first), const Size(40, 40));
    });
  });

  group('floor header on a phone', () {
    testWidgets('a 320pt phone with loans still fits the close button', (
      tester,
    ) async {
      _useView(tester, const Size(320, 700));
      // Larger system text, as many phones run: the header had ~6pt to spare
      // at the default size.
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ..._lockOverrides(),
            barTabsProvider.overrideWith((ref) => Stream.value([])),
            barCreditTabsProvider.overrideWith(
              (ref) => Stream.value([_loan('loan-1'), _loan('loan-2')]),
            ),
            barModeProvider.overrideWith(_SignedInBar.new),
          ],
          // The close button shows only with a route to go back to.
          child: _app(
            Builder(
              builder: (context) => TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const BarFloorMobileScreen(),
                  ),
                ),
                child: const Text('HOME'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('HOME'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final close = tester.getRect(find.byIcon(Icons.close));
      expect(close.right, lessThanOrEqualTo(320));
      expect(
        tester.getRect(find.byIcon(Icons.logout)).right,
        lessThan(close.left),
      );
    });
  });

  group('manager PIN on a phone', () {
    testWidgets('bar: phone keypad, no overflow', (tester) async {
      _useView(tester, _phone);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [barSignInStaffProvider.overrideWith((ref) async => [])],
          child: _app(const BarManagerPinModal()),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(tester.widget<BarKeypad>(find.byType(BarKeypad)).mobile, isTrue);
    });

    testWidgets('bar: the desk keeps its dense keypad', (tester) async {
      _useView(tester, const Size(1440, 912));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [barSignInStaffProvider.overrideWith((ref) async => [])],
          child: _app(const BarManagerPinModal()),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.widget<BarKeypad>(find.byType(BarKeypad)).mobile, isFalse);
    });

    testWidgets('bar: a narrow pane in a wide window gets the phone keypad', (
      tester,
    ) async {
      _useView(tester, const Size(1440, 912));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [barSignInStaffProvider.overrideWith((ref) async => [])],
          child: _app(
            const Center(
              child: SizedBox(width: 360, child: BarManagerPinModal()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.widget<BarKeypad>(find.byType(BarKeypad)).mobile, isTrue);
    });

    testWidgets('hotel: phone keypad, no overflow', (tester) async {
      _useView(tester, _phone);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [hotelStaffProvider.overrideWith((ref) async => [])],
          child: _app(const HotelManagerPinModal()),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(tester.widget<BarKeypad>(find.byType(BarKeypad)).mobile, isTrue);
    });
  });

  group('phone sign-in follows a refreshed roster', () {
    setUp(
      () => _roster = [
        _staff('t1', 'Aline', 111111),
        _staff('t2', 'Bosco', 222222),
      ],
    );

    testWidgets('bar: a cashier dropped from the roster cannot sign in', (
      tester,
    ) async {
      final container = await _pickThenRefresh(
        tester,
        const BarLockMobileScreen(),
        name: 'Aline',
        refreshed: [_staff('t2', 'Bosco', 222222)],
      );
      await _enterPin(tester, '111111');
      expect(container.read(barModeProvider).activeCashier, isNull);
    });

    testWidgets('bar: a changed PIN replaces the old one', (tester) async {
      final container = await _pickThenRefresh(
        tester,
        const BarLockMobileScreen(),
        name: 'Aline',
        refreshed: [_staff('t1', 'Aline', 333333)],
      );
      await _enterPin(tester, '111111');
      expect(container.read(barModeProvider).activeCashier, isNull);
      await _enterPin(tester, '333333');
      expect(container.read(barModeProvider).activeCashier?.pin, 333333);
    });

    testWidgets('hotel: a clerk dropped from the roster cannot sign in', (
      tester,
    ) async {
      final container = await _pickThenRefresh(
        tester,
        const HotelLockMobileScreen(),
        name: 'Aline',
        refreshed: [_staff('t2', 'Bosco', 222222)],
      );
      await _enterPin(tester, '111111');
      expect(container.read(hotelModeProvider).activeClerk, isNull);
    });

    testWidgets('hotel: a changed PIN replaces the old one', (tester) async {
      final container = await _pickThenRefresh(
        tester,
        const HotelLockMobileScreen(),
        name: 'Aline',
        refreshed: [_staff('t1', 'Aline', 333333)],
      );
      await _enterPin(tester, '111111');
      expect(container.read(hotelModeProvider).activeClerk, isNull);
      await _enterPin(tester, '333333');
      expect(container.read(hotelModeProvider).activeClerk?.pin, 333333);
    });
  });
}
