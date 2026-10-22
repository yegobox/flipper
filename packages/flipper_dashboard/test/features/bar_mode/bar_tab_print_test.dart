import 'package:flipper_dashboard/features/bar_mode/bar_tab_print.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_tab_bottom_sheet.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

// flutter test test/features/bar_mode/bar_tab_print_test.dart
BarTable _table({String zone = 'Main Bar', String name = 'Muvinga'}) =>
    BarTable(
      id: 'table-1',
      branchId: 'branch-1',
      zoneId: 'zone-1',
      zoneName: zone,
      name: name,
      seats: 10,
    );

TransactionItem _line() => TransactionItem(
  name: 'Chips',
  qty: 1,
  price: 2500,
  discount: 0,
  prc: 2500,
  ttCatCd: 'B',
  loggedByTenantId: 't1',
);

Future<void> _pumpSheet(
  WidgetTester tester, {
  required List<TransactionItem> lines,
  VoidCallback? onPrint,
}) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final cashier = Tenant(id: 't1', name: 'Server');
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: Scaffold(
        body: BarTabBottomSheet(
          tableName: 'Muvinga',
          zoneName: 'Main Bar',
          lines: lines,
          grouped: {if (lines.isNotEmpty) 't1': lines},
          staff: [cashier],
          cashier: cashier,
          // Managers skip the settle-PIN setting, which reads the box.
          isManager: true,
          total: lines.isEmpty ? 0 : 2500,
          lineCount: lines.length,
          serverCount: 1,
          myLines: lines.length,
          onClose: () {},
          onQtyDelta: (_, _) {},
          onSaveToTab: () {},
          onBackToTables: () {},
          onSettle: () {},
          onPrint: onPrint,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('BarTabPrint.heading', () {
    test('names the zone and the table', () {
      expect(BarTabPrint.heading(_table()), 'Main Bar · Muvinga');
    });

    test('falls back to whichever part is set', () {
      expect(BarTabPrint.heading(_table(zone: '  ')), 'Muvinga');
      expect(BarTabPrint.heading(_table(name: '')), 'Main Bar');
    });
  });

  group('BarTabPrint.bill', () {
    test('prints the gross line totals and barTabTotal, as on screen', () {
      // Bar lines copy the variant's dcRt; the tab screen ignores it.
      final lines = [
        TransactionItem(
          name: 'Fanta',
          qty: 2,
          price: 1000,
          discount: 0,
          dcRt: 10,
          prc: 1000,
          ttCatCd: 'B',
          loggedByTenantId: 't1',
        ),
        _line(),
      ];

      final bill = BarTabPrint.bill(lines);

      expect(bill.lines.map((l) => l.lineTotal), [2000, 2500]);
      expect(bill.lines.first.unitPrice, 1000);
      expect(bill.total, barTabTotal(lines));
      expect(bill.total, 4500);
    });

    test('an empty tab totals zero', () {
      final bill = BarTabPrint.bill(const []);
      expect(bill.lines, isEmpty);
      expect(bill.total, 0);
    });
  });

  group('BarTabBottomSheet print', () {
    testWidgets('prints the tab', (tester) async {
      var printed = 0;
      await _pumpSheet(tester, lines: [_line()], onPrint: () => printed++);

      final print = find.byKey(const ValueKey('bar_tab_sheet_print'));
      await tester.ensureVisible(print);
      await tester.tap(print);
      expect(printed, 1);
    });

    testWidgets('an empty tab cannot be printed', (tester) async {
      var printed = 0;
      await _pumpSheet(tester, lines: const [], onPrint: () => printed++);

      final print = find.byKey(const ValueKey('bar_tab_sheet_print'));
      await tester.ensureVisible(print);
      await tester.tap(print, warnIfMissed: false);
      expect(printed, 0);
    });

    testWidgets('no print callback hides the button', (tester) async {
      await _pumpSheet(tester, lines: [_line()]);
      expect(find.byKey(const ValueKey('bar_tab_sheet_print')), findsNothing);
    });
  });
}
