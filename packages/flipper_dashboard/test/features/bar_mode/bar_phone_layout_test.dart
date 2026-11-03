import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_keypad.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_manager_pin_modal.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_tab_bottom_sheet.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_manager_pin_modal.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
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
    });

    testWidgets('a tall phone keeps the actions pinned under the lines', (
      tester,
    ) async {
      _useView(tester, const Size(400, 900));
      await _pumpTabSheet(tester, _lines(3));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(Scrollable), findsOneWidget);
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
}
