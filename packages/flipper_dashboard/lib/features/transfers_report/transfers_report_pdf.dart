import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:universal_platform/universal_platform.dart';

/// PDF export for transfers-to-branch reports (Stock Recount pattern).
class TransfersReportPdfExport {
  static const _flipperLogoSvgAsset =
      'packages/flipper_dashboard/assets/pos_handoff/icons/flipper-logo.svg';

  static pw.Font? _fallbackFont;
  static String? _flipperLogoSvg;

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

  static Future<String?> _flipperLogoMarkup() async {
    if (_flipperLogoSvg != null) return _flipperLogoSvg;
    try {
      _flipperLogoSvg = await rootBundle.loadString(_flipperLogoSvgAsset);
    } catch (_) {}
    return _flipperLogoSvg;
  }

  static Future<void> previewAndShareSummary({
    required String destinationBranchName,
    required List<InventoryRequest> transfers,
    required Map<String, String> fromBranchNames,
    DateTime? rangeStart,
    DateTime? rangeEnd,
  }) async {
    final bytes = await buildSummary(
      destinationBranchName: destinationBranchName,
      transfers: transfers,
      fromBranchNames: fromBranchNames,
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
    );
    final dateSlug = DateFormat('yyyyMMdd').format(DateTime.now());
    final branchSlug = destinationBranchName.replaceAll(RegExp(r'[^\w]+'), '_');
    final filename = 'transfers_to_${branchSlug}_$dateSlug.pdf';
    await _saveOrShare(bytes: bytes, filename: filename, subject: 'Transfers Report');
  }

  static Future<void> previewAndShareTransfer({
    required InventoryRequest transfer,
    required String destinationBranchName,
    required String fromBranchName,
  }) async {
    final bytes = await buildSingle(
      transfer: transfer,
      destinationBranchName: destinationBranchName,
      fromBranchName: fromBranchName,
    );
    final short = transfer.id.length > 8
        ? transfer.id.substring(0, 8)
        : transfer.id;
    final filename = 'transfer_$short.pdf';
    await _saveOrShare(bytes: bytes, filename: filename, subject: 'Stock Transfer');
  }

  static Future<void> _saveOrShare({
    required Uint8List bytes,
    required String filename,
    required String subject,
  }) async {
    if (kIsWeb) {
      await Printing.sharePdf(bytes: bytes, filename: filename, subject: subject);
      return;
    }
    if (UniversalPlatform.isDesktop) {
      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Transfers PDF',
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
    await Printing.sharePdf(bytes: bytes, filename: filename, subject: subject);
  }

  static Future<Uint8List> buildSummary({
    required String destinationBranchName,
    required List<InventoryRequest> transfers,
    required Map<String, String> fromBranchNames,
    DateTime? rangeStart,
    DateTime? rangeEnd,
  }) async {
    final logoSvg = await _flipperLogoMarkup();
    final fallback = await _unicodeFallback();
    final dateFmt = DateFormat('dd MMM yyyy HH:mm');
    final rangeFmt = DateFormat('dd MMM yyyy');

    var totalUnits = 0;
    for (final t in transfers) {
      for (final line in t.transactionItems ?? const <TransactionItem>[]) {
        totalUnits += line.quantityApproved ?? line.quantityRequested ?? line.qty.round();
      }
    }

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          theme: pw.ThemeData.withFont(
            base: pw.Font.helvetica(),
            bold: pw.Font.helveticaBold(),
            fontFallback: [if (fallback != null) fallback],
          ),
        ),
        header: (ctx) => _header(
          logoSvg: logoSvg,
          title: 'Stock transfers to $destinationBranchName',
          subtitle: [
            if (rangeStart != null && rangeEnd != null)
              '${rangeFmt.format(rangeStart)} – ${rangeFmt.format(rangeEnd)}',
            '${transfers.length} transfer(s) · $totalUnits unit(s)',
          ].whereType<String>().join('  ·  '),
        ),
        build: (ctx) => [
          if (transfers.isEmpty)
            pw.Text('No transfers in this range.')
          else
            pw.TableHelper.fromTextArray(
              headers: const ['Date', 'From', 'ID', 'Items', 'Status'],
              data: transfers.map((t) {
                final stamp = t.approvedAt ?? t.createdAt;
                final fromId = t.mainBranchId ?? '';
                final fromName = fromBranchNames[fromId] ??
                    t.branch?.name ??
                    fromId;
                final short = t.id.length > 8 ? t.id.substring(0, 8) : t.id;
                final count = t.itemCounts ?? t.transactionItems?.length ?? 0;
                return [
                  stamp != null ? dateFmt.format(stamp.toLocal()) : '—',
                  fromName,
                  short.toUpperCase(),
                  '$count',
                  t.status ?? '—',
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              cellStyle: const pw.TextStyle(fontSize: 9),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                3: pw.Alignment.centerRight,
              },
            ),
          pw.SizedBox(height: 16),
          ...transfers.map((t) {
            final lines = t.transactionItems ?? const <TransactionItem>[];
            if (lines.isEmpty) return pw.SizedBox();
            final fromId = t.mainBranchId ?? '';
            final fromName =
                fromBranchNames[fromId] ?? t.branch?.name ?? fromId;
            final short = t.id.length > 8 ? t.id.substring(0, 8) : t.id;
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(height: 12),
                pw.Text(
                  'Transfer ${short.toUpperCase()} · from $fromName',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.TableHelper.fromTextArray(
                  headers: const ['Product', 'Qty'],
                  data: lines
                      .map(
                        (l) => [
                          l.name,
                          '${l.quantityApproved ?? l.quantityRequested ?? l.qty.round()}',
                        ],
                      )
                      .toList(),
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 9,
                  ),
                  cellStyle: const pw.TextStyle(fontSize: 9),
                  cellAlignments: {1: pw.Alignment.centerRight},
                ),
              ],
            );
          }),
        ],
        footer: (ctx) => pw.Text(
          'Generated ${DateFormat('dd MMM yyyy HH:mm').format(DateTime.now())} · page ${ctx.pageNumber}/${ctx.pagesCount}',
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
        ),
      ),
    );
    return doc.save();
  }

  static Future<Uint8List> buildSingle({
    required InventoryRequest transfer,
    required String destinationBranchName,
    required String fromBranchName,
  }) async {
    final logoSvg = await _flipperLogoMarkup();
    final fallback = await _unicodeFallback();
    final dateFmt = DateFormat('dd MMM yyyy HH:mm');
    final stamp = transfer.approvedAt ?? transfer.createdAt;
    final lines = transfer.transactionItems ?? const <TransactionItem>[];
    final short = transfer.id.length > 8
        ? transfer.id.substring(0, 8)
        : transfer.id;

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          theme: pw.ThemeData.withFont(
            base: pw.Font.helvetica(),
            bold: pw.Font.helveticaBold(),
            fontFallback: [if (fallback != null) fallback],
          ),
        ),
        header: (ctx) => _header(
          logoSvg: logoSvg,
          title: 'Stock transfer ${short.toUpperCase()}',
          subtitle:
              '$fromBranchName → $destinationBranchName · ${stamp != null ? dateFmt.format(stamp.toLocal()) : '—'} · ${transfer.status ?? ''}',
        ),
        build: (ctx) => [
          pw.TableHelper.fromTextArray(
            headers: const ['Product', 'Requested', 'Approved'],
            data: lines
                .map(
                  (l) => [
                    l.name,
                    '${l.quantityRequested ?? l.qty.round()}',
                    '${l.quantityApproved ?? 0}',
                  ],
                )
                .toList(),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
            ),
            cellStyle: const pw.TextStyle(fontSize: 10),
            headerDecoration:
                const pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignments: {
              1: pw.Alignment.centerRight,
              2: pw.Alignment.centerRight,
            },
          ),
          if (transfer.approvedBy != null) ...[
            pw.SizedBox(height: 12),
            pw.Text(
              'Approved by: ${transfer.approvedBy}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ],
      ),
    );
    return doc.save();
  }

  static pw.Widget _header({
    required String? logoSvg,
    required String title,
    required String subtitle,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          children: [
            if (logoSvg != null)
              pw.SizedBox(
                width: 28,
                height: 28,
                child: pw.SvgImage(svg: logoSvg),
              ),
            if (logoSvg != null) pw.SizedBox(width: 10),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Flipper',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  pw.Text(
                    title,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  pw.Text(
                    subtitle,
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Divider(),
        pw.SizedBox(height: 8),
      ],
    );
  }
}
