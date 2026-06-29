import 'dart:io';
import 'package:flipper_services/constants.dart';
import 'package:flutter/services.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_dashboard/export/transaction_report_full_export_loader.dart';
import 'package:flipper_dashboard/export/utils/report_theme.dart';
import 'package:flipper_services/proxy.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:flipper_models/sync/models/transaction_with_items.dart';

class SaleReport {
  // Shared report palette (see ReportTheme).
  static final PdfColor borderGray = ReportTheme.borderGray;
  static final PdfColor lightGray = ReportTheme.lightGray;

  Future<void> generateSaleReport(
      {required DateTime startDate, required DateTime endDate}) async {
    final business = await ProxyService.getStrategy(Strategy.capella)
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);
    final transactionsWithItems = await loadTransactionsWithItemsForReport(
      startDate: startDate,
      endDate: endDate,
      branchId: ProxyService.box.getBranchId()!,
      forceRealData: !(ProxyService.box.enableDebug() ?? false),
      status: COMPLETE,
    );

    // Calculate totals and additional metrics
    double totalAmount = 0.0;
    double totalVatAmount = 0.0;
    int totalTransactions = transactionsWithItems.length;
    double averageTransactionValue = 0.0;

    for (final twi in transactionsWithItems) {
      totalAmount += twi.transaction.subTotal ?? 0.0;
      for (final item in twi.items) {
        totalVatAmount += item.taxAmt ?? 0.0;
      }
    }

    if (totalTransactions > 0) {
      averageTransactionValue = totalAmount / totalTransactions;
    }

    final PdfDocument document = PdfDocument();
    // Landscape gives the wide transaction table room to show every column.
    document.pageSettings.orientation = PdfPageOrientation.landscape;
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    // Branded footer (logo, "Powered by Flipper", timestamp, page numbers).
    document.template.bottom = await ReportTheme.buildFooter(pageSize);

    final ebm = await ProxyService.getStrategy(Strategy.capella).ebm(
      branchId: ProxyService.box.getBranchId()!,
    );

    final DateFormat periodFmt = DateFormat('MMMM dd, yyyy');
    double contentHeight = ReportTheme.drawHeader(
      page,
      pageSize,
      reportTitle: 'Sales Report',
      business: business,
      ebm: ebm,
      periodText:
          'Report Period: ${periodFmt.format(startDate)} - ${periodFmt.format(endDate)}',
    );

    contentHeight = ReportTheme.drawSummaryCards(page, pageSize, contentHeight, [
      ReportKpiCard(
        value: ReportTheme.formatRwf(totalAmount, trimZeros: true),
        label: 'Total Revenue',
        color: ReportTheme.primaryBlue,
      ),
      ReportKpiCard(
        value: ReportTheme.formatRwf(totalVatAmount, trimZeros: true),
        label: 'Total VAT',
        color: ReportTheme.accentGreen,
      ),
      ReportKpiCard(
        value: totalTransactions.toString(),
        label: 'Total Transactions',
        color: ReportTheme.accentPurple,
      ),
      ReportKpiCard(
        value: ReportTheme.formatRwf(averageTransactionValue, trimZeros: true),
        label: 'Avg. Transaction',
        color: ReportTheme.accentOrange,
      ),
    ]);

    await _drawEnhancedContentAsync(
        page, pageSize, transactionsWithItems, contentHeight);

    final List<int> bytes = await document.save();
    final String formattedDate =
        DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now());
    document.dispose();
    await _saveAndLaunchFile(bytes, 'Sale_report_$formattedDate.pdf');
  }

  Future<void> _drawEnhancedContentAsync(PdfPage page, Size pageSize,
      List<TransactionWithItems> transactionsWithItems, double startY) async {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 9);

    // Column widths (sum to 100% of the content width to avoid wrapping).
    final double pageWidth = pageSize.width - 80; // 40px margins on each side
    grid.columns[0].width = pageWidth * 0.04; // #
    grid.columns[1].width = pageWidth * 0.11; // Buyer TIN
    grid.columns[2].width = pageWidth * 0.13; // Buyer Name
    grid.columns[3].width = pageWidth * 0.10; // Receipt #
    grid.columns[4].width = pageWidth * 0.10; // Date
    grid.columns[5].width = pageWidth * 0.26; // Items Details
    grid.columns[6].width = pageWidth * 0.10; // Amount
    grid.columns[7].width = pageWidth * 0.08; // VAT
    grid.columns[8].width = pageWidth * 0.08; // Type
    grid.style.cellPadding = PdfPaddings(left: 4, right: 4, top: 3, bottom: 3);

    // Header row + brand styling (shared theme).
    grid.headers.add(1);
    final PdfGridRow header = grid.headers[0];
    header.cells[0].value = '#';
    header.cells[1].value = 'Buyer TIN';
    header.cells[2].value = 'Buyer Name';
    header.cells[3].value = 'Receipt #';
    header.cells[4].value = 'Date';
    header.cells[5].value = 'Items Details';
    header.cells[6].value = 'Amount';
    header.cells[7].value = 'VAT';
    header.cells[8].value = 'Type';
    ReportTheme.styleTableHeader(header);

    // Enhanced data rows
    final PdfPen borderPen = PdfPen(borderGray, width: 0.5);
    final PdfFont dataFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    final PdfFont itemFont = PdfStandardFont(PdfFontFamily.helvetica, 8);

    int index = 1;
    for (final twi in transactionsWithItems) {
      final t = twi.transaction;
      final items = twi.items;

      final row = grid.rows.add();
      row.height = 40; // Increased row height for better readability

      row.cells[0].value = index.toString();
      row.cells[1].value = t.customerTin ?? 'Individual';
      row.cells[2].value = t.customerName ?? '-';
      row.cells[3].value = t.receiptNumber?.toString() ?? '-';
      row.cells[4].value = t.createdAt != null
          ? DateFormat('MM/dd/yy').format(t.createdAt!)
          : '';

      // Enhanced items display
      if (items.isNotEmpty) {
        // get transaction item found on this transaction

        final itemsText = items.map((item) {
          return '${item.name}\n  Qty: ${item.qty} × ${item.price.toStringAsFixed(0)}\n  Total: ${item.totAmt?.toStringAsFixed(0) ?? '0'}';
        }).join('\n\n');
        row.cells[5].value = itemsText;
      } else {
        row.cells[5].value = '-';
      }

      row.cells[6].value = (t.subTotal ?? 0).toStringAsFixed(2);

      // Calculate VAT from item-level taxAmt for consistency with header totals
      double taxAmount =
          items.fold<double>(0.0, (sum, item) => sum + (item.taxAmt ?? 0.0));
      row.cells[7].value = taxAmount.toStringAsFixed(2);
      row.cells[8].value = t.receiptType ?? 'Standard';

      // Style individual cells
      for (int i = 0; i < row.cells.count; i++) {
        row.cells[i].style.borders = PdfBorders(
            left: borderPen,
            right: borderPen,
            top: borderPen,
            bottom: borderPen);
        row.cells[i].style.font = i == 5 ? itemFont : dataFont;
        row.cells[i].style.stringFormat = PdfStringFormat(
          alignment: i == 0 || i == 3 || i == 6 || i == 7
              ? PdfTextAlignment.center
              : PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.middle,
        );

        // Right-align monetary values
        if (i == 6 || i == 7) {
          row.cells[i].style.stringFormat = PdfStringFormat(
            alignment: PdfTextAlignment.right,
            lineAlignment: PdfVerticalAlignment.middle,
          );
        }
      }

      // Alternating row colors for better readability
      if (index % 2 == 0) {
        for (int i = 0; i < row.cells.count; i++) {
          row.cells[i].style.backgroundBrush = PdfSolidBrush(lightGray);
        }
      }

      index++;
    }

    // Draw the grid with proper spacing
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
          40, startY, pageSize.width - 80, pageSize.height - startY - 80),
    );
  }

  Future<void> _saveAndLaunchFile(List<int> bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, fileName);
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
    await OpenFilex.open(filePath);
  }
}
