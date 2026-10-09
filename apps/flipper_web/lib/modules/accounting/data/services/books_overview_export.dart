import 'dart:convert';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/core/flipper_web_host.dart';
import 'package:flipper_web/modules/accounting/data/accounting_derive.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Everything the Books dashboard shows, frozen at the moment of export so the
/// file matches the screen the user clicked Export on.
class BooksOverviewSnapshot {
  const BooksOverviewSnapshot({
    required this.entityName,
    required this.period,
    required this.currency,
    required this.pl,
    required this.cashBank,
    required this.arTotal,
    required this.apTotal,
    required this.trend,
    required this.journal,
    required this.accounts,
  });

  final String entityName;
  final String period;
  final String currency;
  final IncomeStatementResult pl;
  final int cashBank;
  final int arTotal;
  final int apTotal;
  final List<TrendPoint> trend;
  final List<JournalEntry> journal;
  final List<Account> accounts;

  /// Same rows as the dashboard's recent journal entries card.
  Iterable<JournalEntry> get recentJournal => journal.take(5);
}

/// `books-overview-muhazi-marina-beach-oct-2026.pdf`
String booksExportFileName(String entityName, String period, String ext) {
  final parts = ['books-overview', _slug(entityName), _slug(period)]
    ..removeWhere((p) => p.isEmpty);
  return '${parts.join('-')}.$ext';
}

String _slug(String s) => s
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
    .replaceAll(RegExp(r'^-+|-+$'), '');

String _statusLabel(JournalStatus s, FlipperAppLocalizations l10n) =>
    switch (s) {
      JournalStatus.posted => l10n.booksPillPosted,
      JournalStatus.pending => l10n.booksPillPending,
      JournalStatus.draft => l10n.booksPillDraft,
    };

String _subtitle(BooksOverviewSnapshot s, FlipperAppLocalizations l10n) =>
    s.entityName.isNotEmpty
    ? l10n.booksDashSubtitleEntity(s.currency, s.entityName, s.period)
    : l10n.booksDashSubtitle(s.currency, s.period);

/// Overview rows shared by the PDF and the workbook: KPI cards then P&L.
List<(String, int)> _kpiRows(
  BooksOverviewSnapshot s,
  FlipperAppLocalizations l10n,
) => [
  (profitOrLossLabel(s.pl.netIncome), s.pl.netIncome),
  (l10n.booksCashAndBank, s.cashBank),
  (l10n.booksReceivable, s.arTotal),
  (l10n.booksPayable, s.apTotal),
];

List<(String, int)> _plRows(
  BooksOverviewSnapshot s,
  FlipperAppLocalizations l10n,
) => [
  (l10n.booksNetRevenue, s.pl.netRevenue),
  (l10n.booksCogs, -s.pl.cogs),
  (l10n.booksGrossProfit, s.pl.grossProfit),
  (l10n.booksOperatingExpenses, -s.pl.totalOpex),
  (profitOrLossLabel(s.pl.netIncome), s.pl.netIncome),
];

/// One row per journal line, shared by the workbook's Journal sheet and CSV.
List<String> _ledgerHeader(FlipperAppLocalizations l10n) => [
  l10n.booksExportColEntry,
  l10n.booksExportColDate,
  l10n.booksExportColMemo,
  l10n.booksStatus,
  l10n.booksExportColSource,
  l10n.booksCode,
  l10n.booksAccountName,
  l10n.booksExportColDebit,
  l10n.booksExportColCredit,
];

Iterable<(JournalEntry, JournalLine, String)> _ledgerLines(
  BooksOverviewSnapshot s,
) sync* {
  final names = {for (final a in s.accounts) a.code: a.name};
  for (final e in s.journal) {
    for (final l in e.lines) {
      yield (e, l, names[l.ac] ?? '');
    }
  }
}

// ---------------------------------------------------------------------------
// PDF

Future<Uint8List> buildOverviewPdf(
  BooksOverviewSnapshot s,
  FlipperAppLocalizations l10n, {
  DateTime? now,
}) async {
  final theme = pw.ThemeData.withFont(
    base: await _font('assets/fonts/Geist-400.ttf'),
    bold: await _font('assets/fonts/Geist-700.ttf'),
  );
  final generatedAt = DateFormat(
    'd MMM yyyy, HH:mm',
  ).format(now ?? DateTime.now());
  const ink3 = PdfColor.fromInt(0xFF64748B);
  const line = PdfColor.fromInt(0xFFE2E8F0);
  final bold = pw.TextStyle(fontWeight: pw.FontWeight.bold);

  pw.Widget section(String title, pw.Widget child) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 18),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: bold.copyWith(fontSize: 12)),
        pw.SizedBox(height: 6),
        child,
      ],
    ),
  );

  pw.Widget table(
    List<String> header,
    List<List<String>> rows, {
    Set<int> numeric = const {},
  }) => pw.TableHelper.fromTextArray(
    headers: header,
    data: rows,
    border: const pw.TableBorder(
      horizontalInside: pw.BorderSide(color: line, width: 0.5),
      bottom: pw.BorderSide(color: line, width: 0.5),
    ),
    headerStyle: bold.copyWith(fontSize: 9, color: ink3),
    headerDecoration: const pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: line)),
    ),
    cellStyle: const pw.TextStyle(fontSize: 9.5),
    cellPadding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    cellAlignments: {
      for (var i = 0; i < header.length; i++)
        i: numeric.contains(i)
            ? pw.Alignment.centerRight
            : pw.Alignment.centerLeft,
    },
    headerAlignments: {
      for (var i = 0; i < header.length; i++)
        i: numeric.contains(i)
            ? pw.Alignment.centerRight
            : pw.Alignment.centerLeft,
    },
  );

  // The dashboard's KPI cards.
  final kpis = pw.Padding(
    padding: const pw.EdgeInsets.only(top: 18),
    child: pw.Row(
      children: [
        for (final (i, (label, value)) in _kpiRows(s, l10n).indexed) ...[
          if (i > 0) pw.SizedBox(width: 8),
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: line),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    label,
                    style: const pw.TextStyle(fontSize: 8.5, color: ink3),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    '${s.currency} ${money(value)}',
                    style: bold.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    ),
  );
  final doc = pw.Document(
    title: '${l10n.booksAtAGlance} · ${s.period}',
    author: s.entityName,
  );
  doc.addPage(
    pw.MultiPage(
      theme: theme,
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      footer: (ctx) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            l10n.booksExportGeneratedAt(generatedAt),
            style: const pw.TextStyle(fontSize: 8, color: ink3),
          ),
          pw.Text(
            l10n.booksExportPageOf('${ctx.pageNumber}', '${ctx.pagesCount}'),
            style: const pw.TextStyle(fontSize: 8, color: ink3),
          ),
        ],
      ),
      build: (ctx) => [
        pw.Text(
          l10n.booksFinancialOverview.toUpperCase(),
          style: bold.copyWith(fontSize: 8, color: ink3, letterSpacing: 1),
        ),
        pw.SizedBox(height: 4),
        pw.Text(l10n.booksAtAGlance, style: bold.copyWith(fontSize: 20)),
        pw.SizedBox(height: 4),
        pw.Text(
          _subtitle(s, l10n),
          style: const pw.TextStyle(fontSize: 10, color: ink3),
        ),
        kpis,
        section(
          l10n.booksProfitLoss,
          table(
            [
              l10n.booksExportColItem,
              '${l10n.booksExportColAmount} (${s.currency})',
            ],
            [
              for (final (label, value) in _plRows(s, l10n))
                [label, money(value)],
            ],
            numeric: {1},
          ),
        ),
        section(
          l10n.booksWhereMoneyWent,
          table(
            [
              l10n.booksAccountName,
              '${l10n.booksExportColAmount} (${s.currency})',
            ],
            [
              for (final a in s.pl.opex) [a.name, money(a.bal)],
              [l10n.booksTotal, money(s.pl.totalOpex)],
            ],
            numeric: {1},
          ),
        ),
        section(
          l10n.booksRevenueVsExpenses,
          table(
            [
              l10n.booksExportColMonth,
              l10n.booksExportColRevenue,
              l10n.booksExpenses,
              l10n.booksExportColNet,
            ],
            [
              for (final t in s.trend)
                [t.m, money(t.rev), money(t.exp), money(t.rev - t.exp)],
            ],
            numeric: {1, 2, 3},
          ),
        ),
        section(
          l10n.booksRecentJournalEntries,
          s.journal.isEmpty
              ? pw.Text(
                  l10n.booksNoJournalEntriesYet,
                  style: const pw.TextStyle(fontSize: 10, color: ink3),
                )
              : table(
                  [
                    l10n.booksExportColEntry,
                    l10n.booksExportColDate,
                    l10n.booksExportColMemo,
                    l10n.booksStatus,
                    l10n.booksExportColAmount,
                  ],
                  [
                    for (final e in s.recentJournal)
                      [
                        e.id,
                        e.date,
                        e.memo,
                        _statusLabel(e.status, l10n),
                        money(jeTotals(e).dr),
                      ],
                  ],
                  numeric: {4},
                ),
        ),
      ],
    ),
  );
  return doc.save();
}

Future<pw.Font> _font(String asset) async =>
    pw.Font.ttf(await rootBundle.load(flipperWebAssetKey(asset)));

// ---------------------------------------------------------------------------
// Excel

Uint8List buildOverviewXlsx(
  BooksOverviewSnapshot s,
  FlipperAppLocalizations l10n,
) {
  final excel = Excel.createExcel();
  final defaultSheet = excel.getDefaultSheet();

  TextCellValue t(String v) => TextCellValue(v);
  IntCellValue n(int v) => IntCellValue(v);

  final overview = excel[_sheetName(l10n.booksOverview)];
  overview.appendRow([t(l10n.booksAtAGlance)]);
  overview.appendRow([t(_subtitle(s, l10n))]);
  overview.appendRow([t('')]);
  overview.appendRow([
    t(l10n.booksExportColItem),
    t('${l10n.booksExportColAmount} (${s.currency})'),
  ]);
  for (final (label, value) in _kpiRows(s, l10n)) {
    overview.appendRow([t(label), n(value)]);
  }
  overview.appendRow([t('')]);
  overview.appendRow([t(l10n.booksProfitLoss)]);
  for (final (label, value) in _plRows(s, l10n)) {
    overview.appendRow([t(label), n(value)]);
  }
  overview.setColumnWidth(0, 32);
  overview.setColumnWidth(1, 18);

  final expenses = excel[_sheetName(l10n.booksExpenses)];
  expenses.appendRow([
    t(l10n.booksCode),
    t(l10n.booksAccountName),
    t('${l10n.booksExportColAmount} (${s.currency})'),
  ]);
  for (final a in s.pl.opex) {
    expenses.appendRow([t(a.code), t(a.name), n(a.bal)]);
  }
  expenses.appendRow([t(''), t(l10n.booksTotal), n(s.pl.totalOpex)]);
  expenses.setColumnWidth(1, 32);
  expenses.setColumnWidth(2, 18);

  final trend = excel[_sheetName(l10n.booksExportSheetTrend)];
  trend.appendRow([
    t(l10n.booksExportColMonth),
    t(l10n.booksExportColRevenue),
    t(l10n.booksExpenses),
    t(l10n.booksExportColNet),
  ]);
  for (final p in s.trend) {
    trend.appendRow([t(p.m), n(p.rev), n(p.exp), n(p.rev - p.exp)]);
  }

  final journal = excel[_sheetName(l10n.booksExportSheetJournal)];
  journal.appendRow([for (final h in _ledgerHeader(l10n)) t(h)]);
  for (final (e, l, name) in _ledgerLines(s)) {
    journal.appendRow([
      t(e.id),
      t(e.date),
      t(e.memo),
      t(_statusLabel(e.status, l10n)),
      t(e.src),
      t(l.ac),
      t(name),
      n(l.dr),
      n(l.cr),
    ]);
  }
  journal.setColumnWidth(2, 40);
  journal.setColumnWidth(6, 28);

  for (final sheet in [overview, expenses, trend, journal]) {
    _formatAmounts(sheet);
  }

  // createExcel() starts with an empty "Sheet1"; drop it so the workbook
  // opens on Overview.
  excel.setDefaultSheet(overview.sheetName);
  if (defaultSheet != null && defaultSheet != overview.sheetName) {
    excel.delete(defaultSheet);
  }
  final bytes = excel.encode();
  if (bytes == null) throw StateError('Excel encode returned no bytes');
  return Uint8List.fromList(bytes);
}

/// Shows whole-currency amounts as `#,##0` while keeping them numeric.
void _formatAmounts(Sheet sheet) {
  final style = CellStyle(numberFormat: NumFormat.standard_3);
  for (final row in sheet.rows) {
    for (final cell in row) {
      if (cell?.value is IntCellValue) cell!.cellStyle = style;
    }
  }
}

/// Excel sheet names: max 31 chars, none of `[]:*?/\`.
String _sheetName(String s) {
  final clean = s.replaceAll(RegExp(r'[\[\]:*?/\\]'), ' ').trim();
  return clean.length > 31 ? clean.substring(0, 31) : clean;
}

// ---------------------------------------------------------------------------
// CSV

Uint8List buildLedgerCsv(
  BooksOverviewSnapshot s,
  FlipperAppLocalizations l10n,
) {
  final rows = <List<String>>[
    _ledgerHeader(l10n),
    for (final (e, l, name) in _ledgerLines(s))
      [
        e.id,
        e.date,
        e.memo,
        _statusLabel(e.status, l10n),
        e.src,
        l.ac,
        name,
        '${l.dr}',
        '${l.cr}',
      ],
  ];
  final csv = rows.map((r) => r.map(_csvField).join(',')).join('\r\n');
  // BOM so Excel reads the file as UTF-8 rather than the system code page.
  return Uint8List.fromList([0xEF, 0xBB, 0xBF, ...utf8.encode('$csv\r\n')]);
}

String _csvField(String v) {
  if (!v.contains(RegExp('[",\r\n]'))) return v;
  return '"${v.replaceAll('"', '""')}"';
}
