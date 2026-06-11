import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:supabase_models/brick/models/stock_recount.model.dart';
import 'package:supabase_models/brick/models/stock_recount_item.model.dart';
import 'package:universal_platform/universal_platform.dart';

import 'stock_recount_helpers.dart';

class StockRecountPdfExport {
  static pw.Font? _fallbackFont;
  static final Map<String, pw.Font?> _geistFonts = {};

  /// Geist (the design's typeface) only covers Latin; NotoSans fills the gaps
  /// (em dash, non-Latin product names) via the page theme's fontFallback.
  static Future<pw.Font?> _unicodeFallback() async {
    if (_fallbackFont != null) return _fallbackFont;
    try {
      final data = await rootBundle.load(
        'packages/receipt/assets/fonts/NotoSans-Regular.ttf',
      );
      _fallbackFont = pw.Font.ttf(data);
    } catch (_) {}
    return _fallbackFont;
  }

  static Future<pw.Font?> _geist(String weight) async {
    if (_geistFonts.containsKey(weight)) return _geistFonts[weight];
    pw.Font? font;
    try {
      final data = await rootBundle.load(
        'packages/flipper_dashboard/assets/fonts/Geist-$weight.ttf',
      );
      font = pw.Font.ttf(data);
    } catch (_) {}
    _geistFonts[weight] = font;
    return font;
  }

  /// Saves or shares the PDF — does not open the system print dialog.
  static Future<void> previewAndShare({
    required StockRecount recount,
    required List<StockRecountItem> items,
    required String businessName,
    required String branchName,
  }) async {
    final counterName = await StockRecountExportContext.resolveCounterName(
      userId: recount.userId,
    );
    final skus = await StockRecountExportContext.resolveVariantSkus(items);
    final stats = RecountItemStats.fromItems(items);
    final bytes = await build(
      recount: recount,
      items: items,
      stats: stats,
      businessName: businessName,
      branchName: branchName,
      counterName: counterName,
      variantSkus: skus,
    );
    final deviceSlug = (recount.deviceName ?? 'device')
        .replaceAll(RegExp(r'[^\w]+'), '_');
    final dateSlug = DateFormat('yyyyMMdd').format(DateTime.now());
    final filename = 'recount_${deviceSlug}_$dateSlug.pdf';

    if (kIsWeb) {
      await Printing.sharePdf(
        bytes: bytes,
        filename: filename,
        subject: 'Stock Recount Report',
      );
      return;
    }

    if (UniversalPlatform.isDesktop) {
      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Stock Recount PDF',
        fileName: filename,
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
        bytes: bytes,
      );
      if (savedPath != null && savedPath.isNotEmpty) {
        final file = File(savedPath);
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes, flush: true);
        await OpenFilex.open(savedPath);
      }
      return;
    }

    await Printing.sharePdf(
      bytes: bytes,
      filename: filename,
      subject: 'Stock Recount Report',
    );
  }

  static Future<Uint8List> build({
    required StockRecount recount,
    required List<StockRecountItem> items,
    required RecountItemStats stats,
    required String businessName,
    required String branchName,
    required String counterName,
    Map<String, String> variantSkus = const {},
  }) async {
    pw.ImageProvider? logo;
    try {
      final logoBytes = await rootBundle.load(
        'packages/receipt/assets/flipper_logo.png',
      );
      logo = pw.MemoryImage(logoBytes.buffer.asUint8List());
    } catch (_) {}
    final baseFont = await _geist('Regular') ?? pw.Font.helvetica();
    final boldFont = await _geist('Bold') ?? pw.Font.helveticaBold();
    // Design weight 800 for the document titles and totals row.
    final heavyFont = await _geist('ExtraBold') ?? boldFont;
    final fallbackFont = await _unicodeFallback();
    final now = DateTime.now();
    final reportId = recount.id.length >= 6
        ? recount.id.substring(recount.id.length - 6).toUpperCase()
        : recount.id.toUpperCase();

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 44, vertical: 40),
        theme: pw.ThemeData.withFont(
          base: baseFont,
          bold: boldFont,
          fontFallback: [if (fallbackFont != null) fallbackFont],
        ),
        build: (context) => [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    if (logo != null)
                      pw.Image(logo, width: 40, height: 40)
                    else
                      pw.SizedBox(width: 40, height: 40),
                    pw.SizedBox(width: 12),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          businessName,
                          style: pw.TextStyle(
                            font: heavyFont,
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                            letterSpacing: -0.4,
                          ),
                        ),
                        pw.Text(
                          branchName,
                          style: pw.TextStyle(
                            font: baseFont,
                            fontSize: 12.5,
                            color: const PdfColor.fromInt(0xFF5B6678),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Stock Recount',
                    style: pw.TextStyle(
                      font: heavyFont,
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: -0.44,
                    ),
                  ),
                  pw.Text(
                    'Report #$reportId',
                    style: pw.TextStyle(
                      font: baseFont,
                      fontSize: 12,
                      color: const PdfColor.fromInt(0xFF5B6678),
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  _statusBadge(recount.status, boldFont),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Container(height: 2, color: PdfColors.black),
          pw.SizedBox(height: 20),
          _metaGrid(recount, counterName, now, baseFont, boldFont),
          if (recount.notes != null && recount.notes!.trim().isNotEmpty) ...[
            pw.SizedBox(height: 14),
            pw.Text(
              'Note: ${recount.notes!.trim()}',
              style: pw.TextStyle(
                font: baseFont,
                fontSize: 13,
                color: const PdfColor.fromInt(0xFF4A5567),
              ),
            ),
          ],
          pw.SizedBox(height: 8),
          _itemsTable(items, stats, variantSkus, baseFont, boldFont, heavyFont),
          pw.SizedBox(height: 18),
          _summaryPills(stats, baseFont, boldFont),
          pw.SizedBox(height: 48),
          pw.Row(
            children: [
              pw.Expanded(child: _signatureBlock('Counted by — $counterName', baseFont)),
              pw.SizedBox(width: 40),
              pw.Expanded(child: _signatureBlock('Approved by', baseFont)),
            ],
          ),
          pw.SizedBox(height: 30),
          pw.Container(height: 1, color: const PdfColor.fromInt(0xFFE6ECF5)),
          pw.SizedBox(height: 16),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Generated by Flipper · Stock Recount',
                style: pw.TextStyle(
                  font: baseFont,
                  fontSize: 11,
                  color: const PdfColor.fromInt(0xFF8A93A6),
                ),
              ),
              pw.Text(
                '$businessName — $branchName',
                style: pw.TextStyle(
                  font: baseFont,
                  fontSize: 11,
                  color: const PdfColor.fromInt(0xFF8A93A6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return doc.save();
  }

  static pw.Widget _statusBadge(String status, pw.Font bold) {
    final (bg, fg) = switch (status) {
      'draft' => (
          const PdfColor.fromInt(0xFFFEF3C7),
          const PdfColor.fromInt(0xFFB45309),
        ),
      'submitted' => (
          const PdfColor.fromInt(0xFFDBEAFE),
          const PdfColor.fromInt(0xFF1D4ED8),
        ),
      'synced' => (
          const PdfColor.fromInt(0xFFD1FAE5),
          const PdfColor.fromInt(0xFF047857),
        ),
      _ => (
          const PdfColor.fromInt(0xFFF7F9FE),
          const PdfColor.fromInt(0xFF7E8AA0),
        ),
    };
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: pw.BoxDecoration(
        color: bg,
        // dart_pdf does not clamp oversized radii like Flutter; a huge radius
        // paints over the whole page, so use half the badge height.
        borderRadius: pw.BorderRadius.circular(9),
      ),
      child: pw.Text(
        status.toUpperCase(),
        style: pw.TextStyle(
          font: bold,
          fontSize: 10.5,
          letterSpacing: 0.63,
          color: fg,
        ),
      ),
    );
  }

  static pw.Widget _metaGrid(
    StockRecount recount,
    String counter,
    DateTime now,
    pw.Font regular,
    pw.Font bold,
  ) {
    pw.Widget cell(String key, String value) => pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            key.toUpperCase(),
            style: pw.TextStyle(
              font: bold,
              fontSize: 10.5,
              letterSpacing: 0.525,
              color: const PdfColor.fromInt(0xFF8A93A6),
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(font: bold, fontSize: 14),
          ),
        ],
      ),
    );

    return pw.Column(
      children: [
        pw.Row(
          children: [
            cell('Device', recount.deviceName ?? '—'),
            cell('Counted by', counter),
            cell('Created', StockRecountHelpers.formatDate(recount.createdAt)),
            cell(
              'Generated',
              '${StockRecountHelpers.formatDate(now)} ${StockRecountHelpers.formatTime(now)}',
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Container(height: 1, color: const PdfColor.fromInt(0xFFE6ECF5)),
      ],
    );
  }

  static pw.Widget _itemsTable(
    List<StockRecountItem> items,
    RecountItemStats stats,
    Map<String, String> variantSkus,
    pw.Font regular,
    pw.Font bold,
    pw.Font heavy,
  ) {
    PdfColor varianceColor(double v) {
      if (v > 0) return const PdfColor.fromInt(0xFF047857);
      if (v < 0) return const PdfColor.fromInt(0xFFB91C1C);
      return const PdfColor.fromInt(0xFF8A93A6);
    }

    pw.Widget headerCell(String text, {pw.TextAlign align = pw.TextAlign.left}) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: pw.Text(
          text.toUpperCase(),
          textAlign: align,
          style: pw.TextStyle(
            font: bold,
            fontSize: 10.5,
            letterSpacing: 0.42,
            color: const PdfColor.fromInt(0xFF8A93A6),
          ),
        ),
      );
    }

    String skuFor(StockRecountItem item) =>
        variantSkus[item.variantId] ?? item.variantId;

    return pw.Table(
      border: const pw.TableBorder(
        horizontalInside: pw.BorderSide(color: PdfColor.fromInt(0xFFEFF3F9)),
      ),
      columnWidths: const {
        0: pw.FlexColumnWidth(0.45),
        1: pw.FlexColumnWidth(2.95),
        2: pw.FlexColumnWidth(1),
        3: pw.FlexColumnWidth(1),
        4: pw.FlexColumnWidth(1.25),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(
                color: PdfColor.fromInt(0xFFD6DEEA),
                width: 1.5,
              ),
            ),
          ),
          children: [
            headerCell('#'),
            headerCell('Product'),
            headerCell('System', align: pw.TextAlign.right),
            headerCell('Counted', align: pw.TextAlign.right),
            headerCell('Variance', align: pw.TextAlign.right),
          ],
        ),
        ...items.asMap().entries.map((entry) {
          final i = entry.key + 1;
          final item = entry.value;
          return pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: pw.Text(
                  '$i',
                  style: pw.TextStyle(
                    font: regular,
                    fontSize: 13.5,
                    color: const PdfColor.fromInt(0xFF8A93A6),
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      item.productName,
                      style: pw.TextStyle(
                        font: bold,
                        fontSize: 13.5,
                      ),
                    ),
                    pw.Text(
                      'SKU ${skuFor(item)}',
                      style: pw.TextStyle(
                        font: regular,
                        fontSize: 11,
                        color: const PdfColor.fromInt(0xFF8A93A6),
                      ),
                    ),
                  ],
                ),
              ),
              _numCell(item.previousQuantity, regular),
              _numCell(item.countedQuantity, regular),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: pw.Text(
                  StockRecountHelpers.formatSignedVariance(item.difference),
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                    font: bold,
                    fontSize: 13.5,
                    color: varianceColor(item.difference),
                  ),
                ),
              ),
            ],
          );
        }),
        pw.TableRow(
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(
                color: PdfColor.fromInt(0xFFD6DEEA),
                width: 2,
              ),
            ),
          ),
          children: [
            pw.SizedBox(),
            pw.Padding(
              padding: const pw.EdgeInsets.fromLTRB(10, 14, 10, 12),
              child: pw.Text(
                'Totals · ${stats.count} ${stats.count == 1 ? 'item' : 'items'}',
                style: pw.TextStyle(font: heavy, fontSize: 14),
              ),
            ),
            _numCell(stats.sysTot, heavy, size: 14),
            _numCell(stats.cntTot, heavy, size: 14),
            pw.Padding(
              padding: const pw.EdgeInsets.fromLTRB(10, 14, 10, 12),
              child: pw.Text(
                StockRecountHelpers.formatSignedVariance(stats.net),
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  font: heavy,
                  fontSize: 14,
                  color: varianceColor(stats.net),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Same stroke paths as assets/pos_handoff/icons/{check,trend-up,arrow-down}.svg
  // so the PDF pills render the exact icons the app shows.
  static const _checkPath = '<path d="M5 12.5 10 17 19 7.5"/>';
  static const _trendUpPath = '<path d="m4 15 5-5 4 4 7-7"/><path d="M16 7h4v4"/>';
  static const _arrowDownPath = '<path d="M12 5v14"/><path d="m6 13 6 6 6-6"/>';

  static String _hex(PdfColor c) {
    String two(double v) => (v * 255).round().toRadixString(16).padLeft(2, '0');
    return '#${two(c.red)}${two(c.green)}${two(c.blue)}';
  }

  static pw.Widget _pillIcon(String paths, PdfColor color, {double size = 13}) {
    return pw.SizedBox(
      width: size,
      height: size,
      child: pw.SvgImage(
        svg: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" '
            'fill="none" stroke="${_hex(color)}" stroke-width="1.5" '
            'stroke-linecap="round" stroke-linejoin="round">$paths</svg>',
      ),
    );
  }

  static pw.Widget _summaryPills(
    RecountItemStats stats,
    pw.Font regular,
    pw.Font bold,
  ) {
    pw.Widget pill({
      required String iconPaths,
      required String label,
      required PdfColor bg,
      required PdfColor border,
      required PdfColor fg,
    }) {
      return pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: pw.BoxDecoration(
          color: bg,
          border: pw.Border.all(color: border),
          // Half the pill height — see the radius note in _statusBadge.
          borderRadius: pw.BorderRadius.circular(13),
        ),
        child: pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            _pillIcon(iconPaths, fg),
            pw.SizedBox(width: 7),
            pw.Text(
              label,
              style: pw.TextStyle(font: bold, fontSize: 12.5, color: fg),
            ),
          ],
        ),
      );
    }

    return pw.Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        pill(
          iconPaths: _checkPath,
          label: '${stats.match} matching',
          bg: const PdfColor.fromInt(0xFFFFFFFF),
          border: const PdfColor.fromInt(0xFFE6ECF5),
          fg: const PdfColor.fromInt(0xFF4A5567),
        ),
        pill(
          iconPaths: _trendUpPath,
          label: '${stats.over} surplus',
          bg: const PdfColor.fromInt(0xFFE6F8F0),
          border: const PdfColor.fromInt(0xFFBBEAD4),
          fg: const PdfColor.fromInt(0xFF047857),
        ),
        pill(
          iconPaths: _arrowDownPath,
          label: '${stats.short} short',
          bg: const PdfColor.fromInt(0xFFFDECEC),
          border: const PdfColor.fromInt(0xFFF6C9C9),
          fg: const PdfColor.fromInt(0xFFB91C1C),
        ),
      ],
    );
  }

  static pw.Widget _numCell(num value, pw.Font font, {double size = 13.5}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: pw.Text(
        StockRecountHelpers.formatQty(value),
        textAlign: pw.TextAlign.right,
        style: pw.TextStyle(font: font, fontSize: size),
      ),
    );
  }

  static pw.Widget _signatureBlock(String label, pw.Font regular) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 28),
        pw.Container(height: 1, color: PdfColors.black),
        pw.SizedBox(height: 7),
        pw.Text(
          label,
          style: pw.TextStyle(
            font: regular,
            fontSize: 11.5,
            color: const PdfColor.fromInt(0xFF5B6678),
          ),
        ),
      ],
    );
  }
}
