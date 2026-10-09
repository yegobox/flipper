import 'dart:typed_data';

import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/services/books_file_saver.dart';
import 'package:flipper_web/modules/accounting/views/desktop/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/books_overview_fixtures.dart';

class _RecordingSaver implements BooksFileSaver {
  _RecordingSaver({this.error, this.result = true});

  final Object? error;
  final bool result;
  final saved = <(String fileName, String ext, int length)>[];

  @override
  Future<bool> save(Uint8List bytes, String fileName, String ext) async {
    if (error != null) throw error!;
    saved.add((fileName, ext, bytes.length));
    return result;
  }
}

Future<void> _pump(WidgetTester tester, BooksFileSaver saver) async {
  tester.view.physicalSize = const Size(1400, 1800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        booksFileSaverProvider.overrideWithValue(saver),
        accountingLoadingProvider.overrideWithValue(false),
        accountingIncomeStatementProvider.overrideWithValue(fixturePl),
        accountingJournalProvider.overrideWithValue(fixtureJournal),
        accountingTrendProvider.overrideWithValue(fixtureTrend),
        accountingCashBankTotalProvider.overrideWithValue(-2139346),
        accountingArAgingProvider.overrideWithValue(const <AgingRow>[]),
        accountingApAgingProvider.overrideWithValue(const <AgingRow>[]),
        accountingPeriodLabelProvider.overrideWithValue('Oct 2026'),
        accountingCurrencyProvider.overrideWithValue('RWF'),
        accountingAccountsProvider.overrideWithValue(fixtureAccounts),
      ],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(
          body: AccountingDashboardView(
            onNewEntry: () {},
            onRecordExpense: () {},
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _export(WidgetTester tester, String item) async {
  await tester.tap(find.text('Export'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(item).last);
  // PDF building awaits font assets; let real async work finish.
  await tester.runAsync(() => Future<void>.delayed(const Duration(seconds: 1)));
  await tester.pumpAndSettle();
}

void main() {
  for (final (item, ext) in [
    ('Excel workbook (.xlsx)', 'xlsx'),
    ('PDF report', 'pdf'),
    ('CSV (raw ledger)', 'csv'),
  ]) {
    testWidgets('Export → $item saves a .$ext file', (tester) async {
      final saver = _RecordingSaver();
      await _pump(tester, saver);
      await _export(tester, item);

      expect(saver.saved, hasLength(1));
      final (fileName, savedExt, length) = saver.saved.single;
      expect(savedExt, ext);
      expect(fileName, 'books-overview-oct-2026.$ext');
      expect(length, greaterThan(0));
      expect(find.text('Export ready'), findsOneWidget);
    });
  }

  testWidgets('a cancelled save dialog shows no success toast', (tester) async {
    final saver = _RecordingSaver(result: false);
    await _pump(tester, saver);
    await _export(tester, 'CSV (raw ledger)');

    expect(saver.saved, hasLength(1));
    expect(find.text('Export ready'), findsNothing);
  });

  testWidgets('a failing save shows an error toast', (tester) async {
    await _pump(tester, _RecordingSaver(error: StateError('disk full')));
    await _export(tester, 'CSV (raw ledger)');

    expect(find.textContaining('disk full'), findsOneWidget);
    expect(find.text('Export ready'), findsNothing);
  });
}
