import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';

import 'models/export_config.dart';
import 'utils/excel_utils.dart';
import 'utils/file_utils.dart';
import 'utils/pdf_utils.dart';

/// Mixin for exporting data to Excel and PDF formats
mixin ExportMixin on ConsumerState {
  /// Key for the data grid
  final GlobalKey<SfDataGridState> workBookKey = GlobalKey<SfDataGridState>();

  /// Exports data grid to Excel or PDF
  ///
  /// This is the main entry point for exporting data
  Future<void> exportDataGrid({
    required ExportConfig config,
    List<ITransaction>? expenses,
    bool isStockRecount = false,
    required String headerTitle,
    required String bottomEndOfRowTitle,
  }) async {
    try {
      ref.read(isProcessingProvider.notifier).startProcessing();
      String filePath;
      final business = await ProxyService.strategy
          .getBusiness(businessId: ProxyService.box.getBusinessId()!);

      if (ProxyService.box.exportAsPdf()) {
        // Export to PDF using the SfDataGrid's built-in functionality
        final PdfDocument document =
            await workBookKey.currentState!.exportToPdfDocument(
          fitAllColumnsInOnePage: true,
          canRepeatHeaders: false,
          exportStackedHeaders: false,
          exportTableSummaries: true,
          headerFooterExport: (headerFooterExport) {
            PdfUtils.exportToPdf(headerFooterExport, business!, config,
                headerTitle: headerTitle);
            PdfUtils.addFooter(headerFooterExport, config: config);
          },
        );

        filePath = await FileUtils.savePdfFile(document);
        document.dispose();
      } else {
        // Create a new Excel workbook
        final excel.Workbook workbook = excel.Workbook();
        final excel.Worksheet reportSheet = workbook.worksheets[0];
        reportSheet.name = isStockRecount ? 'Stock Recount' : 'Report';

        // Always manually add transaction data to ensure the Report sheet has data
        print("Adding ${config.transactions.length} transactions to Excel");
        _addTransactionsToExcel(reportSheet, config.transactions);

        if (!isStockRecount) {
          final drawer = await ProxyService.strategy
              .getDrawer(cashierId: ProxyService.box.getUserId()!);

          // Create a styler instance
          final styler = ExcelUtils.createExcelStyler(workbook);

          // Get the last row with data to determine where to add headers and info
          int lastRow = reportSheet.getLastRow();
          print("Last row with data: $lastRow");

          // Add a few blank rows for spacing
          lastRow += 2;

          // Add header and info rows
          await ExcelUtils.addHeaderAndInfoRows(
            reportSheet: reportSheet,
            styler: styler,
            config: config,
            business: business!,
            drawer: drawer,
            headerTitle: headerTitle,
            startRow: lastRow,
          );

          // Add closing balance row
          ExcelUtils.addClosingBalanceRow(
            reportSheet,
            styler,
            config.currencyFormat,
            bottomEndOfRowTitle: bottomEndOfRowTitle,
            startRow: lastRow + 5, // Adjust based on header rows
          );

          // Format columns
          ExcelUtils.formatColumns(reportSheet, config.currencyFormat);

          // Add expenses sheet if available
          if (expenses != null && expenses.isNotEmpty) {
            ExcelUtils.addExpensesSheet(
              workbook,
              expenses,
              styler,
              config.currencyFormat,
            );
          }

          // Add payment method sheet
          await ExcelUtils.addPaymentMethodSheet(
            workbook,
            config,
            styler,
          );
        }

        filePath = await FileUtils.saveExcelFile(workbook);
        workbook.dispose();
      }

      ref.read(isProcessingProvider.notifier).stopProcessing();
      await FileUtils.openOrShareFile(filePath);
    } catch (e, s) {
      ref.read(isProcessingProvider.notifier).stopProcessing();
      print('Error: $e');
      print('Stack: $s');
      rethrow;
    }
  }

  /// Helper method to add transactions to Excel
  void _addTransactionsToExcel(
      excel.Worksheet sheet, List<ITransaction> transactions) {
    if (transactions.isEmpty) {
      print("No transactions to add to Excel");
      return;
    }

    // Define column names
    final List<String> columnNames = [
      'Date',
      'Transaction ID',
      'Customer',
      'Total',
      'Payment Method',
      'Status'
    ];

    // Add header row with column names
    for (int i = 0; i < columnNames.length; i++) {
      sheet.getRangeByIndex(1, i + 1).setText(columnNames[i]);
      sheet.getRangeByIndex(1, i + 1).cellStyle.backColor = '#4472C4';
      sheet.getRangeByIndex(1, i + 1).cellStyle.fontColor = '#FFFFFF';
      sheet.getRangeByIndex(1, i + 1).cellStyle.bold = true;
    }

    // Add data rows
    for (int i = 0; i < transactions.length; i++) {
      final transaction = transactions[i];
      final rowIndex = i + 2; // Start from row 2 (after header)

      // Date
      if (transaction.createdAt != null) {
        sheet.getRangeByIndex(rowIndex, 1).setDateTime(transaction.createdAt!);
        print("Added date: ${transaction.createdAt} at row $rowIndex");
      } else {
        sheet.getRangeByIndex(rowIndex, 1).setText('');
      }

      // Transaction ID
      sheet.getRangeByIndex(rowIndex, 2).setText(transaction.id);
      print("Added transaction ID: ${transaction.id} at row $rowIndex");

      // Customer
      String customerName = 'Walk-in Customer';
      if (transaction.customerName != null &&
          transaction.customerName!.isNotEmpty) {
        customerName = transaction.customerName!;
      }
      sheet.getRangeByIndex(rowIndex, 3).setText(customerName);

      // Total
      if (transaction.cashReceived != null) {
        sheet.getRangeByIndex(rowIndex, 4).setNumber(transaction.cashReceived!);
        sheet.getRangeByIndex(rowIndex, 4).numberFormat = '#,##0.00';
        print("Added total: ${transaction.cashReceived} at row $rowIndex");
      } else {
        sheet.getRangeByIndex(rowIndex, 4).setText('0.00');
      }

      // Payment Method - using paymentType instead of paymentMethodName
      String paymentMethod = 'Cash';
      if (transaction.paymentType != null &&
          transaction.paymentType!.isNotEmpty) {
        paymentMethod = transaction.paymentType!;
      }
      sheet.getRangeByIndex(rowIndex, 5).setText(paymentMethod);

      // Status
      String status = 'Completed';
      if (transaction.status != null) {
        status = transaction.status ?? 'Unknown';
      }
      sheet.getRangeByIndex(rowIndex, 6).setText(status);
    }

    // Auto-fit columns
    for (int i = 1; i <= columnNames.length; i++) {
      sheet.autoFitColumn(i);
    }

    print("Finished adding ${transactions.length} transactions to Excel");
    print(
        "Sheet now has ${sheet.getLastRow()} rows and ${sheet.getLastColumn()} columns");
  }

  /// Helper function for requesting permissions
  Future<void> requestPermissions() async {
    await FileUtils.requestPermissions();
  }
}
