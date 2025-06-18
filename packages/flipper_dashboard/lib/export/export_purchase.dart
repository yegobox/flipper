import 'dart:io';
import 'package:collection/collection.dart';
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

    final groupedByPurchase =
        groupBy(reportItems, (item) => item.purchase?.id); // Group by String? id

    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    final allPurchases = reportItems
        .map((item) => item.purchase)
        .where((p) => p != null)
        .cast<Purchase>()
        .toList();
    _drawHeader(page, pageSize, allPurchases, business);
    _drawTable(page, pageSize, groupedByPurchase);

    final List<int> bytes = await document.save();
    document.dispose();

    await _saveAndLaunchFile(bytes, 'PurchaseReport.pdf');
  }

  void _drawHeader(
      PdfPage page, Size pageSize, List<Purchase> purchases, Business? business) {
    final PdfGraphics graphics = page.graphics;
    final PdfFont titleFont =
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);
    final PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 12);

    graphics.drawString('Purchases Report', titleFont,
        bounds: Rect.fromLTWH(0, 0, pageSize.width, 30),
        format: PdfStringFormat(alignment: PdfTextAlignment.center));

    final businessName = business?.name ?? 'Demo';
    final tin = business?.tinNumber ?? '933000005';

    graphics.drawString(businessName, headerFont,
        bounds: Rect.fromLTWH(0, 40, pageSize.width, 20));
    graphics.drawString('TIN: $tin', headerFont,
        bounds: Rect.fromLTWH(0, 60, pageSize.width, 20));

    if (purchases.isNotEmpty) {
      final dates = purchases
          .map((p) => DateTime.tryParse(p.salesDt))
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

  void _drawTable(PdfPage page, Size pageSize,
      Map<String?, List<PurchaseReportItem>> groupedItems) {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 7);

    final PdfGridRow header = grid.headers.add(1)[0];
    header.cells[0].value = 'Supplier TIN';
    header.cells[1].value = 'Supplier Name';
    header.cells[2].value = 'Invoice Number';
    header.cells[3].value = 'Request Date';
    header.cells[4].value = 'Total Amount';
    header.cells[5].value = 'Items';
    header.cells[6].value = 'Total Items';

    header.style = PdfGridCellStyle(
      backgroundBrush: PdfSolidBrush(PdfColor(0, 0, 255)), // Blue color
      textBrush: PdfBrushes.white,
      font: PdfStandardFont(PdfFontFamily.helvetica, 10,
          style: PdfFontStyle.bold),
    );

    for (final entry in groupedItems.entries) {
      final purchase = entry.value.first.purchase;
      if (purchase == null) continue;

      final variantsInPurchase =
          entry.value.map((item) => item.variant).toList();

      final itemsString = variantsInPurchase
          .map((v) => '${v.itemNm ?? ''}=>${v.itemCd ?? ''}=>${v.pkgUnitCd ?? ''}')
          .join('\n');

      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = purchase.spplrTin;
      row.cells[1].value = purchase.spplrNm;
      row.cells[2].value = purchase.spplrInvcNo.toString();
      row.cells[3].value = purchase.salesDt;
      row.cells[4].value = purchase.totAmt.toStringAsFixed(2);
      row.cells[5].value = itemsString;
      row.cells[6].value = purchase.totItemCnt.toString();
    }

    grid.style.cellPadding = PdfPaddings(left: 5, right: 5, top: 5, bottom: 5);
    grid.style.font = PdfStandardFont(PdfFontFamily.helvetica, 9);

    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 120, pageSize.width, pageSize.height - 120),
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
