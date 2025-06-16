import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
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
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:open_filex/open_filex.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flipper_dashboard/export/models/expense.dart';
import 'package:flipper_dashboard/features/config/widgets/currency_options.dart';

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
        .fold<double>(0, (sum, trans) => sum + trans.subTotal!)
        .toCurrencyFormatted(symbol: ProxyService.box.defaultCurrency());
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
        .fold<double>(0, (sum, trans) => sum + trans.cashReceived!)
        .toCurrencyFormatted(symbol: ProxyService.box.defaultCurrency());
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
  }

  Future<String?> exportDataGrid({
    required ExportConfig config,
    List<Expense>? expenses,
    bool isStockRecount = false,
    required String headerTitle,
    required String bottomEndOfRowTitle,
    required GlobalKey<SfDataGridState> workBookKey,
    List<dynamic>? manualData, // Added parameter for manual data export
    List<String>? columnNames, // Added parameter for column names
    required bool showProfitCalculations,
    String? currencyCode,
  }) async {
    String? filePath;
    try {
      // Get the system currency from settings if not provided
      final systemCurrency = currencyCode ?? ProxyService.box.defaultCurrency();

      // Calculate COGS for the transactions in the config
      double totalCOGS = 0.0;
      for (final transaction in config.transactions) {
        try {
          final transactionItems = await ProxyService.strategy.transactionItems(
            transactionId: transaction.id,
          );

          for (final item in transactionItems) {
            if (item.variantId == null) continue;
            try {
              final variant =
                  await ProxyService.strategy.getVariant(id: item.variantId);

              if (variant != null) {
                final supplyPrice = variant.supplyPrice ??
                    (variant.retailPrice != null
                        ? variant.retailPrice! * 0.7
                        : 0.0);

                final itemCOGS = supplyPrice * item.qty;
                totalCOGS += itemCOGS;
              }
            } catch (e) {
              final itemCOGS = item.price * item.qty * 0.7;
              totalCOGS += itemCOGS;
            }
          }
        } catch (e) {
          talker.error(
              'Error fetching items for transaction ${transaction.id}: $e');
        }
      }

      // Update config with calculated COGS
      config = ExportConfig(
        startDate: config.startDate,
        endDate: config.endDate,
        grossProfit: config.grossProfit,
        netProfit:
            config.grossProfit != null ? config.grossProfit! - totalCOGS : null,
        cogs: totalCOGS,
        currencyCode: systemCurrency,
        transactions: config.transactions,
      );

      // RESTORE ORIGINAL IMPLEMENTATION WITH WORKBOOK KEY
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
            exportToPdf(headerFooterExport, business!, config,
                headerTitle: headerTitle);
            addFooter(headerFooterExport, config: config);
          },
        );

        filePath = await _savePdfFile(document);
        document.dispose();
      } else {
        excel.Workbook workbook = excel.Workbook();

        try {
          if (workBookKey.currentState != null) {
            try {
              workbook = workBookKey.currentState!.exportToExcelWorkbook();
            } catch (e) {
              // If we get an error, create a fresh workbook
              talker.warning('Error using DataGrid export: $e');
              workbook = excel.Workbook();
              talker.info('Created fresh workbook after DataGrid export error');
            }
          } else {
            // For detailed view, we need to create a workbook manually
            talker.warning(
                'DataGrid state is null, using manual workbook creation');

            // Keep using the manually created workbook
            // We'll add the data to it in the subsequent steps
          }
        } catch (e) {
          talker.error('Error during export preparation: $e');
          // Ensure we have a valid workbook to continue with
          workbook = excel.Workbook();
        }

        // Get the worksheet from the workbook
        final excel.Worksheet reportSheet = workbook.worksheets[0];
        reportSheet.name = isStockRecount ? 'Stock Recount' : 'Report';

        // Add header information
        // 1. Insert rows for header
        reportSheet.insertRow(1, 3); // Insert 3 rows at the top

        // 2. Add business information (trade name and TIN)
        if (business != null) {
          // Get or create a style for the header
          final headerStyle =
              _getOrCreateStyle(workbook, 'CustomHeaderStyle', (style) {
            style.fontName = 'Calibri';
            style.fontSize = 12;
            style.bold = true;
          });

          // Row 1: Trade name and TIN
          final tradeNameCell = reportSheet.getRangeByIndex(1, 1);
          tradeNameCell.setText(
              'Trade Name: ${business.name ?? ""}, TIN: ${business.tinNumber?.toString() ?? ""}');
          tradeNameCell.cellStyle = headerStyle;

          // Row 2: Date and time
          final dateTimeCell = reportSheet.getRangeByIndex(2, 1);
          final now = DateTime.now();
          final formattedDateTime =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
          dateTimeCell.setText('Date and Time: $formattedDateTime');
          dateTimeCell.cellStyle = headerStyle;

          // Row 3: X Daily Report
          final reportTitleCell = reportSheet.getRangeByIndex(3, 1);
          reportTitleCell.setText('X Daily Report');
          reportTitleCell.cellStyle = headerStyle;

          // Merge cells for header rows to span across columns
          reportSheet.getRangeByIndex(1, 1, 1, 5).merge();
          reportSheet.getRangeByIndex(2, 1, 2, 5).merge();
          reportSheet.getRangeByIndex(3, 1, 3, 5).merge();
        }

        // Calculate total sales for NS receipts including tax
        double totalNSSales = 0.0;
        Map<String, double> nsSalesByMainGroup = {};

        if (!isStockRecount && !showProfitCalculations) {
          // Only calculate for non-detailed reports (not stock recount and not detailed)
          talker.info('Calculating NS sales totals for non-detailed report');

          // Filter transactions with receiptType == 'NS'
          final nsTransactions = config.transactions
              .where((transaction) => transaction.receiptType == 'NS')
              .toList();

          // Calculate total NS sales including tax
          for (final transaction in nsTransactions) {
            // Add subtotal and tax amount for total including tax
            final subtotal = transaction.subTotal ?? 0.0;
            final taxAmount = transaction.taxAmount ?? 0.0;
            final totalWithTax = subtotal + taxAmount;
            totalNSSales += totalWithTax;

            // Get transaction items to calculate by main group
            try {
              // Ensure transaction.id is converted to String
              final transId = transaction.id.toString();
              if (transId.isEmpty) {
                talker.warning(
                    'Transaction ID is null or empty, skipping items fetch');
                continue;
              }

              final items = await ProxyService.strategy.transactionItems(
                transactionId: transId,
                branchId: (await ProxyService.strategy
                        .branch(serverId: ProxyService.box.getBranchId()!))!
                    .id,
              );

              for (final item in items) {
                try {
                  // Get the variant to determine its product
                  final variantId =
                      item.variantId != null ? item.variantId.toString() : '';
                  if (variantId.isEmpty) {
                    talker.warning(
                        'Variant ID is null or empty for item ${item.id}');
                    continue;
                  }

                  final variant = await ProxyService.strategy.getVariant(
                    id: variantId,
                  );

                  // Get product category or use variant name as fallback
                  String categoryName = 'Uncategorized';
                  if (variant != null && variant.productId != null) {
                    final product = await ProxyService.strategy.getProduct(
                      id: variant.productId.toString(),
                      branchId: ProxyService.box.getBranchId()!,
                      businessId: ProxyService.box.getBusinessId()!,
                    );

                    // Add dummy category data for demonstration purposes
                    if (product != null && product.categoryId != null) {
                      // In a real implementation, you would fetch the category name from the categoryId
                      // For now, use dummy category names based on categoryId to demonstrate the feature
                      final categoryId = product.categoryId.toString();
                      final category = await ProxyService.strategy.category(
                        id: categoryId,
                      );
                      categoryName = category?.name ?? 'Uncategorized';
                    }
                  }

                  final itemTotal =
                      (item.price * item.qty) + (item.taxAmt ?? 0.0);

                  // Add to category total
                  nsSalesByMainGroup[categoryName] =
                      (nsSalesByMainGroup[categoryName] ?? 0.0) + itemTotal;
                } catch (e) {
                  talker
                      .warning('Error getting product for item ${item.id}: $e');
                  // If we can't get the product, add to uncategorized
                  final itemTotal =
                      (item.price * item.qty) + (item.taxAmt ?? 0.0);
                  nsSalesByMainGroup['Uncategorized'] =
                      (nsSalesByMainGroup['Uncategorized'] ?? 0.0) + itemTotal;
                }
              }
            } catch (e) {
              talker.warning(
                  'Error getting items for transaction ${transaction.id}: $e');
            }
          }

          talker.info('Total NS sales (including tax): $totalNSSales');
          talker.info('NS sales by main group: $nsSalesByMainGroup');

          // Add NS sales summary to Excel report
          if (totalNSSales > 0) {
            // Find the last row of data to position our summary
            int summaryStartRow = 5; // Default starting row

            // If we have data, find the last row and add some space
            if (manualData != null && manualData.isNotEmpty) {
              summaryStartRow = 5 +
                  manualData.length +
                  3; // Data starts at row 5, add 3 for spacing
            } else if (config.transactions.isNotEmpty) {
              // For non-manual data, estimate based on transactions
              summaryStartRow = 5 + config.transactions.length + 3;
            }

            // Add NS Sales Summary header
            final headerCell = reportSheet.getRangeByIndex(summaryStartRow, 1);
            headerCell.setText('NS Sales Summary');
            headerCell.cellStyle.bold = true;
            headerCell.cellStyle.fontSize = 14;

            // Add Total NS Sales row
            reportSheet
                .getRangeByIndex(summaryStartRow + 2, 1)
                .setText('Total NS Sales (incl. Tax)');
            final totalCell =
                reportSheet.getRangeByIndex(summaryStartRow + 2, 2);
            totalCell.setNumber(totalNSSales);
            totalCell.numberFormat = '#,##0.00';
            totalCell.cellStyle.hAlign = excel.HAlignType.right;

            // Add Sales by Main Group header
            reportSheet
                .getRangeByIndex(summaryStartRow + 4, 1)
                .setText('Sales by Main Group');
            reportSheet.getRangeByIndex(summaryStartRow + 4, 1).cellStyle.bold =
                true;

            // Add column headers for the breakdown
            reportSheet
                .getRangeByIndex(summaryStartRow + 5, 1)
                .setText('Category');
            reportSheet
                .getRangeByIndex(summaryStartRow + 5, 2)
                .setText('Amount');
            reportSheet.getRangeByIndex(summaryStartRow + 5, 1).cellStyle.bold =
                true;
            reportSheet.getRangeByIndex(summaryStartRow + 5, 2).cellStyle.bold =
                true;

            // Add rows for each category
            int rowIndex = summaryStartRow + 6;
            nsSalesByMainGroup.forEach((category, amount) {
              reportSheet.getRangeByIndex(rowIndex, 1).setText(category);
              final amountCell = reportSheet.getRangeByIndex(rowIndex, 2);
              amountCell.setNumber(amount);
              amountCell.numberFormat = '#,##0.00';
              amountCell.cellStyle.hAlign = excel.HAlignType.right;
              rowIndex++;
            });
          }
        }

        // Check if we have manual data to populate the workbook with
        if (manualData != null &&
            manualData.isNotEmpty &&
            columnNames != null &&
            columnNames.isNotEmpty) {
          talker.info(
              'Populating workbook with manual data (${manualData.length} rows)');

          // Create a header style that matches DataGrid export
          final headerStyle =
              _getOrCreateStyle(workbook, 'ManualDataHeaderStyle', (style) {
            style.fontName = 'Calibri';
            style.fontSize = 11;
            style.bold = true;
            style.hAlign = excel.HAlignType.center;
            style.vAlign = excel.VAlignType.center;
            style.backColor =
                '#D9D9D9'; // Light gray background like DataGrid export
            style.fontColor = '#000000'; // Black text like DataGrid export
            style.borders.all.lineStyle = excel.LineStyle.none;
            style.borders.all.color = '#A6A6A6';
          });

          // Create a data cell style that matches DataGrid export
          final dataStyle =
              _getOrCreateStyle(workbook, 'ManualDataStyle', (style) {
            style.fontName = 'Calibri';
            style.fontSize = 11;
            style.hAlign = excel.HAlignType.left;
            style.vAlign = excel.VAlignType.center;
            style.borders.all.lineStyle = excel.LineStyle.none;
            style.borders.all.color = '#A6A6A6';
          });

          // Create a numeric cell style
          final numericStyle =
              _getOrCreateStyle(workbook, 'ManualNumericStyle', (style) {
            style.fontName = 'Calibri';
            style.fontSize = 11;
            style.hAlign = excel.HAlignType.left;
            style.vAlign = excel.VAlignType.center;
            style.numberFormat = '#,##0.00';
            style.borders.all.lineStyle = excel.LineStyle.none;
            style.borders.all.color = '#A6A6A6';
          });

          // Add column headers (starting at row 4 due to the added header information)
          for (int i = 0; i < columnNames.length; i++) {
            final cell = reportSheet.getRangeByIndex(4, i + 1);
            cell.setText(columnNames[i]);
            cell.cellStyle = headerStyle;

            // Set column width to match DataGrid export (auto-fit will be applied later)
            reportSheet.setColumnWidthInPixels(
                i + 1, 120); // Initial width before auto-fit
          }

          // Add data rows (starting at row 5 due to the added header information)

          for (int rowIndex = 0; rowIndex < manualData.length; rowIndex++) {
            final item = manualData[rowIndex];
            Map<String, dynamic> rowData;

            try {
              // Try to convert the item to a map
              rowData = item is Map ? item : item.toJson();
            } catch (e) {
              // If toJson() fails, create a map with basic properties
              rowData = {};

              // Attempt to extract common properties based on column names
              for (String colName in columnNames) {
                try {
                  // Try to access the property directly
                  final value = _getItemProperty(item, colName);
                  rowData[colName] = value;
                } catch (e) {
                  rowData[colName] = ''; // Default empty value
                }
              }
            }

            // Add each cell in the row
            for (int colIndex = 0; colIndex < columnNames.length; colIndex++) {
              final colName = columnNames[colIndex];
              final cell =
                  reportSheet.getRangeByIndex(rowIndex + 5, colIndex + 1);

              // Get the value for this column
              var value = rowData[colName];
              if (value == null) {
                // Try to find a matching key regardless of case
                final matchingKey = rowData.keys.firstWhere(
                  (k) => k.toString().toLowerCase() == colName.toLowerCase(),
                  orElse: () => '',
                );
                if (matchingKey.isNotEmpty) {
                  value = rowData[matchingKey];
                }
              }

              // Format and set the cell value
              if (value is num) {
                cell.setNumber(value.toDouble());
                cell.cellStyle = numericStyle;
              } else if (value is DateTime) {
                cell.setDateTime(value);
                cell.numberFormat = 'yyyy-mm-dd hh:mm:ss';
                cell.cellStyle = dataStyle;
              } else {
                cell.setText(value?.toString() ?? '');
                cell.cellStyle = dataStyle;
              }
            }
          }

          // Auto-fit all columns for better readability
          for (int i = 1; i <= reportSheet.getLastColumn(); i++) {
            reportSheet.autoFitColumn(i);
          }
        } else {
          // Add a header row to ensure the workbook has some content
          if (workbook.worksheets[0].getLastRow() < 4) {
            // Adjusted for header rows
            talker.info('Adding basic structure to empty workbook');
            reportSheet.getRangeByName('A4').setText('Report');
          }
        }

        if (!isStockRecount) {
          final styler = ExcelStyler(workbook);

          // Only format columns with profit calculations if showProfitCalculations is true
          if (showProfitCalculations) {
            _formatColumns(reportSheet, config.currencyFormat);
          } else {
            // Just auto-fit columns without adding profit calculations
            for (int i = 1; i <= reportSheet.getLastColumn(); i++) {
              reportSheet.autoFitColumn(i);
            }
            talker.debug('Auto-fitting columns without profit calculations');
          }

          // First add the expenses sheet if there are expenses and we're showing profit calculations
          bool hasExpensesSheet = false;
          if (showProfitCalculations &&
              expenses != null &&
              expenses.isNotEmpty) {
            _addExpensesSheet(
                workbook, expenses, styler, config.currencyFormat);
            hasExpensesSheet = true;
          }

          // Then add the Net Profit row to the report sheet if we have expenses and showing profit calculations
          if (showProfitCalculations && hasExpensesSheet) {
            _addNetProfitRow(reportSheet, workbook, config.currencyFormat);
          }

          // Always add the payment method sheet regardless of profit calculations
          await _addPaymentMethodSheet(workbook, config, styler);
        }

        filePath = await _saveExcelFile(workbook);
        workbook.dispose();
      }

      ref.read(isProcessingProvider.notifier).stopProcessing();
      await _openOrShareFile(filePath);
      return filePath;
    } catch (e, s) {
      ref.read(isProcessingProvider.notifier).stopProcessing();
      talker.error('Error: $e');
      talker.error('Stack: $s');
      return null;
    }
  }

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

  void _formatColumns(excel.Worksheet sheet, String currencyFormat) {
    // Format currency columns
    for (int row = 1; row <= sheet.getLastRow(); row++) {
      sheet.getRangeByIndex(row, 9).numberFormat = currencyFormat;
    }

    // Auto-fit all columns for better readability
    for (int i = 1; i <= sheet.getLastColumn(); i++) {
      sheet.autoFitColumn(i);
    }

    // Ensure all columns are properly sized
    talker.debug('Auto-fitting all columns in the report sheet');

    // Add GrossProfit sum at the end of all rows
    final lastRow = sheet.getLastRow();
    final lastColumn = sheet.getLastColumn();

    // Find the GrossProfit column - typically column 9 based on the formatting above
    // But let's look for a header with 'GrossProfit' or 'Gross Profit' to be sure
    int grossProfitColumn = 9; // Default based on currency formatting

    // Check if we can find a better match for the GrossProfit column by header name
    for (int col = 1; col <= lastColumn; col++) {
      final cellValue = sheet.getRangeByIndex(1, col).getText();
      if (cellValue != null &&
          (cellValue.toLowerCase().contains('gross') &&
              cellValue.toLowerCase().contains('profit'))) {
        grossProfitColumn = col;
        break;
      }
    }

    // Add a total row at the bottom
    final totalRowIndex = lastRow + 2; // Leave one blank row

    // Create a style for the total row
    final style = sheet.workbook.styles.add('GrossProfitTotalStyle');
    style.fontName = 'Calibri';
    style.fontSize = 12;
    style.bold = true;
    style.hAlign = excel.HAlignType.left;
    style.borders.top.lineStyle = excel.LineStyle.none;
    style.borders.bottom.lineStyle = excel.LineStyle.thin;

    // Add 'Total Gross Profit:' label
    sheet
        .getRangeByIndex(totalRowIndex, grossProfitColumn - 1)
        .setText('Total Gross Profit:');
    sheet.getRangeByIndex(totalRowIndex, grossProfitColumn - 1).cellStyle =
        style;

    // Add the SUM formula for the GrossProfit column
    final sumCell = sheet.getRangeByIndex(totalRowIndex, grossProfitColumn);
    sumCell.setFormula(
        '=SUM(${_getColumnLetter(grossProfitColumn)}2:${_getColumnLetter(grossProfitColumn)}$lastRow)');
    sumCell.numberFormat = currencyFormat;
    sumCell.cellStyle = style;

    // Auto-fit the columns again after adding the total row
    sheet.autoFitColumn(grossProfitColumn - 1);
    sheet.autoFitColumn(grossProfitColumn);

    // Note: Net Profit calculation is now handled by the _addNetProfitRow method
    // which is called after the Expenses sheet has been created
  }

  // Helper method to convert column index to Excel column letter (e.g., 1 -> A, 2 -> B, etc.)
  String _getColumnLetter(int columnIndex) {
    String columnLetter = '';
    while (columnIndex > 0) {
      int remainder = (columnIndex - 1) % 26;
      columnLetter = String.fromCharCode(65 + remainder) + columnLetter;
      columnIndex = (columnIndex - remainder - 1) ~/ 26;
    }
    return columnLetter;
  }

  String normalizePaymentMethod(String method) {
    return method.trim().toUpperCase();
  }

  // Helper method to find a worksheet by name
  excel.Worksheet? _findWorksheetByName(excel.Workbook workbook, String name) {
    for (int i = 0; i < workbook.worksheets.count; i++) {
      if (workbook.worksheets[i].name == name) {
        return workbook.worksheets[i];
      }
    }
    return null;
  }

  // Add Net Profit row to the report sheet after the Expenses sheet has been created
  void _addNetProfitRow(excel.Worksheet reportSheet, excel.Workbook workbook,
      String currencyFormat) {
    try {
      // Find the last row in the report sheet (where the Gross Profit is)
      final lastRow = reportSheet.getLastRow();
      final totalRowIndex = lastRow;

      // Find the column with the Gross Profit value (typically column 9 based on currency formatting)
      int grossProfitColumn = 9;

      // Check if we can find a better match for the GrossProfit column by header name
      for (int col = 1; col <= reportSheet.getLastColumn(); col++) {
        final cellValue = reportSheet.getRangeByIndex(1, col).getText();
        if (cellValue != null &&
            (cellValue.toLowerCase().contains('gross') &&
                cellValue.toLowerCase().contains('profit'))) {
          grossProfitColumn = col;
          break;
        }
      }

      // Add Net Profit row below Gross Profit
      final netProfitRowIndex = totalRowIndex + 1;

      // Create a style for the Net Profit row
      final netProfitStyle = workbook.styles.add('NetProfitTotalStyle');
      netProfitStyle.fontName = 'Calibri';
      netProfitStyle.fontSize = 12;
      netProfitStyle.bold = true;
      netProfitStyle.hAlign = excel.HAlignType.left;
      netProfitStyle.borders.top.lineStyle = excel.LineStyle.none;
      netProfitStyle.borders.bottom.lineStyle = excel.LineStyle.none;
      netProfitStyle.backColor =
          '#E2EFDA'; // Light green background for Net Profit

      // Add 'Net Profit:' label
      reportSheet
          .getRangeByIndex(netProfitRowIndex, grossProfitColumn - 1)
          .setText('Net Profit:');
      reportSheet
          .getRangeByIndex(netProfitRowIndex, grossProfitColumn - 1)
          .cellStyle = netProfitStyle;

      // Get the Net Profit cell
      final netProfitCell =
          reportSheet.getRangeByIndex(netProfitRowIndex, grossProfitColumn);

      // Find the Expenses sheet which we know exists at this point
      final expensesSheet = _findWorksheetByName(workbook, 'Expenses');
      if (expensesSheet != null) {
        // Get the last row in the Expenses sheet
        final lastExpenseRow = expensesSheet.getLastRow();
        // The total expenses are in the cell below the last expense item
        final totalExpensesRowIndex = lastExpenseRow;

        // Create a direct cell reference formula to subtract expenses from gross profit
        final formula =
            '=${_getColumnLetter(grossProfitColumn)}$totalRowIndex-Expenses!B$totalExpensesRowIndex';

        // This is a properly constructed Dart string with proper interpolation
        netProfitCell.setFormula(formula);

        // Log the formula for debugging
        talker.debug('Created Net Profit formula: $formula');
        talker.debug(
            'Referencing Gross Profit cell: ${_getColumnLetter(grossProfitColumn)}$totalRowIndex');
        talker.debug(
            'Referencing Total Expenses cell: Expenses!B$totalExpensesRowIndex');
      } else {
        // This shouldn't happen since we only call this method when the Expenses sheet exists
        talker.error('Expenses sheet not found when adding Net Profit row');
        // Fallback to just using the Gross Profit value
        netProfitCell.setFormula(
            '=${_getColumnLetter(grossProfitColumn)}$totalRowIndex');
      }

      // Apply formatting to the Net Profit cell
      netProfitCell.numberFormat = currencyFormat;
      netProfitCell.cellStyle = netProfitStyle;

      // Auto-fit all columns after adding the Net Profit row
      for (int i = 1; i <= reportSheet.getLastColumn(); i++) {
        reportSheet.autoFitColumn(i);
      }
    } catch (e) {
      talker.error('Error adding Net Profit row: $e');
    }
  }

  Future<void> _addPaymentMethodSheet(
    excel.Workbook workbook,
    ExportConfig config,
    ExcelStyler styler,
  ) async {
    final sheetName = 'Payment Methods';

    try {
      final paymentMethodSheet = workbook.worksheets.addWithName(sheetName);
      await _initializeSheet(paymentMethodSheet, styler);

      final paymentData = await _processTransactions(config.transactions);

      if (paymentData.isEmpty) {
        talker.warning('No payment totals to write to sheet');
        return;
      }

      await _writeDataToSheet(
        sheet: paymentMethodSheet,
        paymentData: paymentData,
        config: config,
      );

      _formatSheet(paymentMethodSheet);
      _addTotalRow(paymentMethodSheet, paymentData.length + 2, config);

      talker.debug('Successfully completed payment method sheet generation');
    } catch (e, stack) {
      talker.error('Error in payment method sheet generation: $e');
      talker.error(stack);
      rethrow;
    }
  }

  Future<void> _initializeSheet(
    excel.Worksheet sheet,
    ExcelStyler styler,
  ) async {
    sheet.clear();

    final headerStyle = styler.createStyle(
      fontColor: '#FFFFFF',
      backColor: '#4472C4',
      fontSize: 14,
    );

    sheet.getRangeByIndex(1, 1).setText('Payment Type');
    sheet.getRangeByIndex(1, 2).setText('Amount Received');
    sheet.getRangeByIndex(1, 3).setText('Transaction Count');
    sheet.getRangeByIndex(1, 4).setText('% of Total');

    final headerRange = sheet.getRangeByIndex(1, 1, 1, 4);
    headerRange.cellStyle = headerStyle;
  }

  Future<List<PaymentSummary>> _processTransactions(
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
          if (!_isValidPayment(paymentType)) {
            talker.warning(
                'Invalid payment data for transaction: ${transaction.id}');
            continue;
          }

          _updatePaymentTotals(paymentTotals, paymentType);
        }
      } catch (e, stack) {
        talker.error('Error processing transaction ${transaction.id}: $e');
        talker.error(stack);
      }
    }

    final sortedData = paymentTotals.values.toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    talker.debug('Final payment totals processed: ${sortedData.length}');
    return sortedData;
  }

  bool _isValidPayment(TransactionPaymentRecord payment) {
    return payment.paymentMethod != null && payment.amount != null;
  }

  void _updatePaymentTotals(
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

  Future<void> _writeDataToSheet({
    required excel.Worksheet sheet,
    required List<PaymentSummary> paymentData,
    required ExportConfig config,
  }) async {
    int rowIndex = 2;
    final totalAmount = paymentData.fold<double>(
      0,
      (sum, data) => sum + data.amount,
    );

    for (final data in paymentData) {
      try {
        sheet.getRangeByIndex(rowIndex, 1).setText(data.method);

        final amountCell = sheet.getRangeByIndex(rowIndex, 2);
        amountCell.setNumber(data.amount);
        amountCell.numberFormat = config.currencyFormat;

        final countCell = sheet.getRangeByIndex(rowIndex, 3);
        countCell.setNumber(data.count.toDouble());
        countCell.numberFormat = '#,##0';

        final percentCell = sheet.getRangeByIndex(rowIndex, 4);
        percentCell.setNumber(data.amount / totalAmount);
        percentCell.numberFormat = '0.00%';

        talker.debug('Wrote row for ${data.method}: ${data.amount}');
        rowIndex++;
      } catch (e) {
        talker.warning('Error writing row for ${data.method}: $e');
      }
    }
  }

  void _formatSheet(excel.Worksheet sheet) {
    // Auto-fit all columns that have data
    for (int i = 1; i <= sheet.getLastColumn(); i++) {
      sheet.autoFitColumn(i);
    }

    // Hide any empty columns beyond our data
    for (int col = 5; col <= sheet.getLastColumn(); col++) {
      bool isEmpty = true;
      for (int row = 1; row <= sheet.getLastRow(); row++) {
        if (sheet.getRangeByIndex(row, col).getText()?.isNotEmpty == true) {
          isEmpty = false;
          break;
        }
      }
      if (isEmpty) {
        sheet.getRangeByIndex(1, col).columnWidth = 0;
      }
    }
  }

  void _addTotalRow(
    excel.Worksheet sheet,
    int lastDataRow,
    ExportConfig config,
  ) {
    sheet.getRangeByIndex(lastDataRow, 1).setText('Total');

    final totalCell = sheet.getRangeByIndex(lastDataRow, 2);
    totalCell.setFormula('=SUM(B2:B${lastDataRow - 1})');
    totalCell.numberFormat = config.currencyFormat;

    final totalCountCell = sheet.getRangeByIndex(lastDataRow, 3);
    totalCountCell.setFormula('=SUM(C2:C${lastDataRow - 1})');
    totalCountCell.numberFormat = '#,##0';

    final totalPercentCell = sheet.getRangeByIndex(lastDataRow, 4);
    totalPercentCell.setNumber(1);
    totalPercentCell.numberFormat = '0.00%';
  }

  void _addExpensesSheet(excel.Workbook workbook, List<Expense> expenses,
      ExcelStyler styler, String currencyFormat) {
    final expenseSheet = workbook.worksheets.addWithName('Expenses');

    // Add headers without styling
    expenseSheet.getRangeByIndex(1, 1).setText('Expense');
    expenseSheet.getRangeByIndex(1, 2).setText('Amount');

    // Add expense data
    for (int i = 0; i < expenses.length; i++) {
      final rowIndex = i + 2;
      expenseSheet.getRangeByIndex(rowIndex, 1).setText(expenses[i].name);
      expenseSheet.getRangeByIndex(rowIndex, 2).setValue(expenses[i].amount);

      // Set number format for amount column without styling
      expenseSheet.getRangeByIndex(rowIndex, 2).numberFormat = currencyFormat;
    }

    final lastDataRow = expenseSheet.getLastRow();

    // Add total row without styling
    expenseSheet.getRangeByIndex(lastDataRow + 1, 1).setText('Total Expenses');

    final totalExpensesCell = expenseSheet.getRangeByIndex(lastDataRow + 1, 2);
    totalExpensesCell.setFormula('=SUM(B2:B$lastDataRow)');
    totalExpensesCell.numberFormat = currencyFormat;

    // Auto-fit all columns for better readability
    for (int i = 1; i <= expenseSheet.getLastColumn(); i++) {
      expenseSheet.autoFitColumn(i);
    }

    // Create named range for the total expenses cell
    workbook.names.add('TotalExpenses', totalExpensesCell);
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

      await file.writeAsBytes(bytes, flush: true);
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

  /// Helper method to safely get a property from an object by name
  dynamic _getItemProperty(dynamic item, String propertyName) {
    if (item == null) return '';

    try {
      // For map-like objects, try to access property as a key
      if (item is Map) {
        // Try exact match first
        if (item.containsKey(propertyName)) {
          return item[propertyName] ?? '';
        }

        // Try case-insensitive match
        final lowerKey = propertyName.toLowerCase();
        for (final key in item.keys) {
          if (key.toString().toLowerCase() == lowerKey) {
            return item[key] ?? '';
          }
        }
      }

      // Try to convert the object to a map using toJson if available
      try {
        // Use dynamic invocation to call toJson if it exists
        final jsonData = item.toJson();
        if (jsonData is Map) {
          // Try exact match first
          if (jsonData.containsKey(propertyName)) {
            return jsonData[propertyName] ?? '';
          }

          // Try case-insensitive match
          final lowerKey = propertyName.toLowerCase();
          for (final key in jsonData.keys) {
            if (key.toString().toLowerCase() == lowerKey) {
              return jsonData[key] ?? '';
            }
          }
        }
      } catch (_) {
        // toJson not available, continue with other approaches
      }

      // Try common properties by name using dynamic access
      try {
        // This uses dynamic invocation which bypasses static type checking
        // It will throw if the property doesn't exist at runtime
        return item[propertyName] ?? '';
      } catch (_) {
        // Property doesn't exist, continue with other approaches
      }

      // Last resort: try to convert to string
      return item.toString();
    } catch (e) {
      return ''; // Return empty string if property access fails
    }
  }

  Future<void> requestPermissions() async {
    await permission.Permission.storage.request();
    await permission.Permission.manageExternalStorage.request();

    if (await permission.Permission.notification.isDenied) {
      await permission.Permission.notification.request();
    }
  }

  // Helper method to get an existing style or create a new one if it doesn't exist
  excel.Style _getOrCreateStyle(excel.Workbook workbook, String styleName,
      Function(excel.Style) configureStyle) {
    excel.Style style;

    try {
      // Try to get the existing style
      final existingStyle = workbook.styles[styleName];
      if (existingStyle != null) {
        style = existingStyle;
      } else {
        throw Exception('Style not found');
      }
    } catch (e) {
      // Style doesn't exist, create it
      style = workbook.styles.add(styleName);
      configureStyle(style);
    }

    return style;
  }

  final _mimeTypes = {
    'xls': 'application/vnd.ms-excel',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'pdf': 'application/pdf',
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
  DateTime? startDate;
  DateTime? endDate;
  double? grossProfit;
  double? netProfit;
  double? cogs;
  String currencyCode;
  String currencySymbol;
  String currencyFormat;
  final List<ITransaction> transactions;
  ExportConfig({
    this.startDate,
    this.endDate,
    this.grossProfit,
    this.netProfit,
    this.cogs,
    this.currencyCode = 'RWF',
    required this.transactions,
  })  : currencySymbol = CurrencyOptions.getSymbolForCurrency(currencyCode),
        currencyFormat =
            '${CurrencyOptions.getSymbolForCurrency(currencyCode)}#,##0.00_);${CurrencyOptions.getSymbolForCurrency(currencyCode)}#,##0.00;${CurrencyOptions.getSymbolForCurrency(currencyCode)} 0.00';
}
