import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:io';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';

import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:open_filex/open_filex.dart';

mixin ExcelExportMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  final GlobalKey<SfDataGridState> workBookKey = GlobalKey<SfDataGridState>();

  Future<void> exportDataGridToExcel({
    required ExportConfig config,
    List<ITransaction>? expenses,
  }) async {
    try {
      ref.read(isProcessingProvider.notifier).startProcessing();

      final business = await ProxyService.local.getBusiness();
      final drawer = await ProxyService.local
          .getDrawer(cashierId: ProxyService.box.getUserId()!);

      final excel.Workbook workbook =
          workBookKey.currentState!.exportToExcelWorkbook();
      final excel.Worksheet reportSheet = workbook.worksheets[0];
      reportSheet.name = 'Report';

      final ExcelStyler styler = ExcelStyler(workbook);
      final Map<String, excel.Range> namedRanges = _addHeaderAndInfoRows(
        reportSheet: reportSheet,
        styler: styler,
        config: config,
        business: business,
        drawer: drawer,
      );

      _addClosingBalanceRow(reportSheet, styler, config.currencyFormat);

      _formatColumns(reportSheet, config.currencyFormat);

      if (expenses != null && expenses.isNotEmpty) {
        _addExpensesSheet(workbook, expenses, styler, config.currencyFormat);
      }
      _addPaymentMethodSheet(workbook, config, styler);

      final String filePath = await _saveExcelFile(workbook);
      workbook.dispose();

      ref.read(isProcessingProvider.notifier).stopProcessing();
      await _openOrShareFile(filePath);
    } catch (e, s) {
      ref.read(isProcessingProvider.notifier).stopProcessing();
      talker.error(e);
      talker.error(s);
    }
  }

  Map<String, excel.Range> _addHeaderAndInfoRows({
    required excel.Worksheet reportSheet,
    required ExcelStyler styler,
    required ExportConfig config,
    required Business business,
    required Drawers? drawer,
  }) {
    final headerStyle = styler.createStyle(
        fontColor: '#FFFFFF', backColor: '#4472C4', fontSize: 14);
    final infoStyle = styler.createStyle(
        fontColor: '#000000', backColor: '#E7E6E6', fontSize: 12);

    reportSheet.insertRow(1);
    final titleRange = reportSheet.getRangeByName(
        'A1:${String.fromCharCode(64 + reportSheet.getLastColumn())}1');
    titleRange.merge();
    titleRange.setText('Sales Report');
    titleRange.cellStyle = headerStyle;

    final taxRate = 18;
    final taxAmount = (config.grossProfit * taxRate) / 118;

    final infoData = [
      ['TIN Number', business.tinNumber?.toString() ?? ''],
      ['BHF ID', ProxyService.box.bhfId() ?? '00'],
      ['Start Date', config.startDate?.toIso8601String() ?? '-'],
      ['End Date', config.endDate?.toIso8601String() ?? '-'],
      ['Opening Balance', drawer?.openingBalance ?? 0],
      ['Gross Profit', config.grossProfit],
      ['Net Profit', config.netProfit],
      ['Tax Rate', taxRate],
      ['Tax Amount', taxAmount],
    ];

    Map<String, excel.Range> namedRanges = {};

    for (var i = 0; i < infoData.length; i++) {
      final rowIndex = i + 2;
      reportSheet.insertRow(rowIndex);
      reportSheet
          .getRangeByName('A$rowIndex')
          .setText(infoData[i][0].toString());

      final value = infoData[i][1];
      final cell = reportSheet.getRangeByName('B$rowIndex');
      if (value is num) {
        cell.setValue(value);
        cell.numberFormat = config.currencyFormat;
      } else {
        cell.setText(value.toString());
      }

      final infoRange = reportSheet.getRangeByName(
          'A$rowIndex:${String.fromCharCode(64 + reportSheet.getLastColumn())}$rowIndex');
      infoRange.cellStyle = infoStyle;

      if (infoData[i][0] == 'Gross Profit') {
        reportSheet.workbook.names.add('GrossProfit', cell);
        namedRanges['GrossProfit'] = cell;
      } else if (infoData[i][0] == 'Net Profit') {
        reportSheet.workbook.names.add('NetProfit', cell);
        namedRanges['NetProfit'] = cell;
      }
    }

    return namedRanges;
  }

  void _addClosingBalanceRow(
      excel.Worksheet sheet, ExcelStyler styler, String currencyFormat) {
    final balanceStyle = styler.createStyle(
        fontColor: '#FFFFFF', backColor: '#70AD47', fontSize: 12);
    final firstDataRow = _getFirstDataRow(sheet);
    final lastDataRow = sheet.getLastRow();
    final closingBalanceRow = lastDataRow + 1;

    sheet.insertRow(closingBalanceRow);

    sheet.getRangeByName('A$closingBalanceRow').setText('Closing Balance');
    sheet.getRangeByName('A$closingBalanceRow').cellStyle = balanceStyle;

    final lastColumnLetter = String.fromCharCode(64 + sheet.getLastColumn());
    final closingBalanceCell =
        sheet.getRangeByName('$lastColumnLetter$closingBalanceRow');
    closingBalanceCell.setFormula(
        '=SUM($lastColumnLetter$firstDataRow:$lastColumnLetter$lastDataRow)');
    closingBalanceCell.cellStyle = balanceStyle;
    closingBalanceCell.numberFormat = currencyFormat;

    sheet
        .getRangeByName(
            'A$closingBalanceRow:$lastColumnLetter$closingBalanceRow')
        .cellStyle = balanceStyle;
  }

  void _formatColumns(excel.Worksheet sheet, String currencyFormat) {
    for (int row = 1; row <= sheet.getLastRow(); row++) {
      sheet.getRangeByIndex(row, 9).numberFormat = currencyFormat;
    }

    for (int i = 1; i <= sheet.getLastColumn(); i++) {
      sheet.autoFitColumn(i);
    }
  }

  void _addPaymentMethodSheet(
      excel.Workbook workbook, ExportConfig config, ExcelStyler styler) {
    final paymentMethodSheet =
        workbook.worksheets.addWithName('Payment Methods');
    final headerStyle = styler.createStyle(
      fontColor: '#FFFFFF',
      backColor: '#4472C4',
      fontSize: 14,
    );

    paymentMethodSheet.getRangeByIndex(1, 1).setText('Payment Type');
    paymentMethodSheet.getRangeByIndex(1, 2).setText('Amount Received');
    paymentMethodSheet.getRangeByIndex(1, 1, 1, 2).cellStyle = headerStyle;

    // Group transactions by payment type and sum the amounts
    Map<String, double> paymentTypeTotals = {};
    for (var transaction in config.transactions) {
      if (transaction.paymentType != null) {
        talker.warning(transaction.paymentType);
        paymentTypeTotals[transaction.paymentType!] =
            (paymentTypeTotals[transaction.paymentType!] ?? 0) +
                transaction.subTotal;
      }
    }

    int rowIndex = 2;
    paymentTypeTotals.forEach((paymentType, totalAmount) {
      paymentMethodSheet.getRangeByIndex(rowIndex, 1).setText(paymentType);
      paymentMethodSheet.getRangeByIndex(rowIndex, 2).setNumber(totalAmount);
      paymentMethodSheet.getRangeByIndex(rowIndex, 2).numberFormat =
          config.currencyFormat;
      rowIndex++;
    });

    for (int i = 1; i <= 2; i++) {
      paymentMethodSheet.autoFitColumn(i);
    }
  }

  void _addExpensesSheet(excel.Workbook workbook, List<ITransaction> expenses,
      ExcelStyler styler, String currencyFormat) {
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

  int _getFirstDataRow(excel.Worksheet sheet) {
    for (int i = 1; i <= sheet.getLastRow(); i++) {
      if (sheet.getRangeByName('A$i').getText() == '') {
        return i + 1;
      }
    }
    return 2;
  }

  Future<String> _saveExcelFile(excel.Workbook workbook) async {
    final List<int> bytes = workbook.saveAsStream();
    final formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    final Directory tempDir = await getApplicationDocumentsDirectory();
    final String filePath = '${tempDir.path}/${formattedDate}-Report.xlsx';
    final File file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }

  Future<void> _openOrShareFile(String filePath) async {
    if (Platform.isWindows || Platform.isMacOS) {
      try {
        final response = await OpenFilex.open(filePath);
        talker.warning(response);
      } catch (e) {
        talker.error(e);
      }
    } else {
      await shareFileAsAttachment(filePath);
    }
  }

  Future<void> shareFileAsAttachment(String filePath) async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final file = File(filePath);
    final fileName = p.basename(file.path);

    if (Platform.isWindows || Platform.isLinux) {
      final bytes = await file.readAsBytes();
      final mimeType = _lookupMimeType(filePath);
      await Share.shareXFiles(
        [XFile.fromData(bytes, mimeType: mimeType, name: fileName)],
        subject: 'Report Download - $formattedDate',
      );
    } else {
      await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'Report Download - $formattedDate',
      );
    }
  }

  String _lookupMimeType(String filePath) {
    final mimeType = _mimeTypes[filePath.split('.').last];
    return mimeType ?? 'application/octet-stream';
  }

  Future<void> requestPermissions() async {
    await [
      permission.Permission.storage,
      permission.Permission.manageExternalStorage,
    ].request();

    if (await permission.Permission.notification.isDenied) {
      await permission.Permission.notification.request();
    }
  }

  final _mimeTypes = {
    'xls': 'application/vnd.ms-excel',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  };
}

class ExcelStyler {
  final excel.Workbook workbook;
  int _styleCounter = 0;

  ExcelStyler(this.workbook);

  excel.Style createStyle({
    required String fontColor,
    required String backColor,
    required double fontSize,
  }) {
    final styleName = 'customStyle${_styleCounter++}';
    final style = workbook.styles.add(styleName);
    style.fontName = 'Calibri';
    style.bold = true;
    style.fontSize = fontSize;
    style.fontColor = fontColor;
    style.backColor = backColor;
    style.hAlign = excel.HAlignType.center;
    style.vAlign = excel.VAlignType.center;
    return style;
  }
}

class ExportConfig {
  final DateTime? startDate;
  final DateTime? endDate;
  final double grossProfit;
  final double netProfit;
  final String currencySymbol;
  final String currencyFormat;
  final List<ITransaction> transactions;

  ExportConfig({
    this.startDate,
    this.endDate,
    required this.grossProfit,
    required this.netProfit,
    this.currencySymbol = 'RF',
    required this.transactions,
  }) : currencyFormat =
            '$currencySymbol#,##0.00_);$currencySymbol#,##0.00;$currencySymbol"-"';
}
