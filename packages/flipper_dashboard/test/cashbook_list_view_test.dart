import 'package:flipper_dashboard/cashbook_form_rules.dart';
import 'package:flipper_dashboard/widgets/cashbook_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 10, 5, 18);

CashbookListEntry _entry(
  String id,
  CashbookEntryKind kind,
  String? type, {
  double amount = 1000,
  DateTime? at,
  String? note,
  String? pay,
}) {
  final l = cashbookRowLabels(kind: kind, transactionType: type, note: note);
  final badge = cashbookMethodBadge(pay);
  return CashbookListEntry(
    id: id,
    kind: kind,
    title: l.title,
    detail: l.detail,
    amount: amount,
    at: at ?? _now.subtract(const Duration(hours: 1)),
    methodBadge: badge,
    isMobileMoney: badge != null,
  );
}

Future<void> _pump(
  WidgetTester tester,
  List<CashbookListEntry> entries, {
  CashbookListFilter filter = CashbookListFilter.all,
  ValueChanged<CashbookListFilter>? onFilter,
  ValueChanged<String>? onTap,
}) async {
  tester.view.physicalSize = const Size(1179, 2556);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CashbookListView(
          entries: entries,
          filter: filter,
          onFilterChanged: onFilter ?? (_) {},
          currency: 'RWF',
          periodLabel: 'Last 30 days',
          onEntryTap: onTap ?? (_) {},
          now: _now,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('a cash out shows its category beneath the Cash out label', (
    tester,
  ) async {
    await _pump(tester, [
      _entry('1', CashbookEntryKind.cashOut, 'Transport', note: 'Fuel'),
    ]);

    final label = tester.getTopLeft(find.text('Cash out').last);
    final detail = tester.getTopLeft(find.text('Transport · Fuel'));
    expect(detail.dy, greaterThan(label.dy));
    expect(
      find.descendant(
        of: find.byType(CashbookEntryRow),
        matching: find.text('−1,000 RWF'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('groups by day and totals the period', (tester) async {
    await _pump(tester, [
      _entry('1', CashbookEntryKind.sale, 'Sale', amount: 3000),
      _entry(
        '2',
        CashbookEntryKind.cashOut,
        'Rent',
        amount: 1000,
        at: _now.subtract(const Duration(days: 1)),
      ),
    ]);

    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Yesterday'), findsOneWidget);
    expect(find.text('+2,000 RWF'), findsOneWidget, reason: 'net cash flow');
  });

  testWidgets('the Cash out chip hides sales and cash in', (tester) async {
    await _pump(tester, [
      _entry('1', CashbookEntryKind.sale, 'Sale'),
      _entry('2', CashbookEntryKind.cashIn, 'Owner deposit'),
      _entry('3', CashbookEntryKind.cashOut, 'Airtime', pay: 'AIRTEL MONEY'),
    ], filter: CashbookListFilter.cashOut);

    expect(find.text('Airtime'), findsOneWidget);
    expect(find.text('Airtel'), findsOneWidget);
    expect(find.text('Owner deposit'), findsNothing);
    expect(find.text('Point of sale'), findsNothing);
  });

  testWidgets('tapping a chip and a row reports them', (tester) async {
    CashbookListFilter? picked;
    String? tapped;
    await _pump(
      tester,
      [_entry('42', CashbookEntryKind.cashIn, 'Owner deposit')],
      onFilter: (f) => picked = f,
      onTap: (id) => tapped = id,
    );

    // The chip row scrolls horizontally; bring the chip into view first.
    await tester.ensureVisible(find.text('Sales'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sales'));
    await tester.pump();
    await tester.tap(find.text('Owner deposit'));
    await tester.pump();
    expect(picked, CashbookListFilter.sales);
    expect(tapped, '42');
  });

  testWidgets('empty period invites the first entry', (tester) async {
    await _pump(tester, const []);
    expect(find.text('No cash movements yet'), findsOneWidget);
  });
}
