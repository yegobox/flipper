import 'package:flipper_dashboard/export/models/expense.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../models/export_config.dart';
import '../utils/excel_styler.dart';
import '../utils/excel_utils.dart';
import '../utils/file_utils.dart';
import '../utils/pdf_utils.dart';

/// Service class for handling export operations
class ExportService {
  final GlobalKey<SfDataGridState> workBookKey = GlobalKey<SfDataGridState>();
  final WidgetRef ref;

  ExportService(this.ref);

  /// Exports data grid to Excel or PDF
  Future<void> exportDataGrid({
    required ExportConfig config,
    List<Expense>? expenses,
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
        final PdfDocument document =
            workBookKey.currentState!.exportToPdfDocument(
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
        final excel.Workbook workbook =
            workBookKey.currentState!.exportToExcelWorkbook();
        final excel.Worksheet reportSheet = workbook.worksheets[0];
        reportSheet.name = isStockRecount ? 'Stock Recount' : 'Report';

        if (!isStockRecount) {
          final ExcelStyler styler = ExcelStyler(workbook);

          await ExcelUtils.addHeaderAndInfoRows(
              reportSheet: reportSheet,
              styler: styler,
              config: config,
              business: business!,
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
      talker.error(e);
      talker.error(s);
    }
  }

  /// Request necessary permissions for file operations
  Future<void> requestPermissions() async {
    await FileUtils.requestPermissions();
  }
}
