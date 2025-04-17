// This file is maintained for backward compatibility
// For new code, please use the modular structure in the 'export' directory

import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';

// Import the new modular structure
import 'export/utils/excel_utils.dart';
import 'export/utils/excel_styler.dart' as new_styler;
import 'export/utils/file_utils.dart';

// Re-export all the necessary components from the new modular structure
export 'export/models/export_config.dart';
export 'export/models/payment_summary.dart';
export 'export/export_mixin.dart';
export 'export/utils/excel_styler.dart';

// The following classes are kept for backward compatibility
// but delegate to the new implementation

class PaymentSummary {
  final String method;
  final double amount;
  final int count;

  const PaymentSummary({
    required this.method,
    required this.amount,
    required this.count,
  });
}

// Create a custom PDF header/footer export details class
class CustomPdfHeaderFooterDetails {
  final PdfDocument document;
  final PdfPage page;

  CustomPdfHeaderFooterDetails(this.document) : page = document.pages.add();
}

mixin ExportMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  // This mixin now delegates to the new implementation in export/export_mixin.dart
  final GlobalKey<SfDataGridState> workBookKey = GlobalKey<SfDataGridState>();

  // Export the main functionality
  Future<void> exportDataGrid({
    required dynamic config,
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

        // Create custom header/footer details
        final customDetails = CustomPdfHeaderFooterDetails(document);

        // Use a simpler approach to export the data grid to PDF
        if (workBookKey.currentState != null) {
          // Add content to the PDF document
          // We'll create a custom PDF with the data from the grid
          _exportToPdf(customDetails, business!, config,
              headerTitle: headerTitle);
          _addFooter(customDetails, config: config);

          // Additional PDF content can be added here
        }

        filePath = await FileUtils.savePdfFile(document);
        document.dispose();
      } else {
        // Create an Excel workbook
        final excel.Workbook workbook = excel.Workbook();
        final excel.Worksheet reportSheet = workbook.worksheets[0];
        reportSheet.name = isStockRecount ? 'Stock Recount' : 'Report';

        if (!isStockRecount) {
          final drawer = await ProxyService.strategy
              .getDrawer(cashierId: ProxyService.box.getUserId()!);
          final styler = new_styler.ExcelStyler(workbook);

          await ExcelUtils.addHeaderAndInfoRows(
              reportSheet: reportSheet,
              styler: styler,
              config: config,
              business: business!,
              drawer: drawer,
              headerTitle: headerTitle);

          ExcelUtils.addClosingBalanceRow(
              reportSheet, styler, config.currencyFormat,
              bottomEndOfRowTitle: bottomEndOfRowTitle);
          ExcelUtils.formatColumns(reportSheet, config.currencyFormat);

          if (expenses != null && expenses.isNotEmpty) {
            ExcelUtils.addExpensesSheet(
                workbook, expenses, styler, config.currencyFormat);
          }
          await ExcelUtils.addPaymentMethodSheet(workbook, config, styler);
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

  // Custom PDF export methods
  void _exportToPdf(
      CustomPdfHeaderFooterDetails details, Business business, dynamic config,
      {required String headerTitle}) {
    // Create a simplified version of the PDF export
    final page = details.page;
    final graphics = page.graphics;

    // Add header
    final PdfFont headerFont =
        PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold);
    graphics.drawString(headerTitle, headerFont,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, 50),
        format: PdfStringFormat(alignment: PdfTextAlignment.center));

    // Add business info
    final PdfFont normalFont = PdfStandardFont(PdfFontFamily.helvetica, 12);
    graphics.drawString('Business: ${business.name}', normalFont,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, 50, page.getClientSize().width, 30));

    // Add date range if available
    if (config.startDate != null && config.endDate != null) {
      final String dateRange =
          'Period: ${config.startDate!.toString().substring(0, 10)} to ${config.endDate!.toString().substring(0, 10)}';
      graphics.drawString(dateRange, normalFont,
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(0, 80, page.getClientSize().width, 30));
    }
  }

  void _addFooter(CustomPdfHeaderFooterDetails details,
      {required dynamic config}) {
    // Add a simple footer
    final page = details.page;
    final graphics = page.graphics;
    final PdfFont footerFont = PdfStandardFont(PdfFontFamily.helvetica, 10);

    // Add page number
    graphics.drawString('Page 1', footerFont,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, page.getClientSize().height - 30,
            page.getClientSize().width, 30),
        format: PdfStringFormat(alignment: PdfTextAlignment.center));

    // Add timestamp
    final now = DateTime.now();
    final timestamp = 'Generated on ${now.toString().substring(0, 19)}';
    graphics.drawString(timestamp, footerFont,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, page.getClientSize().height - 15,
            page.getClientSize().width, 15),
        format: PdfStringFormat(alignment: PdfTextAlignment.center));
  }
}

// Helper class to adapt the old ExcelStyler to the new one
class ExcelStyler {
  // This class is maintained for backward compatibility
  // but all functionality is delegated to the new implementation
  final excel.Workbook workbook;
  late final new_styler.ExcelStyler _newStyler;

  ExcelStyler(this.workbook) {
    _newStyler = new_styler.ExcelStyler(workbook);
  }

  // Factory method to create a new instance of the ExcelStyler
  factory ExcelStyler.create(excel.Workbook workbook) {
    return ExcelStyler(workbook);
  }

  // Implementation to match the new ExcelStyler
  excel.Style createStyle({
    required String fontColor,
    required String backColor,
    required double fontSize,
  }) {
    return _newStyler.createStyle(
      fontColor: fontColor,
      backColor: backColor,
      fontSize: fontSize,
    );
  }
}
