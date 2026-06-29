import 'dart:io';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flutter/services.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_dashboard/export/transaction_report_full_export_loader.dart';
import 'package:flipper_dashboard/export/utils/report_theme.dart';
import 'package:flipper_services/proxy.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;

class ReportService {
  Future<void> generateReport({
    required String reportType,
    DateTime? endDate,
    DateTime? startDate,
  }) async {
    if (reportType == 'Z' && endDate == null) {
      throw ArgumentError('endDate is required for Z-Reports');
    }

    if (reportType == 'Z' && endDate != null) {
      // AS Z cover just one day this is why we override start date here.
      startDate = DateTime(endDate.year, endDate.month, endDate.day);
      await ProxyService.box.writeString(
        key: 'lastZReportDate',
        value: endDate.toIso8601String(),
      );
    } else {
      final lastZReportDateString = ProxyService.box.lastZReportDate();
      startDate = lastZReportDateString != null
          ? DateTime.parse(lastZReportDateString).add(const Duration(days: 1))
          : DateTime.now().toLocal().subtract(const Duration(days: 1));
      endDate = DateTime.now().toLocal();
    }

    final business = await ProxyService.getStrategy(
      Strategy.capella,
    ).getBusiness(businessId: ProxyService.box.getBusinessId()!);

    final transactionsWithItems = await loadTransactionsWithItemsForReport(
      startDate: startDate,
      endDate: endDate,
      branchId: ProxyService.box.getBranchId()!,
      forceRealData: !(ProxyService.box.enableDebug() ?? false),
    );

    talker.info(startDate.toIso8601String(), endDate.toIso8601String());
    final ebm = await ProxyService.getStrategy(
      Strategy.capella,
    ).ebm(branchId: ProxyService.box.getBranchId()!);
    transactionsWithItems.map((t) => print(t.transaction.receiptType)).toList();
    // Data processing - exclude refunded transactions
    final salesTransactions = transactionsWithItems
        .where((t) => t.transaction.receiptType!.toUpperCase() == 'NS')
        .toList();
    final refundTransactions = transactionsWithItems
        .where((t) => t.transaction.receiptType!.toUpperCase() == 'NR')
        .toList();
    final tsTransactions = transactionsWithItems
        .where((t) => t.transaction.receiptType!.toUpperCase() == 'TS')
        .toList();
    final psTransactions = transactionsWithItems
        .where((t) => t.transaction.receiptType!.toUpperCase() == 'PS')
        .toList();
    final crTransactions = transactionsWithItems
        .where((t) => t.transaction.receiptType!.toUpperCase() == 'CR')
        .toList();
    final trTransactions = transactionsWithItems
        .where((t) => t.transaction.receiptType!.toUpperCase() == 'TR')
        .toList();

    final totalSales = salesTransactions.fold(
      0.0,
      (sum, t) => sum + (t.transaction.subTotal ?? 0.0),
    );
    final totalRefunds = refundTransactions.fold(
      0.0,
      (sum, t) => sum + (t.transaction.subTotal ?? 0.0),
    );
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
    final Map<String, double> tsByMethod = {};
    for (var t in tsTransactions) {
      final paymentType = t.transaction.paymentType?.toLowerCase() ?? 'unknown';
      tsByMethod[paymentType] =
          (tsByMethod[paymentType] ?? 0) + (t.transaction.subTotal ?? 0.0);
    }
    final Map<String, double> psByMethod = {};
    for (var t in psTransactions) {
      final paymentType = t.transaction.paymentType?.toLowerCase() ?? 'unknown';
      psByMethod[paymentType] =
          (psByMethod[paymentType] ?? 0) + (t.transaction.subTotal ?? 0.0);
    }
    // final Map<String, double> crByMethod = {};
    final Map<String, double> trByMethod = {};
    for (var t in trTransactions) {
      final paymentType = t.transaction.paymentType?.toLowerCase() ?? 'unknown';
      trByMethod[paymentType] =
          (trByMethod[paymentType] ?? 0) + (t.transaction.subTotal ?? 0.0);
    }
    // final Map<String, double> crByMethod = {};
    final Map<String, double> crByMethod = {};
    for (var t in crTransactions) {
      final paymentType = t.transaction.paymentType?.toLowerCase() ?? 'unknown';
      crByMethod[paymentType] =
          (crByMethod[paymentType] ?? 0) + (t.transaction.subTotal ?? 0.0);
    }

    // Calculate tax amounts (assuming 18% VAT)
    final taxRateSales = salesTransactions.fold(
      0.0,
      (sum, t) => sum + ((t.transaction.subTotal ?? 0.0) * 0.18),
    );
    final taxRateRefunds = refundTransactions.fold(
      0.0,
      (sum, t) => sum + ((t.transaction.subTotal ?? 0.0) * 0.18),
    );

    // Calculate item counts
    int totalItemsSold = 0;
    if (netSalesReceipts > 0) {
      for (final transaction in salesTransactions) {
        totalItemsSold += transaction.items.length;
      }
    }
    final totalDiscount = (netSalesReceipts > 0)
        ? salesTransactions.fold(
            0.0,
            (sum, t) => sum + (t.transaction.discountAmount ?? 0.0),
          )
        : 0.0;

    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    // Branded footer (logo, "Powered by Flipper", timestamp, page numbers).
    document.template.bottom = await ReportTheme.buildFooter(pageSize);

    final String periodText = reportType == 'Z'
        ? 'Date: ${DateFormat('MMMM dd, yyyy').format(endDate)}'
        : 'From ${DateFormat('MMMM dd, yyyy').format(startDate)} to ${DateFormat('MMMM dd, yyyy').format(endDate)}';

    double contentTop = ReportTheme.drawHeader(
      page,
      pageSize,
      reportTitle: '$reportType Report',
      business: business,
      ebm: ebm,
      periodText: periodText,
    );
    contentTop = ReportTheme.drawSummaryCards(page, pageSize, contentTop, [
      ReportKpiCard(
        value: ReportTheme.formatRwf(totalSales, trimZeros: true),
        label: 'Total Sales (NS)',
        color: ReportTheme.primaryBlue,
      ),
      ReportKpiCard(
        value: ReportTheme.formatRwf(totalRefunds, trimZeros: true),
        label: 'Refunds (NR)',
        color: ReportTheme.accentRed,
      ),
      ReportKpiCard(
        value: totalItemsSold.toString(),
        label: 'Items Sold',
        color: ReportTheme.accentPurple,
      ),
      ReportKpiCard(
        value: ReportTheme.formatRwf(taxRateSales, trimZeros: true),
        label: 'Tax (NS)',
        color: ReportTheme.accentGreen,
      ),
    ]);

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
      tsByMethod: tsByMethod,
      psByMethod: psByMethod,
      trByMethod: trByMethod,
      crByMethod: crByMethod,
      taxRateSales,
      taxRateRefunds,
      totalItemsSold,
      totalDiscount,
      startY: contentTop,
      transactions: transactionsWithItems.map((e) => e.transaction).toList(),
    );

    final List<int> bytes = await document.save();
    document.dispose();

    final String formattedDate = DateFormat(
      'yyyy-MM-dd_HH-mm',
    ).format(DateTime.now());
    await _saveAndLaunchFile(bytes, '${reportType}Report_$formattedDate.pdf');
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
    double totalDiscount, {
    required double startY,
    required List<ITransaction> transactions,
    required Map<String, double> tsByMethod,
    required Map<String, double> psByMethod,
    required Map<String, double> trByMethod,
    required Map<String, double> crByMethod,
  }) {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 2);

    // Header styling
    final PdfGridRow header = grid.headers.add(1)[0];
    header.cells[0].value = 'Description';
    header.cells[1].value = 'Amount (RWF)';
    ReportTheme.styleTableHeader(header);

    // Helper function to add a title row. Section rows keep their tinted band,
    // so we record their indices to skip the alternating-row shading below.
    final Set<int> sectionRowIndices = {};
    void addTitleRow(String title) {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = title;
      row.cells[1].value = '';
      ReportTheme.styleSectionRow(row);
      sectionRowIndices.add(grid.rows.count - 1);
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
    addRow('Number of Sales Receipts (NS)', numSalesReceipts.toString());
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
      addRow(
        '  ${method.toUpperCase()} (NS)',
        (amount * 0.18).toCurrencyFormatted(),
      );
    });
    refundsByPaymentMethod.forEach((method, amount) {
      addRow(
        '  ${method.toUpperCase()} (NR)',
        (amount * 0.18).toCurrencyFormatted(),
      );
    });

    // Count different receipt types
    final receiptTypeCounts = transactions.fold<Map<String, int>>(
      {'CS': 0, 'CR': 0, 'TS': 0, 'TR': 0, 'PS': 0},
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
      'Total Sales divided according to means of payment for sales (NS) and refund (NR) receipts',
    );
    salesByPaymentMethod.forEach((method, amount) {
      addRow('  ${method.toUpperCase()} (NS)', amount.toCurrencyFormatted());
    });
    refundsByPaymentMethod.forEach((method, amount) {
      addRow('  ${method.toUpperCase()} (NR)', amount.toCurrencyFormatted());
    });
    psByMethod.forEach((method, amount) {
      addRow('  ${method.toUpperCase()} (PS)', amount.toCurrencyFormatted());
    });
    tsByMethod.forEach((method, amount) {
      addRow('  ${method.toUpperCase()} (TS)', amount.toCurrencyFormatted());
    });
    trByMethod.forEach((method, amount) {
      addRow('  ${method.toUpperCase()} (TR)', amount.toCurrencyFormatted());
    });
    crByMethod.forEach((method, amount) {
      addRow('  ${method.toUpperCase()} (CR)', amount.toCurrencyFormatted());
    });

    addRow('All discounts', totalDiscount.toCurrencyFormatted());
    addRow('Number of incomplete sales', '0');
    addRow(
      'Other registrations that have reduced the day sales and their amount',
      'None',
    );

    // Grid styling
    final double contentWidth = pageSize.width - ReportTheme.margin * 2;
    grid.columns[0].width = contentWidth * 0.64;
    grid.columns[1].width = contentWidth * 0.36;
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

    // Add alternating row colors for better readability (skip section bands).
    for (int i = 0; i < grid.rows.count; i++) {
      if (sectionRowIndices.contains(i)) continue;
      if (i % 2 == 0) {
        grid.rows[i].style.backgroundBrush = PdfSolidBrush(
          PdfColor(245, 245, 245),
        );
      }
    }

    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
        ReportTheme.margin,
        startY,
        pageSize.width - ReportTheme.margin * 2,
        pageSize.height - startY - 60,
      ),
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
