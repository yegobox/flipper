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

mixin BaseCoreWidgetMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  final GlobalKey<SfDataGridState> workBookKey = GlobalKey<SfDataGridState>();

  Future<void> exportDataGridToExcel({
    DateTime? startDate,
    DateTime? endDate,
    double? grossProfit,
    double? netProfit,
    List<ITransaction>? expenses,
    String currencySymbol = 'RF',
  }) async {
    try {
      ref.read(isProcessingProvider.notifier).startProcessing();

      final business = await ProxyService.local.getBusiness();
      final tinNumber = business.tinNumber ?? 0;
      final bhfId = ProxyService.box.bhfId() ?? "00";
      final drawer = await ProxyService.realm
          .getDrawer(cashierId: ProxyService.box.getBusinessId()!);

      final excel.Workbook workbook =
          workBookKey.currentState!.exportToExcelWorkbook();

      final excel.Worksheet reportSheet = workbook.worksheets[0];
      reportSheet.name = 'Report';

      final int columnCount = reportSheet.getLastColumn();

      if (columnCount < 1) {
        throw Exception('The worksheet must have at least one column');
      }

      final excel.Style headerStyle = _createStyle(workbook,
          fontColor: '#FFFFFF', backColor: '#4472C4', fontSize: 14);
      final excel.Style infoStyle = _createStyle(workbook,
          fontColor: '#000000', backColor: '#E7E6E6', fontSize: 12);
      final excel.Style balanceStyle = _createStyle(workbook,
          fontColor: '#FFFFFF', backColor: '#70AD47', fontSize: 12);

      final currencyFormat =
          '$currencySymbol#,##0.00_);$currencySymbol#,##0.00;$currencySymbol"-"'; 

      final Map<String, excel.Range> namedRanges = _addHeaderAndInfoRows(
          reportSheet,
          headerStyle,
          infoStyle,
          tinNumber,
          bhfId,
          startDate,
          endDate,
          drawer?.openingBalance ?? 0,
          grossProfit ?? 0,
          netProfit ?? 0,
          columnCount,
          currencyFormat,
          workbook);

      _addClosingBalanceRow(
          reportSheet, balanceStyle, columnCount, currencyFormat);

      // Apply currency formatting to gross profit and profit made columns
      for (int row = 1; row <= reportSheet.getLastRow(); row++) {
        reportSheet.getRangeByIndex(row, 9).numberFormat = currencyFormat;
      }

      for (int i = 1; i <= columnCount; i++) {
        reportSheet.autoFitColumn(i);
      }

      if (expenses != null && expenses.isNotEmpty) {
        final expenseSheet = workbook.worksheets.addWithName('Expenses');
        final expenseHeaderStyle = _createStyle(workbook,
            fontColor: '#FFFFFF', backColor: '#4472C4', fontSize: 14);

        // Add headers
        expenseSheet.getRangeByIndex(1, 1).setText('Expense');
        expenseSheet.getRangeByIndex(1, 2).setText('Amount');
        expenseSheet.getRangeByIndex(1, 1, 1, 2).cellStyle = expenseHeaderStyle;

        // Populate expense data
        for (int i = 0; i < expenses.length; i++) {
          final rowIndex = i + 2;
          expenseSheet
              .getRangeByIndex(rowIndex, 1)
              .setText(expenses[i].transactionType);
          expenseSheet
              .getRangeByIndex(rowIndex, 2)
              .setValue(expenses[i].subTotal);
        }

        final lastDataRow = expenseSheet.getLastRow();

        // Create an instance of chart collection
        // final ChartCollection charts = ChartCollection(expenseSheet);
        // // Add the chart
        // final Chart chart = charts.add();

        // // Set Chart Type
        // chart.chartType = ExcelChartType.pie;

        // // Set data range in the worksheet (excluding headers)
        // chart.dataRange = expenseSheet.getRangeByName('A1:B$lastDataRow');

        // // Set charts to worksheet
        // expenseSheet.charts = charts;

        // // Customize chart
        // chart.hasTitle = true;
        // chart.chartTitle = 'Expense Distribution';
        // chart.hasLegend = true;
        // chart.legend!.position = ExcelLegendPosition.right;

        // // Position the chart
        // chart.topRow = 0;
        // chart.leftColumn = 3;
        // chart.bottomRow = 20;
        // chart.rightColumn = 10;

        // Auto-fit columns for the Expenses sheet
        for (int i = 1; i <= 2; i++) {
          expenseSheet.autoFitColumn(i);
        }

        // Add total expenses row
        expenseSheet
            .getRangeByIndex(lastDataRow + 1, 1)
            .setText('Total Expenses');

        final totalExpensesCell =
            expenseSheet.getRangeByIndex(lastDataRow + 1, 2);
        totalExpensesCell.setFormula('=SUM(B2:B$lastDataRow)');
        totalExpensesCell.cellStyle = balanceStyle;
        totalExpensesCell.numberFormat = currencyFormat;

        workbook.names.add('TotalExpenses', totalExpensesCell);

        final netProfitCell = namedRanges['NetProfit']!;
        netProfitCell.setFormula(
            '=${namedRanges['GrossProfit']!.addressGlobal} - TotalExpenses');
        netProfitCell.numberFormat = currencyFormat;
      }

      final String filePath = await _saveExcelFile(workbook);
      workbook.dispose();

      ref.read(isProcessingProvider.notifier).stopProcessing();
      shareFileAsAttachment(filePath);
    } catch (e, s) {
      ref.read(isProcessingProvider.notifier).stopProcessing();
      talker.error(e);
      talker.error(s);
    }
  }

  int _styleCounter = 0;

  excel.Style _createStyle(excel.Workbook workbook,
      {required String fontColor,
      required String backColor,
      required double fontSize}) {
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

  Map<String, excel.Range> _addHeaderAndInfoRows(
      excel.Worksheet sheet,
      excel.Style headerStyle,
      excel.Style infoStyle,
      int tinNumber,
      String bhfId,
      DateTime? startDate,
      DateTime? endDate,
      double openingBalance,
      double grossProfit,
      double netProfit,
      int columnCount,
      String currencyFormat,
      excel.Workbook workbook) {
    sheet.insertRow(1);
    final titleRange =
        sheet.getRangeByName('A1:${String.fromCharCode(64 + columnCount)}1');
    titleRange.merge();
    titleRange.setText('Sales Report');
    titleRange.cellStyle = headerStyle;

    // Assume tax rate is provided in D1, you can adjust as per your requirement

    final taxRate = 18;
    final taxAmount = (grossProfit * taxRate) / 118;

    final infoData = [
      ['TIN Number', tinNumber.toString()],
      ['BHF ID', bhfId],
      ['Start Date', startDate?.toIso8601String() ?? "-"],
      ['End Date', endDate?.toIso8601String() ?? "-"],
      ['Opening Balance', openingBalance],
      ['Gross Profit', grossProfit],
      ['Net Profit', netProfit],
      ['Tax Rate', taxRate],
      ['Tax Amount', taxAmount],
    ];

    Map<String, excel.Range> namedRanges = {};

    for (var i = 0; i < infoData.length; i++) {
      final rowIndex = i + 2;
      sheet.insertRow(rowIndex);
      sheet.getRangeByName('A$rowIndex').setText(infoData[i][0].toString());

      final value = infoData[i][1];
      final cell = sheet.getRangeByName('B$rowIndex');
      if (value is num) {
        cell.setValue(value);
        cell.numberFormat = currencyFormat;
      } else {
        cell.setText(value.toString());
      }

      final infoRange = sheet.getRangeByName(
          'A$rowIndex:${String.fromCharCode(64 + columnCount)}$rowIndex');
      infoRange.cellStyle = infoStyle;

      // Name ranges for easier reference
      if (infoData[i][0] == 'Gross Profit') {
        workbook.names.add('GrossProfit', cell);
        namedRanges['GrossProfit'] = cell;
      } else if (infoData[i][0] == 'Net Profit') {
        workbook.names.add('NetProfit', cell);
        namedRanges['NetProfit'] = cell;
      }
    }

    return namedRanges;
  }

  void _addClosingBalanceRow(excel.Worksheet sheet, excel.Style style,
      int columnCount, String currencyFormat) {
    final firstDataRow = _getFirstDataRow(sheet);
    final lastDataRow = sheet.getLastRow();
    final closingBalanceRow = lastDataRow + 1;

    sheet.insertRow(closingBalanceRow);

    sheet.getRangeByName('A$closingBalanceRow').setText('Closing Balance');
    sheet.getRangeByName('A$closingBalanceRow').cellStyle = style;

    final lastColumnLetter = String.fromCharCode(64 + columnCount);
    final closingBalanceCell =
        sheet.getRangeByName('$lastColumnLetter$closingBalanceRow');
    closingBalanceCell.setFormula(
        '=SUM($lastColumnLetter$firstDataRow:$lastColumnLetter$lastDataRow)');
    closingBalanceCell.cellStyle = style;
    closingBalanceCell.numberFormat = currencyFormat;

    sheet
        .getRangeByName(
            'A$closingBalanceRow:$lastColumnLetter$closingBalanceRow')
        .cellStyle = style;
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
    final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final Directory tempDir = await getApplicationDocumentsDirectory();
    final String filePath = '${tempDir.path}/${formattedDate}-Report.xlsx';
    final File file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
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
