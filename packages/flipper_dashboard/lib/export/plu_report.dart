import 'dart:io';
import 'dart:typed_data';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
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
    final textElement = PdfTextElement(
      text: text,
      font: font,
      brush: brush,
    );
    textElement.draw(
      page: page,
      bounds: ui.Rect.fromLTWH(x, y, width, 0),
      format: PdfLayoutFormat(
        layoutType: PdfLayoutType.paginate,
      ),
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
    const double rowHeight = 20;
    const double headerHeight = 25;
    const double cellPadding = 5;

    final headers = [
      'No',
      'Item Name',
      'Item Code',
      'Unit Price',
      'Tax Rate',
      'Sold Qty',
      'Orders',
      'Remain Qty',
    ];

    final columnWidths = [
      0.5, // No
      2.5, // Item Name
      1.2, // Item Code
      1.2, // Unit Price
      0.8, // Tax Rate
      0.8, // Sold Qty
      0.8, // Orders
      1.0, // Remain Qty
    ];

    // Calculate total width for scaling
    final totalWidth = columnWidths.fold(0.0, (sum, width) => sum + width);
    final availableWidth = pageWidth - (2 * margin);

    // Draw table header
    double x = margin;
    double y = startY;

    // Draw header background
    page.graphics.drawRectangle(
      brush: PdfBrushes.lightGray,
      bounds: ui.Rect.fromLTWH(x, y, availableWidth, headerHeight),
    );

    // Draw header text
    for (var i = 0; i < headers.length; i++) {
      final colWidth = (columnWidths[i] / totalWidth) * availableWidth;
      drawText(
        page: page,
        text: headers[i],
        font: boldFont,
        x: x + cellPadding,
        y: y + (headerHeight - 12) / 2,
        width: colWidth - (2 * cellPadding),
        align: i == 0 ? PdfTextAlignment.left : PdfTextAlignment.right,
      );
      x += colWidth;
    }

    y += headerHeight;

    // Draw table rows
    for (final row in data) {
      x = margin;

      // Skip if row doesn't have required data
      if (row['Item Name'] == null) continue;

      // Alternate row background
      if (data.indexOf(row) % 2 == 0) {
        page.graphics.drawRectangle(
          brush: PdfBrushes.whiteSmoke,
          bounds: ui.Rect.fromLTWH(x, y, availableWidth, rowHeight),
        );
      }

      // Draw row border
      page.graphics.drawRectangle(
        pen: PdfPen(PdfColor(200, 200, 200)),
        bounds: ui.Rect.fromLTWH(x, y, availableWidth, rowHeight),
      );

      // Get order count for this item
      final orderCount = row['orderCount']?.toString() ?? '0';

      // Draw cell values
      final values = [
        row['No'].toString(),
        row['Item Name']?.toString() ?? '',
        row['Item Code']?.toString() ?? '',
        (row['Unit Price'] is num
            ? (row['Unit Price'] as num).toStringAsFixed(2)
            : row['Unit Price']?.toString() ?? '0.00'),
        row['Tax Rate']?.toString() ?? '0.00%',
        row['Sold Quantity']?.toString() ?? '0',
        orderCount, // Add order count column
        row['Remain Quantity']?.toString() ?? '0',
      ];

      for (var i = 0; i < values.length; i++) {
        final colWidth = (columnWidths[i] / totalWidth) * availableWidth;
        drawText(
          page: page,
          text: values[i],
          font: normalFont,
          x: x + cellPadding,
          y: y + (rowHeight - 12) / 2,
          width: colWidth - (2 * cellPadding),
          align: i == 0 ? PdfTextAlignment.left : PdfTextAlignment.right,
        );
        x += colWidth;
      }

      y += rowHeight;

      // Check for page break
      if (y > page.getClientSize().height - 50) {
        page = document.pages.add();
        y = margin;
      }
    }

    return y;
  }
}

class PLUReport {
  Future<void> generatePLUReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);

    // Fetch transactions with their items
    final transactionsWithItems =
        await ProxyService.strategy.transactionsAndItems(
      startDate: startDate,
      endDate: endDate,
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

    for (final entry in groupedItems.entries) {
      final items = entry.value;
      if (items.isEmpty) continue;

      // Use the first item's details (all items in the group share the same variant)
      final firstItem = items.first;

      // Calculate totals
      final soldQty = items.fold<double>(0, (sum, item) => sum + item.qty);
      final totalTax =
          items.fold<double>(0, (sum, item) => sum + (item.taxAmt ?? 0));
      final totalTaxable =
          items.fold<double>(0, (sum, item) => sum + (item.taxblAmt ?? 0));

      // Calculate tax rate (handle division by zero)
      double taxRate = 0.0;
      if (totalTaxable > 0) {
        taxRate = (totalTax / totalTaxable) * 100;
      }

      reportData.add({
        'No': i++,
        'Item Name': firstItem.name,
        'Item Code':
            firstItem.itemCd ?? firstItem.variantId?.substring(0, 8) ?? '',
        'Unit Price': firstItem.price,
        'Tax Rate': '${taxRate.toStringAsFixed(2)}%',
        'Sold Quantity': soldQty.toStringAsFixed(2),
        'Remain Quantity':
            firstItem.remainingStock?.toStringAsFixed(2) ?? '0.00',
      });
    }

    // Create a new PDF document
    final document = PdfDocument();
    var page = document.pages.add();
    final pageSize = page.getClientSize();

    // Set font
    final headerFont =
        PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold);
    final titleFont =
        PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);
    final normalFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
    final boldFont =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);

    // Draw header
    double yPosition = 40; // Start below top margin
    final double margin = 40;

    // Report title
    PdfHelper.drawText(
      page: page,
      text: 'PLU REPORT',
      font: headerFont,
      x: 0,
      y: yPosition,
      width: pageSize.width,
      align: PdfTextAlignment.center,
    );
    yPosition += 30;

    // Business info
    PdfHelper.drawText(
      page: page,
      text: business?.name ?? 'N/A',
      font: titleFont,
      x: margin,
      y: yPosition,
      width: pageSize.width - (2 * margin),
      align: PdfTextAlignment.left,
    );
    yPosition += 20;

    PdfHelper.drawText(
      page: page,
      text: 'TIN: ${business?.tinNumber ?? 'N/A'}',
      font: normalFont,
      x: margin,
      y: yPosition,
      width: pageSize.width - (2 * margin),
      align: PdfTextAlignment.left,
    );
    yPosition += 15;

    PdfHelper.drawText(
      page: page,
      text:
          'Date: ${DateFormat('yyyy-MM-dd').format(startDate)} - ${DateFormat('yyyy-MM-dd').format(endDate)}',
      font: normalFont,
      x: margin,
      y: yPosition,
      width: pageSize.width - (2 * margin),
      align: PdfTextAlignment.left,
    );
    yPosition += 30;

    // Draw table
    yPosition = await PdfHelper.drawTable(
      document: document,
      page: page,
      data: reportData,
      startY: yPosition,
      pageWidth: pageSize.width,
      margin: margin,
      normalFont: normalFont,
      boldFont: boldFont,
    );

    // Ensure we have enough space for footer
    if (yPosition > page.getClientSize().height - 150) {
      page = document.pages.add();
      yPosition = 40;
    }

    // Add footer with logo and generation info
    yPosition = page.getClientSize().height -
        120; // Position near bottom with space for logo

    // Draw generation info
    PdfHelper.drawText(
      page: page,
      text:
          'Generated on: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}',
      font: PdfStandardFont(PdfFontFamily.helvetica, 8),
      x: margin,
      y: yPosition,
      width: pageSize.width - (2 * margin),
      align: PdfTextAlignment.center,
    );
    yPosition += 15;

    // Draw Flipper logo and footer text
    try {
      final ByteData imageData =
          await rootBundle.load('packages/receipt/assets/flipper_logo.png');
      final PdfBitmap logoImage = PdfBitmap(imageData.buffer.asUint8List());
      const double logoWidth = 25;
      const double logoHeight = 25;
      final double xLogoPosition = (pageSize.width - logoWidth) / 2;

      // Draw logo
      page.graphics.drawImage(
        logoImage,
        ui.Rect.fromLTWH(xLogoPosition, yPosition, logoWidth, logoHeight),
      );

      // Add powered by text below logo
      final PdfFont footerFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
      page.graphics.drawString(
        'Powered by flipper',
        footerFont,
        bounds:
            ui.Rect.fromLTWH(0, yPosition + logoHeight + 5, pageSize.width, 15),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
      );
    } catch (e) {
      // If logo loading fails, just add text fallback
      debugPrint('Failed to load logo: $e');
      PdfHelper.drawText(
        page: page,
        text: 'Powered by Flipper POS',
        font: PdfStandardFont(PdfFontFamily.helvetica, 9),
        x: 0,
        y: yPosition,
        width: pageSize.width,
        align: PdfTextAlignment.center,
      );
    }

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

  // PDF helper methods are now in the PdfHelper class
}
