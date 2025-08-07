import 'dart:io';
import 'dart:math';
import 'package:flipper_services/constants.dart';
import 'package:flutter/services.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:flipper_models/sync/models/transaction_with_items.dart';

class SaleReport {
  // QuickBooks-inspired color scheme
  static PdfColor primaryBlue = PdfColor(0, 100, 168);
  static PdfColor lightBlue = PdfColor(230, 242, 252);
  static PdfColor darkGray = PdfColor(64, 64, 64);
  static PdfColor lightGray = PdfColor(248, 248, 248);
  static PdfColor borderGray = PdfColor(220, 220, 220);
  static PdfColor accentGreen = PdfColor(76, 175, 80);

  Future<void> generateSaleReport(
      {required DateTime startDate, required DateTime endDate}) async {
    final business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);
    final transactionsWithItems =
        await ProxyService.strategy.transactionsAndItems(
      startDate: startDate,
      endDate: endDate,
      status: COMPLETE,
    );

    final transactions =
        transactionsWithItems.map((e) => e.transaction).toList();

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
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    // Enhanced footer with better styling
    final PdfPageTemplateElement footerTemplate =
        PdfPageTemplateElement(Rect.fromLTWH(0, 0, pageSize.width, 60));

    _createFooter(footerTemplate, pageSize);
    document.template.bottom = footerTemplate;
    final ebm = await ProxyService.strategy.ebm(
      branchId: ProxyService.box.getBranchId()!,
    );

    // Draw enhanced content
    double contentHeight = _drawEnhancedHeader(
        page,
        pageSize,
        business,
        transactions,
        totalAmount,
        totalVatAmount,
        totalTransactions,
        ebm: ebm,
        averageTransactionValue);

    await _drawEnhancedContentAsync(
        page, pageSize, transactionsWithItems, contentHeight);

    final List<int> bytes = await document.save();
    final String formattedDate =
        DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now());
    document.dispose();
    await _saveAndLaunchFile(bytes, 'Sale_report_$formattedDate.pdf');
  }

  void _createFooter(
      PdfPageTemplateElement footerTemplate, Size pageSize) async {
    try {
      // Draw a subtle line at the top of footer
      final PdfPen footerPen = PdfPen(borderGray, width: 1);
      footerTemplate.graphics
          .drawLine(footerPen, Offset(40, 10), Offset(pageSize.width - 40, 10));

      final ByteData imageData =
          await rootBundle.load('packages/receipt/assets/flipper_logo.png');
      final PdfBitmap logoImage = PdfBitmap(imageData.buffer.asUint8List());
      const double logoWidth = 30;
      const double logoHeight = 30;

      // Position logo on the left
      footerTemplate.graphics
          .drawImage(logoImage, Rect.fromLTWH(40, 20, logoWidth, logoHeight));

      final PdfFont footerFont = PdfStandardFont(PdfFontFamily.helvetica, 9);

      // Company info next to logo
      footerTemplate.graphics.drawString(
        'Powered by Flipper',
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(80, 25, 200, 15),
        brush: PdfSolidBrush(darkGray),
      );

      // Page number on the right
      footerTemplate.graphics.drawString(
        'Page 1',
        footerFont,
        bounds: Rect.fromLTWH(pageSize.width - 100, 35, 60, 15),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        brush: PdfSolidBrush(darkGray),
      );

      // Generation timestamp
      footerTemplate.graphics.drawString(
        'Generated: ${DateFormat('MMM dd, yyyy at HH:mm').format(DateTime.now())}',
        footerFont,
        bounds: Rect.fromLTWH(80, 40, 300, 15),
        brush: PdfSolidBrush(PdfColor(120, 120, 120)),
      );
    } catch (e) {
      print('Error creating footer: $e');
    }
  }

  double _drawEnhancedHeader(
      PdfPage page,
      Size pageSize,
      Business? business,
      List<ITransaction> transactions,
      double totalAmount,
      double totalVatAmount,
      int totalTransactions,
      double averageTransactionValue,
      {Ebm? ebm}) {
    final PdfGraphics graphics = page.graphics;
    final double leftMargin = 40; // Increased from 20 for better balance
    final double rightMargin = 40;
    final double contentWidth = pageSize.width - leftMargin - rightMargin;
    double currentY = 30;

    // Title section with improved layout
    final PdfFont titleFont =
        PdfStandardFont(PdfFontFamily.helvetica, 22, style: PdfFontStyle.bold);

    // Company name and report title side by side
    // Replace the existing business name drawing with:
    final String businessName = business?.name ?? 'Business Name';

    // Measure the text width
    final Size textSize = titleFont.measureString(businessName);
    final double textWidth = textSize.width;

// Use either the measured width or contentWidth, whichever is smaller
    final double availableWidth =
        min(textWidth + 20, contentWidth); // Add 20px padding

    graphics.drawString(
      businessName.substring(0, 20),
      titleFont,
      bounds: Rect.fromLTWH(leftMargin, currentY, availableWidth, 30),
      brush: PdfSolidBrush(darkGray),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.left,
        lineAlignment: PdfVerticalAlignment.middle,
        wordWrap: PdfWordWrapType.word, // Prevent word wrapping
        characterSpacing: 0.5, // Slightly increase spacing if needed
      ),
    );

    graphics.drawString(
      'Sales Report',
      titleFont,
      bounds: Rect.fromLTWH(
          leftMargin + contentWidth / 2, currentY, contentWidth / 2, 30),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
      brush: PdfSolidBrush(primaryBlue),
    );
    currentY += 35;

    // Business details in a cleaner format
    final PdfFont detailFont = PdfStandardFont(PdfFontFamily.helvetica, 10);

    graphics.drawString(
      'TIN: ${business?.tinNumber ?? 'N/A'} | MRC: ${ebm?.mrc ?? 'N/A'} | CIS: CIS',
      detailFont,
      bounds: Rect.fromLTWH(leftMargin, currentY, contentWidth, 15),
      brush: PdfSolidBrush(darkGray),
    );
    currentY += 20;

    // Report period with proper date ordering
    final DateFormat dtf = DateFormat('MMMM dd, yyyy');
    final start =
        transactions.isNotEmpty ? transactions.first.createdAt : DateTime.now();
    final end =
        transactions.isNotEmpty ? transactions.last.createdAt : DateTime.now();

    // Ensure dates are in correct order (from-to)
    final DateTime fromDate = start!.isBefore(end!) ? start : end;
    final DateTime toDate = start.isBefore(end) ? end : start;

    graphics.drawString(
      'Report Period: ${dtf.format(fromDate)} - ${dtf.format(toDate)}',
      detailFont,
      bounds: Rect.fromLTWH(leftMargin, currentY, contentWidth, 15),
      brush: PdfSolidBrush(darkGray),
    );
    currentY += 30;

    // Summary cards in a single row with equal width
    currentY = _drawSummaryCards(
        graphics,
        leftMargin,
        currentY,
        contentWidth,
        totalAmount,
        totalVatAmount,
        totalTransactions,
        averageTransactionValue);

    return currentY + 30; // More spacing before table
  }

  double _drawSummaryCards(
      PdfGraphics graphics,
      double leftMargin,
      double currentY,
      double contentWidth,
      double totalAmount,
      double totalVatAmount,
      int totalTransactions,
      double averageTransactionValue) {
    final double cardWidth = (contentWidth - 20) / 4; // 4 cards with spacing
    final double cardHeight = 70;
    final double cardSpacing = 5;

    final PdfFont valueFont =
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);
    final PdfFont labelFont = PdfStandardFont(PdfFontFamily.helvetica, 10);

    // Card 1: Total Revenue
    _drawSummaryCard(
      graphics,
      Rect.fromLTWH(leftMargin, currentY, cardWidth, cardHeight),
      totalAmount.toCurrencyFormatted(),
      'Total Revenue',
      valueFont,
      labelFont,
      primaryBlue,
    );

    // Card 2: Total VAT
    _drawSummaryCard(
      graphics,
      Rect.fromLTWH(leftMargin + cardWidth + cardSpacing, currentY, cardWidth,
          cardHeight),
      totalVatAmount.toCurrencyFormatted(),
      'Total VAT',
      valueFont,
      labelFont,
      accentGreen,
    );

    // Card 3: Total Transactions
    _drawSummaryCard(
      graphics,
      Rect.fromLTWH(leftMargin + (cardWidth + cardSpacing) * 2, currentY,
          cardWidth, cardHeight),
      totalTransactions.toString(),
      'Total Transactions',
      valueFont,
      labelFont,
      PdfColor(150, 100, 200), // Purple accent
    );

    // Card 4: Average Transaction
    _drawSummaryCard(
      graphics,
      Rect.fromLTWH(leftMargin + (cardWidth + cardSpacing) * 3, currentY,
          cardWidth, cardHeight),
      averageTransactionValue.toCurrencyFormatted(),
      'Avg. Transaction',
      valueFont,
      labelFont,
      PdfColor(255, 150, 50), // Orange accent
    );

    return currentY + cardHeight + 20;
  }

  void _drawSummaryCard(
      PdfGraphics graphics,
      Rect bounds,
      String value,
      String label,
      PdfFont valueFont,
      PdfFont labelFont,
      PdfColor backgroundColor) {
    // Card background with subtle shadow
    graphics.drawRectangle(
        bounds: bounds,
        brush: PdfSolidBrush(backgroundColor),
        pen: PdfPen(
          PdfColor(200, 200, 200), // Light gray border
        ));

    // Value
    graphics.drawString(
      value,
      valueFont,
      bounds: Rect.fromLTWH(
          bounds.left + 10, bounds.top + 15, bounds.width - 20, 25),
      brush: PdfBrushes.white,
    );

    // Label
    graphics.drawString(
      label,
      labelFont,
      bounds: Rect.fromLTWH(
          bounds.left + 10, bounds.top + 40, bounds.width - 20, 15),
      brush: PdfBrushes.white,
    );
  }

  Future<void> _drawEnhancedContentAsync(PdfPage page, Size pageSize,
      List<TransactionWithItems> transactionsWithItems, double startY) async {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 9);

    // Optimized column widths for better readability
    final double pageWidth = pageSize.width - 80; // 40px margins on each side
    grid.columns[0].width = pageWidth * 0.03; // # (3%)
    grid.columns[1].width = pageWidth * 0.10; // Buyer TIN (10%)
    grid.columns[2].width = pageWidth * 0.12; // Buyer Name (12%)
    grid.columns[3].width = pageWidth * 0.08; // Receipt Number (8%)
    grid.columns[4].width = pageWidth * 0.08; // Date (8%)
    grid.columns[5].width = pageWidth * 0.35; // Items Details (35%)
    grid.columns[6].width = pageWidth * 0.12; // Amount (12%)
    grid.columns[7].width = pageWidth * 0.10; // VAT (10%)
    grid.columns[8].width = pageWidth * 0.02; // Type (2%)

    // Enhanced header styling
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

    // QuickBooks-style header
    header.style.backgroundBrush = PdfSolidBrush(primaryBlue);
    header.style.textBrush = PdfBrushes.white;
    header.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);

    final PdfPen headerPen = PdfPen(PdfColor(255, 255, 255), width: 1);
    for (int i = 0; i < header.cells.count; i++) {
      header.cells[i].style.borders = PdfBorders(
          left: headerPen, right: headerPen, top: headerPen, bottom: headerPen);
      header.cells[i].style.stringFormat = PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle,
      );
    }

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
        final itemsText = items.map((item) {
          return '${item.name}\n  Qty: ${item.qty} × ${item.price.toStringAsFixed(0)}\n  Total: ${item.totAmt?.toStringAsFixed(0) ?? '0'}';
        }).join('\n\n');
        row.cells[5].value = itemsText;
      } else {
        row.cells[5].value = '-';
      }

      row.cells[6].value = t.subTotal?.toCurrencyFormatted() ?? '0';

      double taxAmount = t.taxAmount?.toDouble() ?? 0.0;
      if (taxAmount == 0.0 && items.isNotEmpty) {
        taxAmount =
            items.fold<double>(0.0, (sum, item) => sum + (item.taxAmt ?? 0.0));
      }
      row.cells[7].value = taxAmount.toCurrencyFormatted();
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
