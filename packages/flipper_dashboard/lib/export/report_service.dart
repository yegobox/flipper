import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;

class ReportService {
  Future<void> generateReport(
      {required String reportType, DateTime? endDate}) async {
    if (reportType == 'Z' && endDate == null) {
      throw ArgumentError('endDate is required for Z-Reports');
    }

    DateTime startDate;
    if (reportType == 'Z') {
      startDate = DateTime(endDate!.year, endDate.month, endDate.day);
      await ProxyService.box.writeString(
          key: 'lastZReportDate', value: endDate.toIso8601String());
    } else {
      final lastZReportDateString = ProxyService.box.lastZReportDate();
      startDate = lastZReportDateString != null
          ? DateTime.parse(lastZReportDateString)
          : DateTime.now().toLocal().subtract(const Duration(days: 1));
      endDate = DateTime.now().toLocal();
    }

    final business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);

    final transactionsWithItems =
        await ProxyService.strategy.transactionsAndItems(
      startDate: startDate,
      endDate: endDate,
      skipOriginalTransactionCheck: true,
    );
    final ebm = await ProxyService.strategy.ebm(
      branchId: ProxyService.box.getBranchId()!,
    );
    // Data processing - exclude refunded transactions
    final salesTransactions = transactionsWithItems
        .where((t) => t.transaction.receiptType == 'NS')
        .toList();
    final refundTransactions = transactionsWithItems
        .where((t) => t.transaction.receiptType == 'NR')
        .toList();

    final totalSales = salesTransactions.fold(
        0.0, (sum, t) => sum + (t.transaction.subTotal ?? 0.0));
    final totalRefunds = refundTransactions.fold(
        0.0, (sum, t) => sum + (t.transaction.subTotal ?? 0.0));
    final numSalesReceipts = salesTransactions.length;
    final numRefundReceipts = refundTransactions.length;
    final netSalesReceipts = numSalesReceipts - numRefundReceipts;

    // Dynamically calculate payment method breakdowns
    final Map<String, double> salesByPaymentMethod = {};
    for (var t in salesTransactions) {
      final paymentType = t.transaction.paymentType?.toLowerCase() ?? 'unknown';
      salesByPaymentMethod[paymentType] =
          (salesByPaymentMethod[paymentType] ?? 0) +
              (t.transaction.subTotal ?? 0.0);
    }

    final Map<String, double> refundsByPaymentMethod = {};
    for (var t in refundTransactions) {
      final paymentType = t.transaction.paymentType?.toLowerCase() ?? 'unknown';
      refundsByPaymentMethod[paymentType] =
          (refundsByPaymentMethod[paymentType] ?? 0) +
              (t.transaction.subTotal ?? 0.0);
    }

    // Calculate tax amounts (assuming 18% VAT)
    final taxRateSales = salesTransactions.fold(
        0.0, (sum, t) => sum + ((t.transaction.subTotal ?? 0.0) * 0.18));
    final taxRateRefunds = refundTransactions.fold(
        0.0, (sum, t) => sum + ((t.transaction.subTotal ?? 0.0) * 0.18));

    // Calculate item counts
    int totalItemsSold = 0;
    if (netSalesReceipts > 0) {
      for (final transaction in salesTransactions) {
        totalItemsSold += transaction.items.length;
      }
    }
    final totalDiscount = (netSalesReceipts > 0)
        ? salesTransactions.fold(
            0.0, (sum, t) => sum + (t.transaction.discountAmount ?? 0.0))
        : 0.0;

    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    // Footer template for logo
    final PdfPageTemplateElement footerTemplate =
        PdfPageTemplateElement(Rect.fromLTWH(0, 0, pageSize.width, 50));
    try {
      final ByteData imageData =
          await rootBundle.load('packages/receipt/assets/flipper_logo.png');
      final PdfBitmap logoImage = PdfBitmap(imageData.buffer.asUint8List());
      const double logoWidth = 25;
      const double logoHeight = 25;
      final double xLogoPosition = (pageSize.width - logoWidth) / 2;
      footerTemplate.graphics.drawImage(
          logoImage, Rect.fromLTWH(xLogoPosition, 0, logoWidth, logoHeight));
    } catch (e) {
      print('Error loading logo for footer: $e');
    }
    document.template.bottom = footerTemplate;

    _drawHeader(
      page,
      pageSize,
      business,
      ebm: ebm,
      reportType: reportType,
      startDate: startDate,
      endDate: endDate,
    );
    _drawContent(
      page,
      pageSize,
      totalSales,
      totalRefunds,
      numSalesReceipts,
      numRefundReceipts,
      netSalesReceipts,
      salesByPaymentMethod,
      refundsByPaymentMethod,
      taxRateSales,
      taxRateRefunds,
      totalItemsSold,
      totalDiscount,
      transactions: transactionsWithItems.map((e) => e.transaction).toList(),
    );

    final List<int> bytes = await document.save();
    document.dispose();

    final String formattedDate =
        DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now());
    await _saveAndLaunchFile(bytes, '${reportType}Report_$formattedDate.pdf');
  }

  void _drawHeader(PdfPage page, Size pageSize, Business? business,
      {Ebm? ebm,
      required String reportType,
      required DateTime startDate,
      required DateTime endDate}) {
    final PdfGraphics graphics = page.graphics;
    final PdfFont businessDetailsFont =
        PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold);
    final PdfFont labelFont =
        PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold);
    final PdfFont titleFont =
        PdfStandardFont(PdfFontFamily.helvetica, 22, style: PdfFontStyle.bold);
    final PdfFont subtitleFont =
        PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);
    final PdfBrush blueBrush = PdfSolidBrush(PdfColor(173, 216, 230));
    final PdfBrush whiteBrush = PdfBrushes.white;
    final PdfBrush blackBrush = PdfBrushes.black;

    final businessName = business?.name ?? 'Demo';
    final tin = business?.tinNumber?.toString() ?? '933000005';
    final mrc = ebm?.mrc ?? '';

    // Draw blue rectangle for the header background
    const double headerHeight = 60;
    graphics.drawRectangle(
      brush: blueBrush,
      bounds: Rect.fromLTWH(0, 0, pageSize.width, headerHeight),
    );

    // Draw "Z Report" title centered in the blue header
    graphics.drawString('$reportType Report', titleFont,
        brush: whiteBrush,
        bounds: Rect.fromLTWH(0, 10, pageSize.width, 40),
        format: PdfStringFormat(alignment: PdfTextAlignment.center));

    // Draw business details below the blue header, left aligned
    double detailsY = headerHeight + 10;
    graphics.drawString('Trade Name: ', labelFont,
        brush: blackBrush, bounds: Rect.fromLTWH(25, detailsY, 100, 18));
    graphics.drawString(businessName, businessDetailsFont,
        brush: blackBrush,
        bounds: Rect.fromLTWH(120, detailsY, pageSize.width - 130, 18));
    detailsY += 18;
    graphics.drawString('TIN: ', labelFont,
        brush: blackBrush, bounds: Rect.fromLTWH(25, detailsY, 100, 18));
    graphics.drawString(tin.toString(), businessDetailsFont,
        brush: blackBrush,
        bounds: Rect.fromLTWH(120, detailsY, pageSize.width - 130, 18));
    detailsY += 18;
    graphics.drawString('MRC: ', labelFont,
        brush: blackBrush, bounds: Rect.fromLTWH(25, detailsY, 100, 18));
    graphics.drawString(mrc, businessDetailsFont,
        brush: blackBrush,
        bounds: Rect.fromLTWH(120, detailsY, pageSize.width - 130, 18));
    detailsY += 18;
    graphics.drawString('Date: ', labelFont,
        brush: blackBrush, bounds: Rect.fromLTWH(25, detailsY, 100, 18));
    if (reportType == 'Z') {
      graphics.drawString('Date: ${DateFormat('yyyy-MM-dd').format(endDate)}',
          businessDetailsFont,
          brush: blackBrush,
          bounds: Rect.fromLTWH(120, detailsY, pageSize.width - 130, 18));
    } else {
      graphics.drawString(
          'From: ${DateFormat('yyyy-MM-dd').format(startDate)} To: ${DateFormat('yyyy-MM-dd').format(endDate)}',
          businessDetailsFont,
          brush: blackBrush,
          bounds: Rect.fromLTWH(120, detailsY, pageSize.width - 130, 18));
    }
    detailsY += 25;

    // Draw "All Transactions" subtitle centered and with blue color
    graphics.drawString('All Transactions', subtitleFont,
        brush:
            PdfSolidBrush(PdfColor(173, 90, 48)), // brownish as in screenshot
        bounds: Rect.fromLTWH(0, detailsY, pageSize.width, 20),
        format: PdfStringFormat(alignment: PdfTextAlignment.center));
  }

  void _drawContent(
      PdfPage page,
      Size pageSize,
      double totalSales,
      double totalRefunds,
      int numSalesReceipts,
      int numRefundReceipts,
      int netSalesReceipts,
      Map<String, double> salesByPaymentMethod,
      Map<String, double> refundsByPaymentMethod,
      double taxRateSales,
      double taxRateRefunds,
      int totalItemsSold,
      double totalDiscount,
      {required List<ITransaction> transactions}) {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 2);

    // Header styling
    final PdfGridRow header = grid.headers.add(1)[0];
    header.cells[0].value = 'Description';
    header.cells[1].value = 'Amount (RWF)';
    header.style.backgroundBrush =
        PdfSolidBrush(PdfColor(173, 216, 230)); // Light Blue
    header.style.textBrush = PdfBrushes.black;
    header.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);

    // Helper function to add a title row
    void addTitleRow(String title) {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = title;
      row.cells[0].style.font = PdfStandardFont(PdfFontFamily.helvetica, 10,
          style: PdfFontStyle.bold);
      row.cells[1].value = ''; // No value for title row
      // row.isSpan = true; // Span across both columns
    }

    // Helper function to add regular data rows
    void addRow(String description, String value) {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = description;
      row.cells[1].value = value;
    }

    // Add all rows according to the expected format
    addRow('Total Sales Amount (NS)', totalSales.toCurrencyFormatted());
    addRow('Total Sales Amount by Main Groups', '0 RWF');
    addRow('Number of Sales Receipts (NS)',
        (netSalesReceipts > 0 ? netSalesReceipts : 0).toString());
    addRow('Total Refund Amount (NR)', totalRefunds.toCurrencyFormatted());
    addRow('Number of Refund Receipts (NR)', numRefundReceipts.toString());

    // Taxable Amounts section
    addTitleRow('Taxable Amounts');
    salesByPaymentMethod.forEach((method, amount) {
      addRow('  ${method.toUpperCase()} (NS)', amount.toCurrencyFormatted());
    });
    refundsByPaymentMethod.forEach((method, amount) {
      addRow('  ${method.toUpperCase()} (NR)', amount.toCurrencyFormatted());
    });

    addRow('Opening deposit', '0 RWF');
    addRow('Number of items sold', totalItemsSold.toString());

    // Tax Amounts section
    addTitleRow('Tax Amounts');
    salesByPaymentMethod.forEach((method, amount) {
      addRow('  ${method.toUpperCase()} (NS)',
          (amount * 0.18).toCurrencyFormatted());
    });
    refundsByPaymentMethod.forEach((method, amount) {
      addRow('  ${method.toUpperCase()} (NR)',
          (amount * 0.18).toCurrencyFormatted());
    });

    // Count different receipt types
    final receiptTypeCounts = transactions.fold<Map<String, int>>(
      {
        'CS': 0,
        'CR': 0,
        'TS': 0,
        'TR': 0,
        'PS': 0,
      },
      (counts, t) {
        final type = t.receiptType;
        if (type != null && counts.containsKey(type)) {
          counts[type] = counts[type]! + 1;
        }
        return counts;
      },
    );

    addRow(
      'Number of Receipt Copies (CS/CR)',
      'CS : ${receiptTypeCounts['CS'] ?? 0} | CR : ${receiptTypeCounts['CR'] ?? 0}',
    );
    addRow(
      'Number of Receipts in Training Mode (TS/TR)',
      'TS : ${receiptTypeCounts['TS'] ?? 0} | TR : ${receiptTypeCounts['TR'] ?? 0}',
    );
    addRow(
      'Number of Advance Receipts in Proforma Mode (PS)',
      (receiptTypeCounts['PS'] ?? 0).toString(),
    );

    // Payment split section
    addTitleRow(
        'Total Sales divided according to means of payment for sales (NS) and refund (NR) receipts');
    salesByPaymentMethod.forEach((method, amount) {
      addRow('  ${method.toUpperCase()} (NS)', amount.toCurrencyFormatted());
    });
    refundsByPaymentMethod.forEach((method, amount) {
      addRow('  ${method.toUpperCase()} (NR)', amount.toCurrencyFormatted());
    });

    addRow('All discounts', totalDiscount.toCurrencyFormatted());
    addRow('Number of incomplete sales', '0');
    addRow(
        'Other registrations that have reduced the day sales and their amount',
        'None');

    // Grid styling
    grid.columns[0].width = 300;
    grid.columns[1].width = 200;
    grid.style.cellPadding = PdfPaddings(left: 5, right: 5, top: 5, bottom: 5);
    grid.style.font = PdfStandardFont(PdfFontFamily.helvetica, 10);

    // Set gray border color for all grid cells
    final PdfPen grayPen = PdfPen(PdfColor(180, 180, 180), width: 0.5);
    // Header cells
    for (int i = 0; i < header.cells.count; i++) {
      final cell = header.cells[i];
      cell.style.borders = PdfBorders(
        left: grayPen,
        right: grayPen,
        top: grayPen,
        bottom: grayPen,
      );
    }
    // Data cells
    for (int i = 0; i < grid.rows.count; i++) {
      for (int j = 0; j < grid.rows[i].cells.count; j++) {
        final cell = grid.rows[i].cells[j];
        cell.style.borders = PdfBorders(
          left: grayPen,
          right: grayPen,
          top: grayPen,
          bottom: grayPen,
        );
      }
    }

    // Add alternating row colors for better readability
    for (int i = 0; i < grid.rows.count; i++) {
      if (i % 2 == 0) {
        grid.rows[i].style.backgroundBrush =
            PdfSolidBrush(PdfColor(245, 245, 245));
      }
    }

    // Increase vertical space between subtitle and table
    final double estimatedHeaderHeight =
        197; // header (60) + details (4*18+3*0) + subtitle (20) + padding (10+25+10)
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, estimatedHeaderHeight, pageSize.width,
          pageSize.height - estimatedHeaderHeight - 50),
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
