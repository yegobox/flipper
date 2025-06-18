import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
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

    // Footer template for logo
    final PdfPageTemplateElement footerTemplate = PdfPageTemplateElement(
        Rect.fromLTWH(0, 0, pageSize.width, 50)); // Footer area height 50
    try {
      final ByteData imageData =
          await rootBundle.load('packages/receipt/assets/flipper_logo.png');
      final PdfBitmap logoImage = PdfBitmap(imageData.buffer.asUint8List());
      const double logoWidth = 25;
      const double logoHeight = 25;
      final double xLogoPosition = (pageSize.width - logoWidth) / 2;
      // Draw logo at the top of the footer area, centered
      footerTemplate.graphics.drawImage(
          logoImage, Rect.fromLTWH(xLogoPosition, 0, logoWidth, logoHeight));
    } catch (e) {
      print('Error loading logo for footer: $e');
    }
    document.template.bottom = footerTemplate;

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
    header.cells[8].value = 'Invoice Foreign\nCurrency Amount';
    header.cells[9].value = 'Foreign\nCurrency';

    header.style.backgroundBrush =
        PdfSolidBrush(PdfColor(173, 216, 230)); // Light Blue
    header.style.textBrush = PdfBrushes.black; // Black text for better contrast
    header.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);

    // Define pens
    final PdfPen testPen = PdfPen(PdfColor(192, 192, 192),
        width: 0.75); // Silver, slightly thicker
    final PdfPen blackPen = PdfPens.black;

    // Apply border to header cells
    for (int i = 0; i < header.cells.count; i++) {
      final PdfGridCell cell = header.cells[i];
      cell.style.borders.top = testPen;
      cell.style.borders.bottom = testPen;
      cell.style.borders.left = testPen;
      cell.style.borders.right = testPen;
    }

    for (int i = 0; i < variants.length; i++) {
      final variant = variants[i];
      final PdfGridRow row = grid.rows.add();

      // Apply border to data cells for each new row
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        cell.style.borders.top = testPen;
        cell.style.borders.bottom = testPen;
        cell.style.borders.left = testPen;
        cell.style.borders.right = testPen;
      }

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

    // Optimized column widths to fit within page margins (A4 page ~595 points width)
    // Leaving ~30 points total margin (15 on each side)
    // Available width: ~565 points
    grid.columns[0].width = 20; // #
    grid.columns[1].width = 50; // Request Date
    grid.columns[2].width = 55; // Declaration Number
    grid.columns[3].width = 75; // Item Name
    grid.columns[4].width = 40; // Quantity
    grid.columns[5].width = 40; // Quantity Unit Code
    grid.columns[6].width = 80; // Supplier name
    grid.columns[7].width = 55; // Agent name
    grid.columns[8].width = 75; // Invoice Foreign Currency Amount
    grid.columns[9].width = 75; // Foreign Currency
    // Total: 565 points - should fit comfortably within page width

    grid.style.cellPadding = PdfPaddings(left: 2, right: 2, top: 2, bottom: 2);
    grid.style.font = PdfStandardFont(PdfFontFamily.helvetica, 8);

    // Use available page width with small margins
    final double tableWidth =
        pageSize.width - 15; // 7.5 points margin on each side
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(
          7.5, 120, tableWidth, pageSize.height - 170), // Reduced margins
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
