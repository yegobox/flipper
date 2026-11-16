import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_providers.dart';
import 'package:flipper_web/modules/accounting/views/desktop/billing_views.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_data_table.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_icon.dart';
import 'package:flipper_web/modules/accounting/widgets/accounting_show_more.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  List overrides = const [],
}) async {
  tester.view.physicalSize = const Size(1400, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [...overrides],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    ),
  );
  await tester.pump();
}

Finder _showMore() => find.byKey(const Key('accountingShowMore'));

String _showMoreLabel(WidgetTester tester) => tester
    .widget<Text>(find.descendant(of: _showMore(), matching: find.byType(Text)))
    .data!;

void main() {
  group('AccountingDataTable', () {
    Widget table(int count, {void Function(int)? onTap, int pageSize = 100}) =>
        AccountingDataTable(
          columns: const [AccountingTableColumn(label: 'Name')],
          rows: [
            for (var i = 0; i < count; i++) [Text('row $i')],
          ],
          onRowTap: onTap,
          pageSize: pageSize,
        );

    testWidgets('a long table shows one page, then more on each tap', (
      tester,
    ) async {
      await _pump(tester, table(250));

      expect(find.text('row 99'), findsOneWidget);
      expect(find.text('row 100'), findsNothing);
      expect(_showMoreLabel(tester), 'Show 100 more');

      await tester.ensureVisible(_showMore());
      await tester.tap(_showMore());
      await tester.pump();
      expect(find.text('row 199'), findsOneWidget);
      expect(_showMoreLabel(tester), 'Show 50 more');

      await tester.ensureVisible(_showMore());
      await tester.tap(_showMore());
      await tester.pump();
      expect(find.text('row 249'), findsOneWidget);
      expect(_showMore(), findsNothing);
    });

    testWidgets('a custom page size labels and reveals that many rows', (
      tester,
    ) async {
      await _pump(tester, table(50, pageSize: 20));

      expect(find.text('row 19'), findsOneWidget);
      expect(find.text('row 20'), findsNothing);
      expect(_showMoreLabel(tester), 'Show 20 more');

      await tester.ensureVisible(_showMore());
      await tester.tap(_showMore());
      await tester.pump();
      expect(find.text('row 39'), findsOneWidget);
      expect(find.text('row 40'), findsNothing);
      expect(_showMoreLabel(tester), 'Show 10 more');
    });

    testWidgets('a short table has no button; row taps keep their index', (
      tester,
    ) async {
      int? tapped;
      await _pump(tester, table(3, onTap: (i) => tapped = i));

      expect(_showMore(), findsNothing);
      await tester.tap(find.text('row 2'));
      expect(tapped, 2);
    });
  });

  group('AccountingDocListView', () {
    AccountingDocument doc(int i) => AccountingDocument(
      id: 'INV-${i.toString().padLeft(4, '0')}',
      who: 'Customer $i',
      date: '2026-11-01',
      due: '2026-11-30',
      status: DocStatus.sent,
      lines: const [],
    );

    testWidgets('invoices show one page and a button for the rest', (
      tester,
    ) async {
      await _pump(
        tester,
        const AccountingDocListView(kind: DocKind.invoice),
        overrides: [
          accountingInvoicesProvider.overrideWithValue([
            for (var i = 0; i < kAccountingTablePageSize + 30; i++) doc(i),
          ]),
          accountingCurrencyProvider.overrideWithValue('RWF'),
        ],
      );

      expect(find.text('INV-0099'), findsOneWidget);
      expect(find.text('INV-0100'), findsNothing);
      expect(_showMoreLabel(tester), 'Show 30 more');

      await tester.ensureVisible(_showMore());
      await tester.tap(_showMore());
      await tester.pump();
      expect(find.text('INV-0129'), findsOneWidget);
      expect(_showMore(), findsNothing);
    });
  });

  testWidgets('RecurringIconBox draws its icon', (tester) async {
    await _pump(tester, const RecurringIconBox(icon: AccIcon.plus));
    expect(find.byType(AccountingIcon), findsOneWidget);
  });
}
