import 'dart:io';
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

    // Draw enhanced content
    double contentHeight = _drawEnhancedHeader(
        page,
        pageSize,
        business,
        transactions,
        totalAmount,
        totalVatAmount,
        totalTransactions,
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
      double averageTransactionValue) {
    final PdfGraphics graphics = page.graphics;
    final double leftMargin = 20;
    final double rightMargin = 20;
    final double contentWidth = pageSize.width - leftMargin - rightMargin;
    double currentY = 30;

    // Title section with background
    final Rect titleRect = Rect.fromLTWH(0, currentY, pageSize.width, 60);
    graphics.drawRectangle(
        brush: PdfSolidBrush(primaryBlue), bounds: titleRect);

    final PdfFont titleFont =
        PdfStandardFont(PdfFontFamily.helvetica, 24, style: PdfFontStyle.bold);
    graphics.drawString(
      'Sales Report',
      titleFont,
      bounds: Rect.fromLTWH(leftMargin, currentY + 15, contentWidth, 30),
      brush: PdfBrushes.white,
    );
    currentY += 80;

    // Business information card
    final Rect businessRect =
        Rect.fromLTWH(leftMargin, currentY, contentWidth, 100);
    graphics.drawRectangle(
      brush: PdfSolidBrush(lightBlue),
      pen: PdfPen(borderGray, width: 1),
      bounds: businessRect,
    );

    currentY += 15;
    final PdfFont sectionFont =
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
    final PdfFont normalFont = PdfStandardFont(PdfFontFamily.helvetica, 11);

    graphics.drawString(
      business?.name ?? 'Business Name',
      sectionFont,
      bounds: Rect.fromLTWH(leftMargin + 15, currentY, contentWidth - 30, 20),
      brush: PdfSolidBrush(darkGray),
    );
    currentY += 25;

    // Business details in two columns
    final double columnWidth = (contentWidth - 30) / 2;
    graphics.drawString('TIN: ${business?.tinNumber ?? 'N/A'}', normalFont,
        bounds: Rect.fromLTWH(leftMargin + 15, currentY, columnWidth, 15),
        brush: PdfSolidBrush(darkGray));
    graphics.drawString('CIS: ${"CIS"}', normalFont,
        bounds: Rect.fromLTWH(
            leftMargin + 15 + columnWidth, currentY, columnWidth, 15),
        brush: PdfSolidBrush(darkGray));
    currentY += 20;

    graphics.drawString('MRC: ${"MRC"}', normalFont,
        bounds: Rect.fromLTWH(leftMargin + 15, currentY, columnWidth, 15),
        brush: PdfSolidBrush(darkGray));
    currentY += 40;

    // Report period section
    final Rect periodRect =
        Rect.fromLTWH(leftMargin, currentY, contentWidth, 80);
    graphics.drawRectangle(
      brush: PdfSolidBrush(lightGray),
      pen: PdfPen(borderGray, width: 1),
      bounds: periodRect,
    );

    currentY += 15;
    graphics.drawString(
      'Report Period',
      sectionFont,
      bounds: Rect.fromLTWH(leftMargin + 15, currentY, contentWidth - 30, 20),
      brush: PdfSolidBrush(darkGray),
    );
    currentY += 25;

    final DateFormat dtf = DateFormat('MMMM dd, yyyy');
    final start =
        transactions.isNotEmpty ? transactions.first.createdAt : DateTime.now();
    final end =
        transactions.isNotEmpty ? transactions.last.createdAt : DateTime.now();

    graphics.drawString('From: ${dtf.format(start!)}', normalFont,
        bounds: Rect.fromLTWH(leftMargin + 15, currentY, columnWidth, 15),
        brush: PdfSolidBrush(darkGray));
    graphics.drawString('To: ${dtf.format(end!)}', normalFont,
        bounds: Rect.fromLTWH(
            leftMargin + 15 + columnWidth, currentY, columnWidth, 15),
        brush: PdfSolidBrush(darkGray));
    currentY += 40;

    // Summary metrics in cards
    currentY = _drawSummaryCards(
        graphics,
        leftMargin,
        currentY,
        contentWidth,
        totalAmount,
        totalVatAmount,
        totalTransactions,
        averageTransactionValue);

    return currentY + 20; // Return the Y position for content
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
    final double cardWidth = (contentWidth - 30) / 2;
    final double cardHeight = 60;
    final PdfFont valueFont =
        PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);
    final PdfFont labelFont = PdfStandardFont(PdfFontFamily.helvetica, 10);

    // Total Revenue Card
    Rect cardRect = Rect.fromLTWH(leftMargin, currentY, cardWidth, cardHeight);
    graphics.drawRectangle(
      brush: PdfSolidBrush(accentGreen),
      bounds: cardRect,
    );

    graphics.drawString(
      totalAmount.toCurrencyFormatted(),
      valueFont,
      bounds: Rect.fromLTWH(leftMargin + 15, currentY + 10, cardWidth - 30, 25),
      brush: PdfBrushes.white,
    );
    graphics.drawString(
      'Total Revenue',
      labelFont,
      bounds: Rect.fromLTWH(leftMargin + 15, currentY + 35, cardWidth - 30, 15),
      brush: PdfBrushes.white,
    );

    // Total VAT Card
    cardRect = Rect.fromLTWH(
        leftMargin + cardWidth + 15, currentY, cardWidth, cardHeight);
    graphics.drawRectangle(
      brush: PdfSolidBrush(primaryBlue),
      bounds: cardRect,
    );

    graphics.drawString(
      totalVatAmount.toCurrencyFormatted(),
      valueFont,
      bounds: Rect.fromLTWH(
          leftMargin + cardWidth + 30, currentY + 10, cardWidth - 30, 25),
      brush: PdfBrushes.white,
    );
    graphics.drawString(
      'Total VAT',
      labelFont,
      bounds: Rect.fromLTWH(
          leftMargin + cardWidth + 30, currentY + 35, cardWidth - 30, 15),
      brush: PdfBrushes.white,
    );

    currentY += cardHeight + 15;

    // Transaction Count and Average Value Cards
    cardRect = Rect.fromLTWH(leftMargin, currentY, cardWidth, cardHeight);
    graphics.drawRectangle(
      brush: PdfSolidBrush(lightBlue),
      pen: PdfPen(primaryBlue, width: 2),
      bounds: cardRect,
    );

    graphics.drawString(
      totalTransactions.toString(),
      valueFont,
      bounds: Rect.fromLTWH(leftMargin + 15, currentY + 10, cardWidth - 30, 25),
      brush: PdfSolidBrush(primaryBlue),
    );
    graphics.drawString(
      'Total Transactions',
      labelFont,
      bounds: Rect.fromLTWH(leftMargin + 15, currentY + 35, cardWidth - 30, 15),
      brush: PdfSolidBrush(darkGray),
    );

    // Average Transaction Value Card
    cardRect = Rect.fromLTWH(
        leftMargin + cardWidth + 15, currentY, cardWidth, cardHeight);
    graphics.drawRectangle(
      brush: PdfSolidBrush(lightGray),
      pen: PdfPen(borderGray, width: 1),
      bounds: cardRect,
    );

    graphics.drawString(
      averageTransactionValue.toCurrencyFormatted(),
      valueFont,
      bounds: Rect.fromLTWH(
          leftMargin + cardWidth + 30, currentY + 10, cardWidth - 30, 25),
      brush: PdfSolidBrush(darkGray),
    );
    graphics.drawString(
      'Average Transaction',
      labelFont,
      bounds: Rect.fromLTWH(
          leftMargin + cardWidth + 30, currentY + 35, cardWidth - 30, 15),
      brush: PdfSolidBrush(darkGray),
    );

    return currentY + cardHeight;
  }

  Future<void> _drawEnhancedContentAsync(PdfPage page, Size pageSize,
      List<TransactionWithItems> transactionsWithItems, double startY) async {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 9);

    // Optimized column widths for better readability
    grid.columns[0].width = 25; // #
    grid.columns[1].width = 45; // Buyer TIN
    grid.columns[2].width = 50; // Buyer Name
    grid.columns[3].width = 50; // Receipt Number
    grid.columns[4].width = 40; // Invoice Date
    grid.columns[5].width = 110; // Items
    grid.columns[6].width = 40; // Total Amount
    grid.columns[7].width = 40; // VAT
    grid.columns[8].width = 20; // Receipt Type

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
