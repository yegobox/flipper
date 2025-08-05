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
  Future<void> generateSaleReport(
      {required DateTime startDate, required DateTime endDate}) async {
    final business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);
    final transactionsWithItems =
        await ProxyService.strategy.transactionsAndItems(
      startDate: startDate,
      endDate: endDate,
      // Explicitly set other parameters to their defaults or desired values if needed
      status: COMPLETE,
      // fetchRemote: false, // Default from TransactionMixin
    );

    // For clarity, extract transactions if needed by other parts, or use transactionsWithItems directly
    final transactions =
        transactionsWithItems.map((e) => e.transaction).toList();

    // Calculate totals
    double totalAmount = 0.0;
    double totalVatAmount = 0.0;
    for (final twi in transactionsWithItems) {
      totalAmount += twi.transaction.subTotal ?? 0.0;
      for (final item in twi.items) {
        totalVatAmount += item.taxAmt ?? 0.0;
      }
    }

    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    // Footer template for logo and page info
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
      final PdfFont footerFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
      footerTemplate.graphics.drawString(
        'Page 1 | Powered by flipper',
        footerFont,
        bounds: Rect.fromLTWH(0, 30, pageSize.width, 15),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
      );
    } catch (e) {
      print('Error loading logo for footer: $e');
    }
    document.template.bottom = footerTemplate;

    _drawHeader(
        page, pageSize, business, transactions, totalAmount, totalVatAmount);
    await _drawContentAsync(page, pageSize, transactionsWithItems);

    final List<int> bytes = await document.save();
    document.dispose();
    await _saveAndLaunchFile(bytes, 'Sale_report.pdf');
  }

  void _drawHeader(
      PdfPage page,
      Size pageSize,
      Business? business,
      List<ITransaction>
          transactions, // Keep as ITransaction for this specific header logic for now, as it only uses transaction fields
      double totalAmount,
      double totalVatAmount) {
    final PdfGraphics graphics = page.graphics;
    final PdfFont titleFont =
        PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold);
    final PdfFont detailsFont =
        PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold);
    final PdfFont normalFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
    final double left = 40;
    double top = 40;

    // Title
    graphics.drawString(
      'Sale Report',
      titleFont,
      bounds: Rect.fromLTWH(0, top, pageSize.width, 30),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle),
    );
    top += 40;

    // Business Details
    graphics.drawString('${business?.name ?? ''}', detailsFont,
        bounds: Rect.fromLTWH(left, top, 400, 18));
    top += 20;
    graphics.drawString('TIN: ${business?.tinNumber ?? ''}', normalFont,
        bounds: Rect.fromLTWH(left, top, 400, 15));
    top += 15;
    graphics.drawString('CIS: ${"CIS"}', normalFont,
        bounds: Rect.fromLTWH(left, top, 400, 15));
    top += 15;
    graphics.drawString('MRC: ${"MRC"}', normalFont,
        bounds: Rect.fromLTWH(left, top, 400, 15));
    top += 20;

    // Report Period
    graphics.drawString('Report Period', detailsFont,
        bounds: Rect.fromLTWH(left, top, 400, 15));
    top += 16;
    final DateFormat dtf = DateFormat('MMMM dd, yyyy, hh:mm a');
    final start =
        transactions.isNotEmpty ? transactions.first.createdAt : DateTime.now();
    final end =
        transactions.isNotEmpty ? transactions.last.createdAt : DateTime.now();
    graphics.drawString('Start: ${dtf.format(start!)}', normalFont,
        bounds: Rect.fromLTWH(left, top, 400, 15));
    top += 15;
    graphics.drawString('End: ${dtf.format(end!)}', normalFont,
        bounds: Rect.fromLTWH(left, top, 400, 15));
    top += 20;

    // Report Details
    graphics.drawString('Report Details', detailsFont,
        bounds: Rect.fromLTWH(left, top, 400, 15));
    top += 16;
    graphics.drawString('Generated: ${dtf.format(DateTime.now())}', normalFont,
        bounds: Rect.fromLTWH(left, top, 400, 15));
    top += 15;
    // graphics.drawString('Report Reference: ', normalFont,
    //     bounds: Rect.fromLTWH(left, top, 400, 15));
    top += 20;

    // Summary
    graphics.drawString(
        'Total Amount: ${totalAmount.toStringAsFixed(2)}', detailsFont,
        bounds: Rect.fromLTWH(left, top, 400, 15));
    top += 16;
    graphics.drawString(
        'Total VAT Amount: ${totalVatAmount.toStringAsFixed(2)}', detailsFont,
        bounds: Rect.fromLTWH(left, top, 400, 15));
  }

  Future<void> _drawContentAsync(PdfPage page, Size pageSize,
      List<TransactionWithItems> transactionsWithItems) async {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 9);
    grid.headers.add(1);
    final PdfGridRow header = grid.headers[0];
    header.cells[0].value = '#';
    header.cells[1].value = 'Buyer TIN';
    header.cells[2].value = 'Buyer Name';
    header.cells[3].value = 'Receipt Number';
    header.cells[4].value = 'Invoice Date';
    header.cells[5].value = 'Items';
    header.cells[6].value = 'Total Amount (RWF)';
    header.cells[7].value = 'VAT (RWF)';
    header.cells[8].value = 'Receipt Type';
    header.style.backgroundBrush = PdfSolidBrush(PdfColor(240, 240, 240));
    header.style.textBrush = PdfBrushes.black;
    header.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);

    final PdfPen grayPen = PdfPen(PdfColor(180, 180, 180), width: 0.5);
    for (int i = 0; i < header.cells.count; i++) {
      header.cells[i].style.borders = PdfBorders(
        left: grayPen,
        right: grayPen,
        top: grayPen,
        bottom: grayPen,
      );
    }

    int index = 1;
    for (final twi in transactionsWithItems) {
      // Iterate over TransactionWithItems
      final t = twi.transaction; // Get the ITransaction object
      final items = twi.items; // Get the list of TransactionItem objects

      final row = grid.rows.add();
      row.cells[0].value = index.toString();
      row.cells[1].value = t.customerTin ?? '[individual]';
      row.cells[2].value = t.customerName ?? '';
      row.cells[3].value =
          t.receiptNumber?.toString() ?? ''; // Ensure it's a string
      row.cells[4].value = t.createdAt != null
          ? DateFormat('yyyy-MM-dd').format(t.createdAt!)
          : '';
      row.cells[5].value = items.isNotEmpty
          ? items
              .map((item) =>
                  '• ${item.name} (${item.itemCd ?? ''} [${item.taxTyCd ?? ''}])\n  > ${item.qty} x RWF ${item.price.toStringAsFixed(2)}\n  >Total: ${item.totAmt?.toStringAsFixed(2) ?? ''}\n  >VAT: ${item.taxAmt?.toStringAsFixed(2) ?? ''}')
              .join('\n')
          : '';

      row.cells[6].value = t.subTotal?.toStringAsFixed(2) ?? '';
      row.cells[7].value = t.taxAmount?.toStringAsFixed(2) ?? '';
      row.cells[8].value = t.receiptType ?? '';
      for (int i = 0; i < row.cells.count; i++) {
        row.cells[i].style.borders = PdfBorders(
          left: grayPen,
          right: grayPen,
          top: grayPen,
          bottom: grayPen,
        );
      }
      index++;
    }

    for (int i = 0; i < grid.rows.count; i++) {
      if (i % 2 == 0) {
        grid.rows[i].style.backgroundBrush =
            PdfSolidBrush(PdfColor(250, 250, 250));
      }
    }

    // Increase this value to add more space between header and table
    double estimatedHeaderHeight = 300;
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
