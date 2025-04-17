import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import '../models/export_config.dart';
import '../models/payment_summary.dart';
import '../utils/excel_styler.dart';

/// Utility class for Excel-related operations
class ExcelUtils {
  /// Column indices for better maintainability
  /// These can be adjusted without breaking functionality
  static const int _colPaymentType = 1; // A
  static const int _colAmount = 2; // B
  static const int _colCount = 3; // C
  static const int _colPercentage = 4; // D

  /// Row indices for better maintainability
  static const int _headerRow = 1;
  static const int _firstDataRow = 2;

  /// Adds header and info rows to the Excel worksheet
  static Future<Map<String, excel.Range>> addHeaderAndInfoRows({
    required excel.Worksheet reportSheet,
    required ExcelStyler styler,
    required ExportConfig config,
    required Business business,
    required Drawers? drawer,
    required String headerTitle,
  }) async {
    final headerStyle = styler.createStyle(
        fontColor: '#FFFFFF', backColor: '#4472C4', fontSize: 14);
    final infoStyle = styler.createStyle(
        fontColor: '#000000', backColor: '#E7E6E6', fontSize: 12);

    reportSheet.insertRow(1);
    final titleRange = reportSheet.getRangeByName(
        'A1:${String.fromCharCode(64 + reportSheet.getLastColumn())}1');
    titleRange.merge();
    titleRange.setText(headerTitle);
    titleRange.cellStyle = headerStyle;

    final taxRate = 18;
    final taxAmount = (config.grossProfit ?? 0 * taxRate) / 118;

    final infoData = [
      ['TIN Number', business.tinNumber?.toString() ?? ''],
      ['BHF ID', await ProxyService.box.bhfId() ?? '00'],
      ['Start Date', config.startDate?.toIso8601String() ?? '-'],
      ['End Date', config.endDate?.toIso8601String() ?? '-'],
      ['Opening Balance', drawer?.openingBalance ?? 0],
      ['Gross Profit', config.grossProfit],
      // Net Profit row will be added below, after Gross Profit
      ['Tax Rate', taxRate],
      ['Tax Amount', taxAmount],
    ];

    Map<String, excel.Range> namedRanges = {};

    for (var i = 0, infoRow = 2; i < infoData.length; i++, infoRow++) {
      // Insert Net Profit row just after Gross Profit
      if (infoData[i][0] == 'Gross Profit') {
        // Write Gross Profit row
        reportSheet.insertRow(infoRow);
        reportSheet
            .getRangeByName('A$infoRow')
            .setText(infoData[i][0].toString());
        final cell = reportSheet.getRangeByName('B$infoRow');
        final value = infoData[i][1];
        try {
          if (value is num) {
            cell.setValue(value);
            cell.numberFormat = config.currencyFormat;
          } else {
            cell.setText(value.toString());
          }
        } catch (e) {}
        final infoRange = reportSheet.getRangeByName(
            'A$infoRow:${String.fromCharCode(64 + reportSheet.getLastColumn())}$infoRow');
        infoRange.cellStyle = infoStyle;
        reportSheet.workbook.names.add('GrossProfit', cell);
        namedRanges['GrossProfit'] = cell;

        // Insert Net Profit row
        final netProfitRow = infoRow + 1;
        reportSheet.insertRow(netProfitRow);
        reportSheet.getRangeByName('A$netProfitRow').setText('Net Profit');
        final netProfitCell = reportSheet.getRangeByName('B$netProfitRow');
        // Set the formula: =GrossProfit - TotalExpenses (named range)
        netProfitCell.setFormula('=GrossProfit - TotalExpenses');
        netProfitCell.numberFormat = config.currencyFormat;
        final netProfitRange = reportSheet.getRangeByName(
            'A$netProfitRow:${String.fromCharCode(64 + reportSheet.getLastColumn())}$netProfitRow');
        netProfitRange.cellStyle = infoStyle;
        reportSheet.workbook.names.add('NetProfit', netProfitCell);
        namedRanges['NetProfit'] = netProfitCell;
        infoRow++; // Skip to next row after Net Profit
        continue;
      }
      reportSheet.insertRow(infoRow);
      reportSheet
          .getRangeByName('A$infoRow')
          .setText(infoData[i][0].toString());
      final value = infoData[i][1];
      final cell = reportSheet.getRangeByName('B$infoRow');
      try {
        if (value is num) {
          cell.setValue(value);
          cell.numberFormat = config.currencyFormat;
        } else {
          cell.setText(value.toString());
        }
      } catch (e) {}
      final infoRange = reportSheet.getRangeByName(
          'A$infoRow:${String.fromCharCode(64 + reportSheet.getLastColumn())}$infoRow');
      infoRange.cellStyle = infoStyle;
    }

    return namedRanges;
  }

  /// Adds a closing balance row to the Excel worksheet
  static void addClosingBalanceRow(
    excel.Worksheet sheet,
    ExcelStyler styler,
    String currencyFormat, {
    required String bottomEndOfRowTitle,
  }) {
    final balanceStyle = styler.createStyle(
        fontColor: '#FFFFFF', backColor: '#70AD47', fontSize: 12);
    final firstDataRow = getFirstDataRow(sheet);
    final lastDataRow = sheet.getLastRow();
    final closingBalanceRow = lastDataRow + 1;

    // Find the column index for "Amount" (assuming always column C = 3)
    final amountColIndex = _colAmount; // B
    final amountColLetter = String.fromCharCode(64 + amountColIndex);

    sheet.insertRow(closingBalanceRow);
    sheet.getRangeByName('A$closingBalanceRow').setText(bottomEndOfRowTitle);
    sheet.getRangeByName('A$closingBalanceRow').cellStyle = balanceStyle;

    final closingBalanceCell =
        sheet.getRangeByName('$amountColLetter$closingBalanceRow');
    closingBalanceCell.setFormula(
        '=SUM($amountColLetter$firstDataRow:$amountColLetter$lastDataRow)');
    closingBalanceCell.cellStyle = balanceStyle;
    closingBalanceCell.numberFormat = currencyFormat;

    sheet
        .getRangeByName(
            'A$closingBalanceRow:$amountColLetter$closingBalanceRow')
        .cellStyle = balanceStyle;

    // --- ADD Net Profit row below Total Gross Profit ---
    final netProfitRow = closingBalanceRow + 1;
    sheet.insertRow(netProfitRow);
    sheet.getRangeByName('A$netProfitRow').setText('Net Profit');
    sheet.getRangeByName('A$netProfitRow').cellStyle = balanceStyle;

    final netProfitCell = sheet.getRangeByName('$amountColLetter$netProfitRow');
    // Reference the actual gross profit cell in the summary/footer, not the header named range
    netProfitCell
        .setFormula('=${amountColLetter}${closingBalanceRow} - TotalExpenses');
    netProfitCell.cellStyle = balanceStyle;
    netProfitCell.numberFormat = currencyFormat;

    sheet
        .getRangeByName('A$netProfitRow:$amountColLetter$netProfitRow')
        .cellStyle = balanceStyle;
  }

  /// Formats columns in the Excel worksheet
  static void formatColumns(excel.Worksheet sheet, String currencyFormat) {
    for (int row = 1; row <= sheet.getLastRow(); row++) {
      sheet.getRangeByIndex(row, 9).numberFormat = currencyFormat;
    }

    for (int i = 1; i <= sheet.getLastColumn(); i++) {
      sheet.autoFitColumn(i);
    }
  }

  /// Normalizes payment method string
  static String normalizePaymentMethod(String method) {
    // Convert to uppercase and trim any leading/trailing whitespace
    return method.trim().toUpperCase();
  }

  /// Adds a payment method sheet to the Excel workbook
  static Future<void> addPaymentMethodSheet(
    excel.Workbook workbook,
    ExportConfig config,
    ExcelStyler styler,
  ) async {
    final sheetName = 'Payment Methods';

    try {
      // Initialize sheet
      final paymentMethodSheet = workbook.worksheets.addWithName(sheetName);
      await initializeSheet(paymentMethodSheet, styler);

      // Process transactions
      final paymentData = await processTransactions(config.transactions);

      if (paymentData.isEmpty) {
        talker.warning('No payment totals to write to sheet');
        return;
      }

      // Write data and format sheet
      await writeDataToSheet(
        sheet: paymentMethodSheet,
        paymentData: paymentData,
        config: config,
      );

      formatSheet(paymentMethodSheet);
      addTotalRow(paymentMethodSheet, paymentData.length + 2, config);

      talker.debug('Successfully completed payment method sheet generation');
    } catch (e, stack) {
      talker.error('Error in payment method sheet generation: $e');
      talker.error(stack);
      rethrow;
    }
  }

  /// Initializes a sheet with headers
  static Future<void> initializeSheet(
    excel.Worksheet sheet,
    ExcelStyler styler,
  ) async {
    // Clear any existing data
    sheet.clear();

    final headerStyle = styler.createStyle(
      fontColor: '#FFFFFF',
      backColor: '#4472C4',
      fontSize: 14,
    );

    // Set headers
    sheet.getRangeByIndex(_headerRow, _colPaymentType).setText('Payment Type');
    sheet.getRangeByIndex(_headerRow, _colAmount).setText('Amount Received');
    sheet.getRangeByIndex(_headerRow, _colCount).setText('Transaction Count');
    sheet.getRangeByIndex(_headerRow, _colPercentage).setText('% of Total');

    // Apply header style
    final headerRange = sheet.getRangeByIndex(
        _headerRow, _colPaymentType, _headerRow, _colPercentage);
    headerRange.cellStyle = headerStyle;
  }

  /// Processes transactions to extract payment data
  static Future<List<PaymentSummary>> processTransactions(
    List<ITransaction> transactions,
  ) async {
    final paymentTotals = <String, PaymentSummary>{};
    talker.debug('Processing ${transactions.length} transactions');

    for (final transaction in transactions) {
      try {
        final paymentTypes = await ProxyService.strategy.getPaymentType(
          transactionId: transaction.id,
        );

        talker.debug(
          'Transaction ${transaction.id}: Found ${paymentTypes.length} payment records',
        );

        for (final paymentType in paymentTypes) {
          if (!isValidPayment(paymentType)) {
            talker.warning(
                'Invalid payment data for transaction: ${transaction.id}');
            continue;
          }

          updatePaymentTotals(paymentTotals, paymentType);
        }
      } catch (e, stack) {
        talker.error('Error processing transaction ${transaction.id}: $e');
        talker.error(stack);
      }
    }

    // Sort by amount descending
    final sortedData = paymentTotals.values.toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    talker.debug('Final payment totals processed: ${sortedData.length}');
    return sortedData;
  }

  /// Checks if a payment is valid
  static bool isValidPayment(TransactionPaymentRecord payment) {
    return payment.paymentMethod != null && payment.amount != null;
  }

  /// Updates payment totals with a new payment
  static void updatePaymentTotals(
    Map<String, PaymentSummary> totals,
    TransactionPaymentRecord payment,
  ) {
    final method = normalizePaymentMethod(payment.paymentMethod!);
    final amount = payment.amount!;

    totals.update(
      method,
      (existing) => PaymentSummary(
        method: method,
        amount: existing.amount + amount,
        count: existing.count + 1,
      ),
      ifAbsent: () => PaymentSummary(
        method: method,
        amount: amount,
        count: 1,
      ),
    );

    talker.debug('Updated payment total: $method = ${totals[method]?.amount}');
  }

  /// Writes payment data to the sheet
  static Future<void> writeDataToSheet({
    required excel.Worksheet sheet,
    required List<PaymentSummary> paymentData,
    required ExportConfig config,
  }) async {
    int rowIndex = _firstDataRow; // Start below headers
    final totalAmount = paymentData.fold<double>(
      0,
      (sum, data) => sum + data.amount,
    );

    for (final data in paymentData) {
      try {
        // Payment Type (Column A)
        sheet.getRangeByIndex(rowIndex, _colPaymentType).setText(data.method);

        // Amount (Column B)
        final amountCell = sheet.getRangeByIndex(rowIndex, _colAmount);
        amountCell.setNumber(data.amount);
        amountCell.numberFormat = config.currencyFormat;

        // Transaction Count (Column C)
        final countCell = sheet.getRangeByIndex(rowIndex, _colCount);
        countCell.setNumber(data.count.toDouble());
        countCell.numberFormat = '#,##0';

        // Percentage (Column D)
        final percentCell = sheet.getRangeByIndex(rowIndex, _colPercentage);
        percentCell.setNumber(data.amount / totalAmount);
        percentCell.numberFormat = '0.00%';

        talker.debug('Wrote row for ${data.method}: ${data.amount}');
        rowIndex++;
      } catch (e) {
        talker.warning('Error writing row for ${data.method}: $e');
      }
    }
  }

  /// Formats the sheet for better readability
  static void formatSheet(excel.Worksheet sheet) {
    // Auto-fit columns
    for (int i = _colPaymentType; i <= _colPercentage; i++) {
      sheet.autoFitColumn(i);
    }

    // Set minimum widths if needed
    if (sheet.getRangeByIndex(_headerRow, _colPaymentType).columnWidth < 15) {
      sheet.getRangeByIndex(_headerRow, _colPaymentType).columnWidth = 15;
    }
    if (sheet.getRangeByIndex(_headerRow, _colAmount).columnWidth < 12) {
      sheet.getRangeByIndex(_headerRow, _colAmount).columnWidth = 12;
    }

    // Hide unused columns
    for (int col = _colPercentage + 1; col <= sheet.getLastColumn(); col++) {
      sheet.getRangeByIndex(_headerRow, col).columnWidth = 0;
    }
  }

  /// Adds a total row to the sheet
  static void addTotalRow(
    excel.Worksheet sheet,
    int lastDataRow,
    ExportConfig config,
  ) {
    // Total label
    sheet.getRangeByIndex(lastDataRow, _colPaymentType).setText('Total');

    // Sum amounts
    final totalCell = sheet.getRangeByIndex(lastDataRow, _colAmount);
    totalCell.setFormula('=SUM(B${_firstDataRow}:B${lastDataRow - 1})');
    totalCell.numberFormat = config.currencyFormat;

    // Sum transaction counts
    final totalCountCell = sheet.getRangeByIndex(lastDataRow, _colCount);
    totalCountCell.setFormula('=SUM(C${_firstDataRow}:C${lastDataRow - 1})');
    totalCountCell.numberFormat = '#,##0';

    // Total percentage (should be 100%)
    final totalPercentCell = sheet.getRangeByIndex(lastDataRow, _colPercentage);
    totalPercentCell.setNumber(1);
    totalPercentCell.numberFormat = '0.00%';
  }

  /// Adds an expenses sheet to the workbook
  static void addExpensesSheet(excel.Workbook workbook,
      List<ITransaction> expenses, ExcelStyler styler, String currencyFormat) {
    final expenseSheet = workbook.worksheets.addWithName('Expenses');
    final expenseHeaderStyle = styler.createStyle(
        fontColor: '#FFFFFF', backColor: '#4472C4', fontSize: 14);
    final balanceStyle = styler.createStyle(
        fontColor: '#FFFFFF', backColor: '#70AD47', fontSize: 12);

    expenseSheet.getRangeByIndex(1, 1).setText('Expense');
    expenseSheet.getRangeByIndex(1, 2).setText('Amount');
    expenseSheet.getRangeByIndex(1, 1, 1, 2).cellStyle = expenseHeaderStyle;

    for (int i = 0; i < expenses.length; i++) {
      final rowIndex = i + 2;
      expenseSheet
          .getRangeByIndex(rowIndex, 1)
          .setText(expenses[i].transactionType);
      expenseSheet.getRangeByIndex(rowIndex, 2).setValue(expenses[i].subTotal);
    }

    final lastDataRow = expenseSheet.getLastRow();

    for (int i = 1; i <= 2; i++) {
      expenseSheet.autoFitColumn(i);
    }

    expenseSheet.getRangeByIndex(lastDataRow + 1, 1).setText('Total Expenses');

    final totalExpensesCell = expenseSheet.getRangeByIndex(lastDataRow + 1, 2);
    totalExpensesCell.setFormula('=SUM(B2:B$lastDataRow)');
    totalExpensesCell.cellStyle = balanceStyle;
    totalExpensesCell.numberFormat = currencyFormat;

    workbook.names.add('TotalExpenses', totalExpensesCell);

    final netProfitCell = workbook.names['NetProfit'].refersToRange;
    netProfitCell.setFormula(
        '=${workbook.names['GrossProfit'].refersToRange.addressGlobal} - TotalExpenses');
    netProfitCell.numberFormat = currencyFormat;
  }

  /// Gets the first data row in the sheet
  static int getFirstDataRow(excel.Worksheet sheet) {
    for (int i = 1; i <= sheet.getLastRow(); i++) {
      if (sheet.getRangeByName('A$i').getText() == '') {
        return i + 1;
      }
    }
    return 2;
  }

  /// Creates an ExcelStyler instance for the given workbook
  static ExcelStyler createExcelStyler(excel.Workbook workbook) {
    return ExcelStyler(workbook);
  }
}
