import 'dart:io';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;

class ExportImport {
  Future<void> export(List<Variant> variants) async {
    final business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);

    final PdfDocument document = PdfDocument();
    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();

    _drawHeader(page, pageSize, variants, business);
    _drawTable(page, pageSize, variants);

    final List<int> bytes = await document.save();
    document.dispose();

    await _saveAndLaunchFile(bytes, 'ImportReport.pdf');
  }

  void _drawHeader(
      PdfPage page, Size pageSize, List<Variant> variants, Business? business) {
    final PdfGraphics graphics = page.graphics;
    final PdfFont titleFont =
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);
    final PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 12);

    graphics.drawString('Imports Report', titleFont,
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
          .map((v) {
            try {
              return DateTime.parse(v.dclDe!);
            } catch (e) {
              return null;
            }
          })
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

  void _drawTable(PdfPage page, Size pageSize, List<Variant> variants) {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 10);

    final PdfGridRow header = grid.headers.add(1)[0];
    header.cells[0].value = '#';
    header.cells[1].value = 'Request Date';
    header.cells[2].value = 'Declaration Number';
    header.cells[3].value = 'Item Name';
    header.cells[4].value = 'Quantity';
    header.cells[5].value = 'Quantity Unit Code';
    header.cells[6].value = 'Supplier name';
    header.cells[7].value = 'Agent name';
    header.cells[8].value = 'Invoice Foreign Currency Amount';
    header.cells[9].value = 'Invoice Foreign Currency';

    header.style = PdfGridCellStyle(
      backgroundBrush: PdfSolidBrush(PdfColor(0, 0, 255)), // Blue color
      textBrush: PdfBrushes.white,
      font: PdfStandardFont(PdfFontFamily.helvetica, 10,
          style: PdfFontStyle.bold),
    );

    for (int i = 0; i < variants.length; i++) {
      final variant = variants[i];
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = (i + 1).toString();
      row.cells[1].value = variant.dclDe ?? '';
      row.cells[2].value = variant.dclNo ?? '';
      row.cells[3].value = variant.itemNm ?? '';
      row.cells[4].value = variant.qty?.toStringAsFixed(0) ?? '';
      row.cells[5].value = variant.qtyUnitCd ?? '';
      row.cells[6].value = variant.spplrNm ?? '';
      row.cells[7].value = variant.agntNm ?? '';
      row.cells[8].value = variant.invcFcurAmt?.toStringAsFixed(0) ?? '';
      row.cells[9].value = variant.invcFcurCd ?? '';
    }

    for (int i = 0; i < grid.columns.count; i++) {
      grid.columns[i].width = 70;
    }
    grid.columns[0].width = 20;
    grid.columns[3].width = 120;
    grid.columns[6].width = 120;

    grid.style.cellPadding = PdfPaddings(left: 2, right: 2, top: 2, bottom: 2);
    grid.style.font = PdfStandardFont(PdfFontFamily.helvetica, 8);

    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(0, 120, 0, 0),
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
