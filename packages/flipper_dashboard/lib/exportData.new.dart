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
import 'package:syncfusion_flutter_datagrid_export/export.dart';
// Import the new modular structure
import 'export/utils/excel_utils.dart';
import 'export/utils/pdf_utils.dart';
import 'export/utils/excel_styler.dart' as new_styler;
import 'export/utils/file_utils.dart';
import 'export/models/expense.dart';
// Re-export all the necessary components from the new modular structure
export 'export/models/export_config.dart';
export 'export/models/payment_summary.dart';
export 'export/models/expense.dart';
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

mixin ExportMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  // This mixin now delegates to the new implementation in export/export_mixin.dart
  final GlobalKey<SfDataGridState> workBookKey = GlobalKey<SfDataGridState>();

  // Export the main functionality
  Future<String?> exportDataGrid({
    required dynamic config,
    List<Expense>? expenses,
    bool isStockRecount = false,
    required String headerTitle,
    required String bottomEndOfRowTitle,
  }) async {
    String? filePath;
    try {
      ref.read(isProcessingProvider.notifier).startProcessing();
      final business = await ProxyService.strategy
          .getBusiness(businessId: ProxyService.box.getBusinessId()!);

      if (ProxyService.box.exportAsPdf()) {
        final PdfDocument document =
            workBookKey.currentState!.exportToPdfDocument(
          fitAllColumnsInOnePage: true,
          autoColumnWidth: true,
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
        final excel.Workbook workbook =
            workBookKey.currentState!.exportToExcelWorkbook();
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
      return filePath; // Return the file path
    } catch (e, s) {
      ref.read(isProcessingProvider.notifier).stopProcessing();
      print('Error: $e');
      print('Stack: $s');
      rethrow;
    }
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
