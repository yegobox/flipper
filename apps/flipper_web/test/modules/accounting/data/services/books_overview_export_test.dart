import 'dart:convert';

import 'package:excel/excel.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/services/books_overview_export.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/books_overview_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final l10n = lookupFlipperAppLocalizations(const Locale('en'));
  final snapshot = fixtureSnapshot();

  test('file name slugs the entity and period', () {
    expect(
      booksExportFileName('Muhazi Marina Beach', 'Oct 2026', 'pdf'),
      'books-overview-muhazi-marina-beach-oct-2026.pdf',
    );
    expect(
      booksExportFileName('', 'FY 2026', 'csv'),
      'books-overview-fy-2026.csv',
    );
  });

  test('PDF is a real PDF document', () async {
    final bytes = await buildOverviewPdf(snapshot, l10n);
    expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
    expect(bytes.length, greaterThan(1000));
  });

  test('PDF renders with an empty journal and no trend', () async {
    const empty = BooksOverviewSnapshot(
      entityName: '',
      period: 'Oct 2026',
      currency: 'RWF',
      pl: fixturePl,
      cashBank: 0,
      arTotal: 0,
      apTotal: 0,
      trend: [],
      journal: [],
      accounts: [],
    );
    final bytes = await buildOverviewPdf(empty, l10n);
    expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
  });

  test('workbook has the four sheets and matches the dashboard', () {
    final excel = Excel.decodeBytes(buildOverviewXlsx(snapshot, l10n));
    expect(
      excel.tables.keys,
      unorderedEquals(['Overview', 'Expenses', 'Trend', 'Journal']),
    );

    final overview = excel.tables['Overview']!;
    final netRow = overview.rows.firstWhere(
      (r) => r.isNotEmpty && r[0]?.value.toString() == l10n.booksNetLoss,
    );
    expect(netRow[1]!.value, IntCellValue(-3042542));

    final journal = excel.tables['Journal']!;
    // Header + one row per journal line.
    expect(journal.maxRows, 1 + 4);
    expect(journal.rows[1][2]!.value, TextCellValue(tricky));
    expect(journal.rows[1][6]!.value, TextCellValue('Bank'));
    expect(journal.rows[1][7]!.value, IntCellValue(4000));
  });

  test('CSV quotes awkward memos and balances', () {
    final bytes = buildLedgerCsv(snapshot, l10n);
    expect(bytes.sublist(0, 3), [0xEF, 0xBB, 0xBF]);
    final text = utf8.decode(bytes.sublist(3));
    final lines = text.split('\r\n');
    expect(
      lines.first,
      'Entry,Date,Memo,Status,Source,Code,Account name,Debit,Credit',
    );
    expect(text, contains('"Sale, 2 x ""Fanta""\nline"'));
    expect(
      text,
      contains('JE-100,Oct 9,Rent,pending,Manual,6100,Opérations,11566,0'),
    );
  });
}
