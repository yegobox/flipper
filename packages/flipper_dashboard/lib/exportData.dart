import 'package:flipper_models/helperModels/talker.dart';
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
import 'package:path/path.dart' as path;
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'dart:collection';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:open_filex/open_filex.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

mixin ExportMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  final GlobalKey<SfDataGridState> workBookKey = GlobalKey<SfDataGridState>();
  void addFooter(DataGridPdfHeaderFooterExportDetails headerFooterExport,
      {required ExportConfig config}) {
    final double width = headerFooterExport.pdfPage.getClientSize().width;

    // Create a footer element with specific height
    final PdfPageTemplateElement footer = PdfPageTemplateElement(
      Rect.fromLTWH(0, 0, width, 40), // Footer height adjusted
    );

    // Create a PdfGrid for the footer layout
    final PdfGrid footerGrid = PdfGrid();
    footerGrid.columns.add(count: 4);

    // Adjust column widths for the layout
    footerGrid.columns[0].width = width * 0.2; // "Total:" label
    footerGrid.columns[1].width = width * 0.4; // Empty space
    footerGrid.columns[2].width = width * 0.2; // First value (e.g., "400")
    footerGrid.columns[3].width = width * 0.2; // Second value (e.g., "8000")

    // Add a row for the footer
    final PdfGridRow footerRow = footerGrid.rows.add();
    footerRow.height = 30; // Adjust row height if needed

    // Add data to the cells
    footerRow.cells[0].value = 'Total:';
    footerRow.cells[0].style = PdfGridCellStyle(
      borders: PdfBorders(
        left: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        right: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        top: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        bottom: PdfPen(PdfColor(211, 211, 211), width: 0.5),
      ),
      font: PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.bold),
    );

    // Leave the second cell empty
    footerRow.cells[1].value = '';
    footerRow.cells[1].style = PdfGridCellStyle(
      borders: PdfBorders(
        left: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        right: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        top: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        bottom: PdfPen(PdfColor(211, 211, 211), width: 0.5),
      ),
      font: PdfStandardFont(PdfFontFamily.helvetica, 12),
    );

    // Add values to the third and fourth cells
    footerRow.cells[2].value = config.transactions
        .fold<double>(0, (sum, trans) => sum + trans.subTotal)
        .toRwf();
    footerRow.cells[2].style = PdfGridCellStyle(
      borders: PdfBorders(
        left: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        right: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        top: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        bottom: PdfPen(PdfColor(211, 211, 211), width: 0.5),
      ),
      font: PdfStandardFont(PdfFontFamily.helvetica, 12),
    );

    footerRow.cells[3].value = config.transactions
        .fold<double>(0, (sum, trans) => sum + trans.cashReceived)
        .toRwf();
    footerRow.cells[3].style = PdfGridCellStyle(
      borders: PdfBorders(
        left: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        right: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        top: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        bottom: PdfPen(PdfColor(211, 211, 211), width: 0.5),
      ),
      font: PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.bold),
    );

    // Draw the grid in the footer
    footerGrid.draw(
      graphics: footer.graphics,
      bounds: Rect.fromLTWH(0, 0, width, 30), // Positioning of the grid
    );

    // Set the footer for the PDF document
    headerFooterExport.pdfDocumentTemplate.bottom = footer;
  }

  void exportToPdf(DataGridPdfHeaderFooterExportDetails headerFooterExport,
      Business business, ExportConfig config,
      {required String headerTitle}) {
    final double width = headerFooterExport.pdfPage.getClientSize().width;

    // Adjust the header size to only fit the necessary content
    final PdfPageTemplateElement header = PdfPageTemplateElement(
      Rect.fromLTWH(0, 0, width, 150), // Adjusted height for compact spacing
    );

    // Create fonts
    final PdfStandardFont titleFont =
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);
    final PdfStandardFont headerFont =
        PdfStandardFont(PdfFontFamily.helvetica, 11);
    final PdfStandardFont headerBoldFont =
        PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold);

    header.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(68, 114, 196)), // Blue background
      bounds: Rect.fromLTWH(
          0, 0, width, 40), // Increased height for better visibility
    );

    header.graphics.drawString(
      headerTitle,
      titleFont,
      brush: PdfBrushes.white, // White text for better contrast
      bounds: Rect.fromLTWH(0, 10, width, 30), // Adjusted Y-position and height
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
    );

    // Define the vertical offset for content positioning
    double currentY = 40; // Start closer to the title for compact spacing

    // Increment the Y position for the next content block
    currentY += 20; // Reduced space between sections

    // Helper function to draw a label-value pair
    void drawLabelValuePair(String label, String value, double x, double y) {
      // Draw the label in bold
      header.graphics.drawString(
        label,
        headerBoldFont,
        bounds: Rect.fromLTWH(x, y, width * 0.2, 20),
      );

      // Draw the value next to the label
      header.graphics.drawString(
        value,
        headerFont,
        bounds: Rect.fromLTWH(x + width * 0.2, y, width * 0.3, 20),
      );
    }

    // Draw the first row of information
    drawLabelValuePair(
        'TIN Number:', business.tinNumber?.toString() ?? '', 0, currentY);
    drawLabelValuePair('Start Date:', config.startDate?.toYYYMMdd() ?? '',
        width * 0.5, currentY);

    // Increment Y position for the next row
    currentY += 20; // Reduced space between rows

    // Draw the second row of information
    drawLabelValuePair('BHF ID:', '00', 0, currentY);
    drawLabelValuePair(
        'End Date:', config.endDate?.toYYYMMdd() ?? '', width * 0.5, currentY);

    // Increment Y position for the next row
    currentY += 20; // Reduced space between rows

    // Draw the third row of information
    drawLabelValuePair(
        'Gross Profit:', config.grossProfit?.toRwf() ?? '', 0, currentY);
    drawLabelValuePair('Opening Balance:', 100.toRwf(), width * 0.5, currentY);

    // Increment Y position for the next row
    currentY += 20; // Reduced space between rows

    // Draw the fourth row of information
    drawLabelValuePair(
        'Net Profit:', config.netProfit?.toRwf() ?? '', 0, currentY);
    drawLabelValuePair('Tax Amount:', (config.grossProfit ?? 0).toRwf(),
        width * 0.5, currentY);

    // Set the adjusted header to the PDF document template
    headerFooterExport.pdfDocumentTemplate.top = header;
  }

  Future<void> exportDataGrid({
    required ExportConfig config,
    List<ITransaction>? expenses,
    bool isStockRecount = false,
    required String headerTitle,
  }) async {
    try {
      ref.read(isProcessingProvider.notifier).startProcessing();
      String filePath;

      if (ProxyService.box.exportAsPdf()) {
        final business = await ProxyService.local.getBusiness();
        final PdfDocument document =
            workBookKey.currentState!.exportToPdfDocument(
          fitAllColumnsInOnePage: true,
          canRepeatHeaders: false,
          exportStackedHeaders: false,
          exportTableSummaries: true,
          headerFooterExport: (headerFooterExport) {
            exportToPdf(headerFooterExport, business, config,
                headerTitle: headerTitle);
            addFooter(headerFooterExport, config: config);
          },
        );

        filePath = await _savePdfFile(document);
        document.dispose();
      } else {
        final excel.Workbook workbook =
            workBookKey.currentState!.exportToExcelWorkbook();
        final excel.Worksheet reportSheet = workbook.worksheets[0];
        reportSheet.name = isStockRecount ? 'Stock Recount' : 'Report';

        if (!isStockRecount) {
          final business = await ProxyService.local.getBusiness();
          final drawer = await ProxyService.local
              .getDrawer(cashierId: ProxyService.box.getUserId()!);
          final ExcelStyler styler = ExcelStyler(workbook);

          await _addHeaderAndInfoRows(
              reportSheet: reportSheet,
              styler: styler,
              config: config,
              business: business,
              drawer: drawer,
              headerTitle: headerTitle);

          _addClosingBalanceRow(reportSheet, styler, config.currencyFormat);
          _formatColumns(reportSheet, config.currencyFormat);

          if (expenses != null && expenses.isNotEmpty) {
            _addExpensesSheet(
                workbook, expenses, styler, config.currencyFormat);
          }
          _addPaymentMethodSheet(workbook, config, styler);
        }

        filePath = await _saveExcelFile(workbook);
        workbook.dispose();
      }

      ref.read(isProcessingProvider.notifier).stopProcessing();
      await _openOrShareFile(filePath);
    } catch (e, s) {
      ref.read(isProcessingProvider.notifier).stopProcessing();
      talker.error(e);
      talker.error(s);
    }
  }

  Future<Map<String, excel.Range>> _addHeaderAndInfoRows({
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

  String normalizePaymentMethod(String method) {
    // Convert to uppercase and trim any leading/trailing whitespace
    return method.trim().toUpperCase();
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

    final paymentTypeTotals = SplayTreeMap<String, double>();

    for (var transaction in config.transactions) {
      final List<TransactionPaymentRecord> paymentTypes =
          ProxyService.local.getPaymentType(transactionId: transaction.id!);

      if (paymentTypes.isNotEmpty) {
        for (var paymentType in paymentTypes) {
          if (paymentType.paymentMethod != null && paymentType.amount != null) {
            final String rawMethod = paymentType.paymentMethod!;
            final String normalizedMethod = normalizePaymentMethod(rawMethod);
            final double amount = paymentType.amount!;

            // Use update method to add the amount, with a default value of 0.0
            paymentTypeTotals.update(
                normalizedMethod, (value) => value + amount,
                ifAbsent: () => amount);
          } else {
            talker.error(
                "Invalid payment data for transaction: ${transaction.id}");
          }
        }
      } else {
        talker
            .error("No payment types found for transaction: ${transaction.id}");
      }
    }

    talker.warning(paymentTypeTotals);

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
    final formattedDate = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = '${formattedDate}-Report.xlsx';

    try {
      final tempDir = await getApplicationDocumentsDirectory();
      final filePath = path.join(tempDir.path, fileName);
      final file = File(filePath);

      await file.create(recursive: true);

      // Chunk the data if it's large
      final chunkSize = 1024 * 1024; // 1MB chunk size (adjust as needed)
      if (bytes.length > chunkSize) {
        final fileStream = file.openWrite(mode: FileMode.writeOnly);
        for (int i = 0; i < bytes.length; i += chunkSize) {
          final end =
              (i + chunkSize < bytes.length) ? i + chunkSize : bytes.length;
          final chunk = bytes.sublist(i, end);
          fileStream.add(chunk);
        }
        await fileStream.flush(); // Ensure all data is written to disk
        await fileStream.close(); // Close the stream
      } else {
        await file.writeAsBytes(bytes, flush: true);
      }

      return filePath;
    } catch (e) {
      talker.error('Error saving Excel file: $e');
      rethrow;
    }
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
    'pdf': 'application/pdf',
  };

  Future<String> _savePdfFile(PdfDocument document) async {
    final List<int> bytes = await document.save();
    final formattedDate = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = '${formattedDate}-Report.pdf';

    try {
      final tempDir = await getApplicationDocumentsDirectory();
      final filePath = path.join(tempDir.path, fileName);
      final file = File(filePath);

      await file.create(recursive: true);
      await file.writeAsBytes(bytes, flush: true);

      return filePath;
    } catch (e) {
      talker.error('Error saving PDF file: $e');
      rethrow;
    }
  }
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
  DateTime? startDate;
  DateTime? endDate;
  double? grossProfit;
  double? netProfit;
  String currencySymbol;
  String currencyFormat;
  final List<ITransaction> transactions;

  ExportConfig({
    this.startDate,
    this.endDate,
    this.grossProfit,
    this.netProfit,
    this.currencySymbol = 'RF',
    required this.transactions,
  }) : currencyFormat =
            '$currencySymbol#,##0.00_);$currencySymbol#,##0.00;$currencySymbol"-"';
}
