import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';

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
        // Create a PDF document
        final PdfDocument document = PdfDocument();
        
        // Create a custom PDF document with header and footer
        final details = PdfUtils.createHeaderFooterDetails(document);
        
        // Add header and content
        PdfUtils.exportToPdf(details, business!, config, headerTitle: headerTitle);
        PdfUtils.addFooter(details, config: config);
        
        // If we have a data grid, we could add it to the PDF here
        // This would require custom implementation to extract data from the grid
        // and format it as a PDF table

        filePath = await FileUtils.savePdfFile(document);
        document.dispose();
      } else {
        // Create an Excel workbook
        final excel.Workbook workbook = excel.Workbook();
        
        // If we have a data grid, we could export it to Excel here
        // This would require custom implementation to extract data from the grid
        // and format it as Excel rows and columns
        
        final excel.Worksheet reportSheet = workbook.worksheets[0];
        reportSheet.name = isStockRecount ? 'Stock Recount' : 'Report';

        if (!isStockRecount) {
          final drawer = await ProxyService.strategy
              .getDrawer(cashierId: ProxyService.box.getUserId()!);
          
          // Create a styler instance
          final styler = ExcelUtils.createExcelStyler(workbook);
          
          // Use the utility classes directly
          await ExcelUtils.addHeaderAndInfoRows(
            reportSheet: reportSheet,
            styler: styler,
            config: config,
            business: business!,
            drawer: drawer,
            headerTitle: headerTitle,
          );

          ExcelUtils.addClosingBalanceRow(
            reportSheet, 
            styler, 
            config.currencyFormat,
            bottomEndOfRowTitle: bottomEndOfRowTitle,
          );
          
          ExcelUtils.formatColumns(reportSheet, config.currencyFormat);

          if (expenses != null && expenses.isNotEmpty) {
            ExcelUtils.addExpensesSheet(
              workbook, 
              expenses, 
              styler, 
              config.currencyFormat,
            );
          }
          
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

  /// Helper function for requesting permissions
  Future<void> requestPermissions() async {
    await FileUtils.requestPermissions();
  }
}
