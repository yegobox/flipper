import 'dart:async';

import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/default_chart_of_accounts_seed.dart';
import 'package:flipper_web/modules/accounting/data/services/vat_position_service.dart';
import 'package:flipper_web/modules/accounting/widgets/expense_entry_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_accounting_ledger_repository.dart';

/// A chart seeded before PAYE / RSSB Payable existed, with VAT owed.
final _oldChart = [
  for (final a in defaultChartOfAccountsSeed)
    if (!{'1150', '2310', '2320', '6025'}.contains(a.code))
      a.code == '2100'
          ? Account(
              code: a.code,
              name: a.name,
              type: a.type,
              sub: a.sub,
              normal: a.normal,
              bal: 83639,
            )
          : a,
];

/// The current chart with [bal] posted to PAYE Payable.
List<Account> _chartOwingPaye(int bal) => [
  for (final a in defaultChartOfAccountsSeed)
    a.code == '2310'
        ? Account(
            code: a.code,
            name: a.name,
            type: a.type,
            sub: a.sub,
            normal: a.normal,
            bal: bal,
          )
        : a,
];

Future<FakeAccountingLedgerRepository> _pump(
  WidgetTester tester, {
  BooksVatPosition? position,
  Future<BooksVatPosition?>? positionFuture,
  List<Account>? accounts,
  List<JournalEntry> journal = const [],
}) async {
  tester.view.physicalSize = const Size(1400, 1000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final chart = accounts ?? _oldChart;
  final ledger = FakeAccountingLedgerRepository(coa: List.of(chart));
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        accountingBusinessIdProvider.overrideWithValue('biz'),
        accountingCurrencyProvider.overrideWithValue('RWF'),
        accountingAccountsProvider.overrideWithValue(chart),
        accountingJournalProvider.overrideWithValue(journal),
        accountingLedgerRepositoryProvider.overrideWithValue(ledger),
        booksVatPositionProvider.overrideWith(
          (ref) => positionFuture ?? Future.value(position),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(body: ExpenseEntryPanel(onClose: () {})),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return ledger;
}

Future<void> _openCategories(WidgetTester tester) async {
  await tester.tap(find.byType(DropdownButtonFormField<String>));
  await tester.pumpAndSettle();
}

Future<void> _choose(WidgetTester tester, String choice) async {
  await _openCategories(tester);
  await tester.tap(find.text(choice).last);
  await tester.pumpAndSettle();
}

Future<void> _enterAmount(WidgetTester tester, String amount) async {
  await tester.enterText(find.byType(TextField).first, amount);
  await tester.pumpAndSettle();
}

Future<void> _submit(WidgetTester tester) async {
  await tester.tap(find.text('Submit for approval'));
  await tester.pumpAndSettle();
}

Future<List<JournalLine>> _pay(
  WidgetTester tester,
  FakeAccountingLedgerRepository ledger,
  String choice,
) async {
  await _choose(tester, choice);
  await _enterAmount(tester, '50000');
  await _submit(tester);
  return ledger.entries.single.lines;
}

/// The memo field (the last text field; the amount is the first).
Finder get _memoField => find.byType(TextField).last;

String _memoText(WidgetTester tester) =>
    tester.widget<TextField>(_memoField).controller!.text;

int _dr(List<JournalLine> lines, String ac) =>
    lines.where((l) => l.ac == ac).fold(0, (s, l) => s + l.dr);

void main() {
  group('Record expense: taxes and RSSB', () {
    testWidgets('lists RRA and RSSB payments under their own heading', (
      tester,
    ) async {
      await _pump(tester);
      await _openCategories(tester);
      expect(find.text('TAXES & RSSB'), findsOneWidget);
      expect(find.text('VAT paid to RRA'), findsWidgets);
      expect(find.text('PAYE paid to RRA'), findsWidgets);
      expect(find.text('RSSB contributions'), findsWidgets);
    });

    testWidgets('VAT paid clears VAT Payable, not an expense', (tester) async {
      final ledger = await _pump(tester);
      final lines = await _pay(tester, ledger, 'VAT paid to RRA');
      expect(_dr(lines, '2100'), 50000);
      expect(lines.where((l) => l.ac.startsWith('6')), isEmpty);
      expect(ledger.entries.single.memo, 'VAT paid to RRA');
    });

    testWidgets('PAYE with no payroll in Books is a salary cost', (
      tester,
    ) async {
      final ledger = await _pump(tester);
      final lines = await _pay(tester, ledger, 'PAYE paid to RRA');
      expect(_dr(lines, '6020'), 50000);
      expect(_dr(lines, '2310'), 0);
      // Nothing was owed, so only the salary account is used; no liability
      // account is needed yet.
      expect(ledger.lastCreatedAccount, isNull);
    });

    testWidgets('not registered for VAT: no VAT payment choice', (
      tester,
    ) async {
      await _pump(
        tester,
        position: const BooksVatPosition(
          registered: false,
          hasEbmBranch: false,
          settingRegistered: false,
        ),
      );
      await _openCategories(tester);
      expect(find.text('VAT paid to RRA'), findsNothing);
      expect(find.text('PAYE paid to RRA'), findsWidgets);
    });

    testWidgets('VAT picked before the position loads is dropped once it '
        'shows the business is not registered', (tester) async {
      final position = Completer<BooksVatPosition?>();
      final ledger = await _pump(tester, positionFuture: position.future);
      await _choose(tester, 'VAT paid to RRA');
      await _enterAmount(tester, '50000');
      expect(_memoText(tester), 'VAT paid to RRA');
      expect(find.text('Journal preview'), findsOneWidget);

      position.complete(
        const BooksVatPosition(
          registered: false,
          hasEbmBranch: false,
          settingRegistered: false,
        ),
      );
      await tester.pumpAndSettle();

      // The choice and the memo it filled in are gone, and nothing posts.
      expect(_memoText(tester), isEmpty);
      expect(find.text('Journal preview'), findsNothing);
      await _submit(tester);
      expect(ledger.entries, isEmpty);
    });

    testWidgets('RSSB adds Employer RSSB to an old chart and previews it', (
      tester,
    ) async {
      final ledger = await _pump(tester);
      await _choose(tester, 'RSSB contributions');
      await _enterAmount(tester, '50000');
      // The preview names the account the chart gets on submit.
      expect(find.text('Employer RSSB Contributions'), findsOneWidget);
      await _submit(tester);
      expect(_dr(ledger.entries.single.lines, '6025'), 50000);
      expect(ledger.lastCreatedAccount?.code, '6025');
    });

    testWidgets('a PAYE payment awaiting approval is not owed twice', (
      tester,
    ) async {
      final ledger = await _pump(
        tester,
        accounts: _chartOwingPaye(80000),
        journal: const [
          JournalEntry(
            id: 'JE-1',
            date: '1 Nov 2026',
            memo: 'PAYE paid to RRA',
            ref: 'JE-1',
            status: JournalStatus.pending,
            src: 'Manual',
            lines: [
              JournalLine(ac: '2310', dr: 60000),
              JournalLine(ac: '1010', cr: 60000),
            ],
          ),
        ],
      );
      await _choose(tester, 'PAYE paid to RRA');
      // 80,000 posted, 60,000 of it already being paid.
      expect(find.textContaining('RWF 20,000'), findsOneWidget);
      await _enterAmount(tester, '50000');
      await _submit(tester);
      final lines = ledger.entries.single.lines;
      expect(_dr(lines, '2310'), 20000);
      expect(_dr(lines, '6020'), 30000);
    });
  });

  group('Record expense: memo', () {
    testWidgets('a memo the user typed is kept when the choice changes', (
      tester,
    ) async {
      final ledger = await _pump(tester);
      await tester.enterText(_memoField, 'March PAYE');
      await _choose(tester, 'PAYE paid to RRA');
      expect(_memoText(tester), 'March PAYE');
      await _enterAmount(tester, '50000');
      await _submit(tester);
      expect(ledger.entries.single.memo, 'March PAYE');
    });

    testWidgets('a cleared memo falls back to the payment name', (
      tester,
    ) async {
      final ledger = await _pump(tester);
      await _choose(tester, 'RSSB contributions');
      await tester.enterText(_memoField, '');
      await _enterAmount(tester, '50000');
      await _submit(tester);
      expect(ledger.entries.single.memo, 'RSSB contributions');
    });

    testWidgets('an ordinary expense with no memo', (tester) async {
      final ledger = await _pump(tester);
      await _enterAmount(tester, '12000');
      await _submit(tester);
      expect(ledger.entries.single.memo, 'Expense payment');
      expect(_dr(ledger.entries.single.lines, '6000'), 12000);
    });
  });
}
