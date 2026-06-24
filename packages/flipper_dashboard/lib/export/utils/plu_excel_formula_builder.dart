/// Row-map keys for PLU manual Excel export (must match manual row maps in
/// [exportData], [DataView], [headless_detailed_transaction_export_host]).
abstract final class PluExcelRowKeys {
  static const taxTyCd = '__excelRowTaxTyCd';
  static const discount = '__excelRowDiscount';
  static const splyAmt = '__excelRowSplyAmt';
  static const taxAmt = '__excelRowTaxAmt';
  static const totAmt = '__excelRowTotAmt';
  static const taxblAmt = '__excelRowTaxblAmt';
}

/// Pure helpers for PLU line Excel formulas (Excel + Google Sheets .xlsx import).
abstract final class PluExcelFormulaBuilder {
  /// Numeric literal for embedding in Excel formulas (en-US decimal point).
  ///
  /// Never uses scientific notation ([double.toString] can emit `1e-7`), which
  /// Google Sheets often rejects inside imported .xlsx formulas.
  static String excelLiteralNumForFormula(num n) {
    final d = n.toDouble();
    if (d == 0) return '0';
    if (d == d.roundToDouble()) return '${d.round()}';
    var s = d.toStringAsFixed(12);
    if (s.contains('.')) {
      s = s.replaceFirst(RegExp(r'0+$'), '');
      s = s.replaceFirst(RegExp(r'\.$'), '');
    }
    return s;
  }

  /// `Sheet!` or `'My Sheet'!` for cross-sheet formulas (Excel + Google Sheets import).
  static String formulaSheetPrefix(String sheetName) {
    final t = sheetName.trim();
    if (t.isEmpty) return '';
    final simple = RegExp(r'^[A-Za-z_][A-Za-z0-9_]*$').hasMatch(t);
    if (simple) return '$t!';
    return "'${t.replaceAll("'", "''")}'!";
  }

  /// Matches [TransactionItemPluMetrics.taxPayable] when tax is derived from rate;
  /// returns `null` when the app uses [taxAmt] or (tot - taxbl) — then the static cell value is used.
  static String? pluTaxPayableExcelFormula({
    required Map<String, dynamic> rowData,
    required int excelRow,
    required String priceLetter,
    required String qtyLetter,
    required String taxRateLetter,
  }) {
    final taxAmt = rowData[PluExcelRowKeys.taxAmt];
    if (taxAmt is num && taxAmt.toDouble() > 0) {
      return null;
    }
    final tot = rowData[PluExcelRowKeys.totAmt];
    final taxbl = rowData[PluExcelRowKeys.taxblAmt];
    if (tot is num &&
        taxbl is num &&
        tot.toDouble() > taxbl.toDouble() + 0.0001) {
      return null;
    }

    var ty = rowData[PluExcelRowKeys.taxTyCd]?.toString().trim();
    if (ty == null || ty.isEmpty) ty = 'B';
    ty = ty.toUpperCase();
    final discount =
        (rowData[PluExcelRowKeys.discount] as num?)?.toDouble() ?? 0.0;
    final dLit = excelLiteralNumForFormula(discount);

    final p = priceLetter;
    final q = qtyLetter;
    final tr = taxRateLetter;
    final r = excelRow;
    // Always use ${} for letter+row so identifiers like [tr] never split (e.g. $tr$r vs $t + r…).
    final base = '${p}${r}*${q}${r}-$dLit';

    if (ty == 'D') {
      return '=0';
    }
    if (ty == 'B' || ty == 'C') {
      return '=IF($base<=0,0,ROUND(($base)*${tr}${r}/(100+${tr}${r}),2))';
    }
    return '=IF($base<=0,0,ROUND(($base)*${tr}${r}/100,2))';
  }

  /// Net profit line: (total sales cell − supply − tax), rounded to 2 dp.
  static String pluNetProfitExcelFormula({
    required int excelRow,
    required String totalSalesLetter,
    required String taxPayableLetter,
    String? supplyLetter,
    double? splyAmtLiteral,
  }) {
    final ts = totalSalesLetter;
    final tp = taxPayableLetter;
    final r = excelRow;
    if (supplyLetter != null) {
      final s = supplyLetter;
      return '=ROUND((${ts}${r}-${s}${r})-${tp}${r},2)';
    }
    final lit = splyAmtLiteral ?? 0.0;
    final sLit = excelLiteralNumForFormula(lit);
    return '=ROUND((${ts}${r}-$sLit)-${tp}${r},2)';
  }

  /// Final net profit on report sheet: [report]![netCol][netRow] − [expenses]!B[expRow].
  static String finalNetProfitAfterExpensesFormula({
    required String reportSheetName,
    required String expensesSheetName,
    required String netProfitColumnLetter,
    required int netProfitBeforeExpensesRow,
    required int totalExpensesRow,
  }) {
    final rp = formulaSheetPrefix(reportSheetName);
    final ep = formulaSheetPrefix(expensesSheetName);
    return '=$rp${netProfitColumnLetter}${netProfitBeforeExpensesRow}-$ep'
        'B${totalExpensesRow}';
  }

  /// Same-sheet reference when expenses sheet is missing (fallback).
  static String netProfitBeforeExpensesOnlyFormula({
    required String reportSheetName,
    required String netProfitColumnLetter,
    required int netProfitBeforeExpensesRow,
  }) {
    final rp = formulaSheetPrefix(reportSheetName);
    return '=$rp${netProfitColumnLetter}${netProfitBeforeExpensesRow}';
  }
}
