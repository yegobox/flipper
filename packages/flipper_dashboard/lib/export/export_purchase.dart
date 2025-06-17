import 'dart:io';
import 'package:flipper_models/view_models/purchase_report_item.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;

class ExportPurchase {
  Future<void> export(List<PurchaseReportItem> reportItems) async {
    final business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);

    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    // Extract variants for header date calculation if needed, or pass reportItems directly
    final variantsForHeader = reportItems.map((item) => item.variant).toList();
    _drawHeader(page, pageSize, variantsForHeader, business);
    _drawTable(page, pageSize, reportItems); // Pass reportItems to _drawTable

    final List<int> bytes = await document.save();
    document.dispose();

    await _saveAndLaunchFile(bytes, 'PurchaseReport.pdf');
  }

    void _drawHeader(
      PdfPage page, Size pageSize, List<Variant> variants, Business? business) {
    final PdfGraphics graphics = page.graphics;
    final PdfFont titleFont =
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);
    final PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 12);

    graphics.drawString('Purchases Report', titleFont,
        bounds: Rect.fromLTWH(0, 0, pageSize.width, 30),
        format: PdfStringFormat(alignment: PdfTextAlignment.center));

    final businessName = business?.name ?? 'NYARUTARAMA SPORTS TRUST CLUB Ltd';
    final tin = business?.tinNumber ?? '933000005';

    graphics.drawString(businessName, headerFont,
        bounds: Rect.fromLTWH(0, 40, pageSize.width, 20));
    graphics.drawString('TIN: $tin', headerFont,
        bounds: Rect.fromLTWH(0, 60, pageSize.width, 20));

    if (variants.isNotEmpty) {
      final dates = variants
          .map((v) => v.lastTouched)
          .where((d) => d != null)
          .cast<DateTime>()
          .toList();

      if (dates.isNotEmpty) {
        dates.sort();
        final startDate = DateFormat('yyyy-MM-dd').format(dates.first);
        final endDate = DateFormat('yyyy-MM-dd').format(dates.last);
        graphics.drawString('Date: $startDate - $endDate', headerFont,
            bounds: Rect.fromLTWH(0, 80, pageSize.width, 20));
      }
    }
  }

    void _drawTable(PdfPage page, Size pageSize, List<PurchaseReportItem> reportItems) {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 7); // Increased column count for supplier info

    final PdfGridRow header = grid.headers.add(1)[0];
    header.cells[0].value = '#';
    header.cells[1].value = 'Item Name';
    header.cells[2].value = 'Quantity';
    header.cells[3].value = 'Supply Price';
    header.cells[4].value = 'Retail Price';
    header.cells[5].value = 'Supplier Name';
    header.cells[6].value = 'Supplier TIN';

    header.style = PdfGridCellStyle(
      backgroundBrush: PdfSolidBrush(PdfColor(0, 0, 255)), // Blue color
      textBrush: PdfBrushes.white,
      font: PdfStandardFont(PdfFontFamily.helvetica, 10,
          style: PdfFontStyle.bold),
    );

    for (int i = 0; i < reportItems.length; i++) {
      final item = reportItems[i];
      final variant = item.variant;
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = (i + 1).toString();
      row.cells[1].value = variant.itemNm ?? '';
      row.cells[2].value = variant.qty?.toStringAsFixed(0) ?? '';
      row.cells[3].value = variant.supplyPrice?.toStringAsFixed(2) ?? '';
      row.cells[4].value = variant.retailPrice?.toStringAsFixed(2) ?? '';
      row.cells[5].value = item.supplierName ?? '';
      row.cells[6].value = item.supplierTin ?? '';
    }

    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 120, 0, 0), // Adjust Y position if header height changed
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
