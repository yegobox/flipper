import 'dart:io';
import 'package:flipper_dashboard/data_view_reports/DynamicDataSource.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_dashboard/export/transaction_report_full_export_loader.dart';
import 'package:flipper_dashboard/export/utils/report_theme.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:ui' as ui;

// Helper class to handle PDF drawing
class PdfHelper {
  static void drawText({
    required PdfPage page,
    required String text,
    required PdfFont font,
    required double x,
    required double y,
    required double width,
    PdfTextAlignment align = PdfTextAlignment.left,
    PdfBrush? brush,
  }) {
    final textElement = PdfTextElement(text: text, font: font, brush: brush);
    textElement.draw(
      page: page,
      bounds: ui.Rect.fromLTWH(x, y, width, 0),
      format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate),
    )!;
  }

  static Future<double> drawTable({
    required PdfDocument document,
    required PdfPage page,
    required List<Map<String, dynamic>> data,
    required double startY,
    required double pageWidth,
    required double margin,
    required PdfFont normalFont,
    required PdfFont boldFont,
  }) async {
    if (data.isEmpty) {
      // If no data, show a message
      PdfHelper.drawText(
        page: page,
        text: 'No transaction items found for the selected period',
        font: normalFont,
        x: margin,
        y: startY,
        width: pageWidth - (2 * margin),
        align: PdfTextAlignment.center,
      );
      return startY + 20;
    }

    const double rowHeight = 25;
    const double headerHeight = 30;
    const double cellPadding = 4;
    const double footerSpace = 120; // Space needed for footer

    final headers = [
      'No',
      'Item Name',
      'Item Code',
      'Unit Price',
      'Tax Rate',
      'Sold Qty',
      'Remain Qty',
    ];

    final columnWidths = [
      0.4, // No
      2.5, // Item Name
      1.8, // Item Code - Increased to accommodate longer codes
      1.0, // Unit Price
      0.8, // Tax Rate
      0.8, // Sold Qty
      1.0, // Remain Qty
    ];

    // Calculate total width for scaling
    final totalWidth = columnWidths.fold(0.0, (sum, width) => sum + width);
    final availableWidth = pageWidth - (2 * margin);

    // Create pen for borders
    final borderPen = PdfPen(PdfColor(100, 100, 100), width: 0.5);
    final headerBrush = PdfSolidBrush(ReportTheme.primaryBlue);

    // Draw table header
    double x = margin;
    double y = startY;

    // Draw header background with border
    page.graphics.drawRectangle(
      brush: headerBrush,
      pen: borderPen,
      bounds: ui.Rect.fromLTWH(x, y, availableWidth, headerHeight),
    );

    // Draw header cell borders and text
    double currentX = x;
    for (var i = 0; i < headers.length; i++) {
      final colWidth = (columnWidths[i] / totalWidth) * availableWidth;

      // Draw vertical border for each header cell (except first one)
      if (i > 0) {
        page.graphics.drawLine(
          borderPen,
          ui.Offset(currentX, y),
          ui.Offset(currentX, y + headerHeight),
        );
      }

      // Draw header text with better alignment
      page.graphics.drawString(
        headers[i],
        boldFont,
        brush: PdfSolidBrush(ReportTheme.white),
        bounds: ui.Rect.fromLTWH(
          currentX + cellPadding,
          y + (headerHeight - boldFont.height) / 2,
          colWidth - (2 * cellPadding),
          boldFont.height,
        ),
        format: PdfStringFormat(
          alignment: i == 0 || i == 1
              ? PdfTextAlignment.left
              : PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle,
        ),
      );

      currentX += colWidth;
    }

    y += headerHeight;

    // Draw table rows
    for (int rowIndex = 0; rowIndex < data.length; rowIndex++) {
      final row = data[rowIndex];
      currentX = margin;

      // Skip if row doesn't have required data
      if (row['Item Name'] == null) continue;

      // Check if we need a new page before drawing this row
      if (y + rowHeight > page.getClientSize().height - footerSpace) {
        page = document.pages.add();
        y = margin;

        // Redraw header on new page
        currentX = margin;

        // Draw header background with border
        page.graphics.drawRectangle(
          brush: headerBrush,
          pen: borderPen,
          bounds: ui.Rect.fromLTWH(currentX, y, availableWidth, headerHeight),
        );

        // Draw header cell borders and text
        currentX = margin;
        for (var i = 0; i < headers.length; i++) {
          final colWidth = (columnWidths[i] / totalWidth) * availableWidth;

          // Draw vertical border for each header cell (except first one)
          if (i > 0) {
            page.graphics.drawLine(
              borderPen,
              ui.Offset(currentX, y),
              ui.Offset(currentX, y + headerHeight),
            );
          }

          // Draw header text
          page.graphics.drawString(
            headers[i],
            boldFont,
            brush: PdfSolidBrush(ReportTheme.white),
            bounds: ui.Rect.fromLTWH(
              currentX + cellPadding,
              y + (headerHeight - boldFont.height) / 2,
              colWidth - (2 * cellPadding),
              boldFont.height,
            ),
            format: PdfStringFormat(
              alignment: i == 0 || i == 1
                  ? PdfTextAlignment.left
                  : PdfTextAlignment.center,
              lineAlignment: PdfVerticalAlignment.middle,
            ),
          );

          currentX += colWidth;
        }

        y += headerHeight;
      }

      // Alternate row background
      PdfBrush? rowBrush;
      if (rowIndex % 2 == 0) {
        rowBrush = PdfSolidBrush(PdfColor(248, 248, 248));
        page.graphics.drawRectangle(
          brush: rowBrush,
          bounds: ui.Rect.fromLTWH(margin, y, availableWidth, rowHeight),
        );
      }

      // Draw row border (top and bottom)
      page.graphics.drawRectangle(
        pen: borderPen,
        bounds: ui.Rect.fromLTWH(margin, y, availableWidth, rowHeight),
      );

      // Draw cell values
      final values = [
        row['No'].toString(),
        row['Item Name']?.toString() ?? '',
        row['Item Code']?.toString() ?? '',
        (row['Unit Price'] is num
            ? (row['Unit Price'] as num).toStringAsFixed(2)
            : row['Unit Price']?.toString() ?? '0.00'),
        row['Tax']?.toString() ?? '0.00',
        row['Sold Quantity']?.toString() ?? '0',
        row['Remain Quantity']?.toString() ?? '0',
      ];

      for (var i = 0; i < values.length; i++) {
        final colWidth = (columnWidths[i] / totalWidth) * availableWidth;

        // Draw vertical border for each cell (except first one)
        if (i > 0) {
          page.graphics.drawLine(
            borderPen,
            ui.Offset(currentX, y),
            ui.Offset(currentX, y + rowHeight),
          );
        }

        // Draw cell text with proper alignment
        page.graphics.drawString(
          values[i],
          normalFont,
          bounds: ui.Rect.fromLTWH(
            currentX + cellPadding,
            y + (rowHeight - normalFont.height) / 2,
            colWidth - (2 * cellPadding),
            normalFont.height,
          ),
          format: PdfStringFormat(
            alignment: i == 0 || i == 1
                ? PdfTextAlignment.left
                : PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle,
          ),
        );

        currentX += colWidth;
      }

      y += rowHeight;
    }

    return y;
  }
}

class PLUReport {
  Future<void> generatePLUReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final business = await ProxyService.getStrategy(Strategy.capella).getBusiness(
      businessId: ProxyService.box.getBusinessId()!,
    );

    // Fetch transactions with their items (Capella-backed; see helper docs).
    final transactionsWithItems = await loadTransactionsWithItemsForReport(
      startDate: startDate,
      endDate: endDate,
      branchId: ProxyService.box.getBranchId()!,
      forceRealData: !(ProxyService.box.enableDebug() ?? false),
      status: COMPLETE,
    );

    // Extract all transaction items
    final List<TransactionItem> allItems = transactionsWithItems
        .expand((twi) => twi.items)
        .where((item) => item.variantId != null) // Skip items without variant
        .toList();

    // Group items by variant ID
    final Map<String, List<TransactionItem>> groupedItems = {};
    for (final item in allItems) {
      final variantId = item.variantId!;
      if (!groupedItems.containsKey(variantId)) {
        groupedItems[variantId] = [];
      }
      groupedItems[variantId]!.add(item);
    }

    // Prepare report data
    final List<Map<String, dynamic>> reportData = [];
    int i = 1;
    double totalSoldQty = 0;
    double totalRemaining = 0;

    for (final entry in groupedItems.entries) {
      final variantId = entry.key;
      final items = entry.value;
      if (items.isEmpty) continue;

      // Get variant details from database
      final variant = await ProxyService.getStrategy(Strategy.capella).getVariant(id: variantId);

      if (variant == null) continue;
      talker.info(variant.id, "${variant.lastTouched}:${variant.name}");
      // Calculate totals
      final soldQty = items.fold<double>(0, (sum, item) => sum + item.qty);
      totalSoldQty += soldQty;
      totalRemaining += variant.stock?.currentStock ?? 0;

      // Use tax percentage from the first item
      reportData.add({
        'No': i++,
        'Item Name': variant.name,
        'Item Code': variant.itemCd,
        'Unit Price': variant.retailPrice,
        'Tax': '${variant.taxPercentage}%',
        'Sold Quantity': soldQty.toStringAsFixed(2),
        'Remain Quantity':
            variant.stock?.currentStock?.toStringAsFixed(1) ?? '0.00',
      });
    }

    // Create a new PDF document
    final document = PdfDocument();
    final page = document.pages.add();
    final pageSize = page.getClientSize();

    // Branded footer (logo, "Powered by Flipper", timestamp, page numbers).
    document.template.bottom = await ReportTheme.buildFooter(pageSize);

    final normalFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    final boldFont =
        PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold);
    const double margin = ReportTheme.margin;

    final ebm = await ProxyService.getStrategy(Strategy.capella)
        .ebm(branchId: ProxyService.box.getBranchId()!);

    final DateFormat periodFmt = DateFormat('MMMM dd, yyyy');
    double yPosition = ReportTheme.drawHeader(
      page,
      pageSize,
      reportTitle: 'PLU Report',
      business: business,
      ebm: ebm,
      periodText:
          'Report Period: ${periodFmt.format(startDate)} - ${periodFmt.format(endDate)}',
    );
    yPosition = ReportTheme.drawSummaryCards(page, pageSize, yPosition, [
      ReportKpiCard(
        value: reportData.length.toString(),
        label: 'PLU Items',
        color: ReportTheme.primaryBlue,
      ),
      ReportKpiCard(
        value: totalSoldQty.toStringAsFixed(2),
        label: 'Units Sold',
        color: ReportTheme.accentPurple,
      ),
      ReportKpiCard(
        value: totalRemaining.toStringAsFixed(2),
        label: 'Units In Stock',
        color: ReportTheme.accentGreen,
      ),
    ]);

    // Draw table
    await PdfHelper.drawTable(
      document: document,
      page: page,
      data: reportData,
      startY: yPosition,
      pageWidth: pageSize.width,
      margin: margin,
      normalFont: normalFont,
      boldFont: boldFont,
    );

    try {
      // Save the document
      final List<int> bytes = await document.save();
      document.dispose();

      // Save to file and open
      final output = await getTemporaryDirectory();
      final fileName =
          'plu_report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
      final file = File('${output.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);

      // Open the file with the device's default PDF viewer
      await OpenFilex.open(file.path);
    } catch (e) {
      debugPrint('Error generating PDF: $e');
      rethrow;
    }
  }
}
