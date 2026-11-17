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

Future<FakeAccountingLedgerRepository> _pump(
  WidgetTester tester, {
  BooksVatPosition? position,
}) async {
  tester.view.physicalSize = const Size(1400, 1000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final ledger = FakeAccountingLedgerRepository(coa: List.of(_oldChart));
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        accountingBusinessIdProvider.overrideWithValue('biz'),
        accountingCurrencyProvider.overrideWithValue('RWF'),
        accountingAccountsProvider.overrideWithValue(_oldChart),
        accountingLedgerRepositoryProvider.overrideWithValue(ledger),
        booksVatPositionProvider.overrideWith((ref) async => position),
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

Future<List<JournalLine>> _pay(
  WidgetTester tester,
  FakeAccountingLedgerRepository ledger,
  String choice,
) async {
  await _openCategories(tester);
  await tester.tap(find.text(choice).last);
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextField).first, '50000');
  await tester.pumpAndSettle();
  await tester.tap(find.text('Submit for approval'));
  await tester.pumpAndSettle();
  return ledger.entries.single.lines;
}

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
  });
}
