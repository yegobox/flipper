import 'dart:convert';
import 'dart:typed_data';

import 'package:flipper_dashboard/services/pdf_assets.dart';
import 'package:flipper_dashboard/services/stamp_ink.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/models/branch_document_settings.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// The company stamp, resolved to bytes and ready to draw.
class DocumentStamp {
  const DocumentStamp({
    required this.bytes,
    this.placement = DocumentStampPlacement.bottomRight,
    this.widthMm = 38,
    this.aspectRatio = 1.0,
    this.opacity = 0.9,
  });

  /// Decodes [BranchDocumentSettings] into something a PDF can draw, or null
  /// when the branch has no usable stamp — callers then simply pass null.
  static DocumentStamp? fromSettings(BranchDocumentSettings? settings) {
    final bytes = _decode(settings);
    if (bytes == null) return null;
    try {
      // The upload is a photo; drawn raw it prints as a grey square.
      return _withBytes(settings!, inkifyStamp(bytes));
    } catch (_) {
      // A corrupt stamp must not cost the branch its quotation.
      return null;
    }
  }

  /// [fromSettings] with the photo processed off the UI isolate.
  static Future<DocumentStamp?> resolve(
    BranchDocumentSettings? settings,
  ) async {
    final bytes = _decode(settings);
    if (bytes == null) return null;
    return _withBytes(settings!, await inkifyStampInBackground(bytes));
  }

  static Uint8List? _decode(BranchDocumentSettings? settings) {
    if (settings == null || !settings.hasStamp) return null;
    try {
      final bytes = base64Decode(settings.stampImageBase64!);
      return bytes.isEmpty ? null : bytes;
    } catch (_) {
      return null;
    }
  }

  static DocumentStamp _withBytes(
    BranchDocumentSettings settings,
    Uint8List bytes,
  ) => DocumentStamp(
    bytes: bytes,
    placement: settings.stampPlacement,
    widthMm: settings.stampWidthMm,
    aspectRatio: settings.stampAspectRatio,
  );

  final Uint8List bytes;
  final DocumentStampPlacement placement;
  final double widthMm;

  /// height / width. Kept explicit so this stamp and the Syncfusion-drawn one
  /// on the leads proforma come out the same shape.
  final double aspectRatio;
  final double opacity;

  double get widthPt => widthMm * PdfPageFormat.mm;
  double get heightPt => widthPt * aspectRatio;
}

/// Who the quotation is from.
class HotelQuotationIssuer {
  const HotelQuotationIssuer({
    this.businessName,
    this.branchName,
    this.tin,
    this.address,
    this.phone,
    this.email,
  });

  final String? businessName;
  final String? branchName;
  final String? tin;
  final String? address;
  final String? phone;
  final String? email;
}

/// Renders a [HotelQuotation] as an A4 PDF the desk can email, print or save.
///
/// Uses `pdf` + `printing` like [SaleReceiptPdf], not the legacy Syncfusion
/// stack under `lib/export/` — a new document should not add to the older of
/// the two.
abstract final class HotelQuotationPdf {
  static Future<Uint8List> build({
    required HotelQuotation quotation,
    required String currency,
    HotelQuotationIssuer issuer = const HotelQuotationIssuer(),
    DocumentStamp? stamp,
    DateTime? generatedAt,
  }) async {
    final logoSvg = await PdfAssets.flipperLogoMarkup();
    final fallback = await PdfAssets.unicodeFallback();
    final money = NumberFormat('#,##0.##');
    final issued = generatedAt ?? DateTime.now();

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
        build: (ctx) => [
          _header(
            logoSvg: logoSvg,
            issuer: issuer,
            quotation: quotation,
            issued: issued,
          ),
          pw.SizedBox(height: 18),
          _guestBlock(quotation),
          pw.SizedBox(height: 14),
          _stayBlock(quotation),
          pw.SizedBox(height: 18),
          _chargesTable(
            quotation,
            currency,
            money,
            // Only this placement draws inside the totals row; the rest fall
            // to the trailing widget below.
            stamp: stamp?.placement == DocumentStampPlacement.besideTotals
                ? stamp
                : null,
          ),
          pw.SizedBox(height: 14),
          _validity(quotation),
          if ((quotation.note ?? '').trim().isNotEmpty) ...[
            pw.SizedBox(height: 14),
            _note(quotation.note!.trim()),
          ],
          pw.SizedBox(height: 18),
          _terms(),
          // Last widget in the list, so the stamp lands once on the final page.
          // A MultiPage footer would repeat it on every page and a header
          // would fight the logo for the same corner.
          if (stamp != null &&
              stamp.placement != DocumentStampPlacement.besideTotals) ...[
            pw.SizedBox(height: 16),
            _stampWidget(stamp),
          ],
        ],
      ),
    );

    return doc.save();
  }

  static pw.Widget _header({
    required String? logoSvg,
    required HotelQuotationIssuer issuer,
    required HotelQuotation quotation,
    required DateTime issued,
  }) {
    final lines = <String>[
      if ((issuer.branchName ?? '').isNotEmpty) issuer.branchName!,
      if ((issuer.tin ?? '').isNotEmpty)
        '${FlipperL10n.current.tin}: ${issuer.tin}',
      if ((issuer.address ?? '').isNotEmpty) issuer.address!,
      if ((issuer.phone ?? '').isNotEmpty) issuer.phone!,
      if ((issuer.email ?? '').isNotEmpty) issuer.email!,
    ];

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (logoSvg != null) ...[
          pw.SizedBox(width: 30, height: 30, child: pw.SvgImage(svg: logoSvg)),
          pw.SizedBox(width: 10),
        ],
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                (issuer.businessName ?? '').isNotEmpty
                    ? issuer.businessName!
                    : 'Flipper',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              for (final line in lines)
                pw.Text(
                  line,
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey700,
                  ),
                ),
            ],
          ),
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              FlipperL10n.current.hotelQuotationPdfTitle,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13),
            ),
            pw.Text(
              quotation.reference,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            ),
            pw.Text(
              DateFormat('dd MMM yyyy').format(issued.toLocal()),
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _guestBlock(HotelQuotation q) {
    final contact = <String>[
      if ((q.guestPhone ?? '').trim().isNotEmpty) q.guestPhone!.trim(),
      if ((q.guestEmail ?? '').trim().isNotEmpty) q.guestEmail!.trim(),
    ];
    return _panel(
      title: FlipperL10n.current.hotelPreparedFor,
      children: [
        pw.Text(
          q.guestName,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
        ),
        if (contact.isNotEmpty)
          pw.Text(
            contact.join('  ·  '),
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
      ],
    );
  }

  static pw.Widget _stayBlock(HotelQuotation q) {
    final l10n = FlipperL10n.current;
    final date = DateFormat('EEE dd MMM yyyy');
    final rows = <List<String>>[
      [l10n.hotelRoom, _roomLabel(q)],
      [l10n.hotelArrival, date.format(q.checkInAt.toLocal())],
      [l10n.hotelDeparture, date.format(q.checkOutAt.toLocal())],
      [l10n.hotelNights, l10n.hotelNightsCount(q.nights)],
      [l10n.hotelGuests, _guestsLabel(q)],
    ];

    return _panel(
      title: l10n.hotelStay,
      children: [
        pw.Table(
          columnWidths: const {
            0: pw.FixedColumnWidth(90),
            1: pw.FlexColumnWidth(),
          },
          children: [
            for (final row in rows)
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 3),
                    child: pw.Text(
                      row[0],
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 3),
                    child: pw.Text(
                      row[1],
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  static String _roomLabel(HotelQuotation q) {
    final type = q.roomType.trim();
    if (type.isEmpty) return q.roomName;
    return '${q.roomName} · $type';
  }

  static String _guestsLabel(HotelQuotation q) {
    final l10n = FlipperL10n.current;
    final parts = <String>[
      l10n.hotelAdultsCount(q.adults),
      if (q.children > 0) l10n.hotelChildrenCount(q.children),
    ];
    return parts.join(', ');
  }

  /// The quotation model carries no line items and no tax field — a single
  /// room rate, extras and a discount. Nothing here invents VAT: the leads
  /// proforma's 18% belongs to a different document.
  static pw.Widget _chargesTable(
    HotelQuotation q,
    String currency,
    NumberFormat money, {
    DocumentStamp? stamp,
  }) {
    final l10n = FlipperL10n.current;
    String amount(double v) => '$currency ${money.format(v)}';

    final rows = <List<String>>[
      [
        l10n.hotelQuotationRoomLine(
          q.roomName,
          q.nights.toString(),
          money.format(q.nightlyRate),
        ),
        amount(q.roomTotal),
      ],
      if (q.extrasTotal != 0) [l10n.hotelExtras, amount(q.extrasTotal)],
      if (q.discount != 0) [l10n.discount, '- ${amount(q.discount)}'],
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Table(
          border: const pw.TableBorder(
            horizontalInside: pw.BorderSide(color: PdfColors.grey300),
          ),
          columnWidths: const {
            0: pw.FlexColumnWidth(),
            1: pw.FixedColumnWidth(110),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _cell(l10n.hotelDescription, bold: true),
                _cell(l10n.amount, bold: true, alignRight: true),
              ],
            ),
            for (final row in rows)
              pw.TableRow(
                children: [_cell(row[0]), _cell(row[1], alignRight: true)],
              ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            if (stamp != null) ...[_stampImage(stamp), pw.SizedBox(width: 16)],
            pw.Text(
              '${l10n.hotelTotal}  ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
            ),
            pw.Text(
              amount(q.total),
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _cell(
    String text, {
    bool bold = false,
    bool alignRight = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: pw.Text(
        text,
        textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.Widget _validity(HotelQuotation q) {
    final l10n = FlipperL10n.current;
    final validUntil = q.validUntil;
    if (validUntil == null) {
      return pw.Text(
        l10n.hotelQuotationHoldsNoRoom,
        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
      );
    }
    final expired = validUntil.isBefore(DateTime.now());
    final day = DateFormat('dd MMM yyyy').format(validUntil.toLocal());
    return pw.Text(
      expired
          ? l10n.hotelQuotationExpiredOn(day)
          : l10n.hotelQuotationValidUntil(day),
      style: pw.TextStyle(
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
        color: expired ? PdfColors.red700 : PdfColors.grey800,
      ),
    );
  }

  static pw.Widget _note(String note) => _panel(
    title: FlipperL10n.current.hotelNote,
    children: [pw.Text(note, style: const pw.TextStyle(fontSize: 10))],
  );

  static pw.Widget _terms() {
    return pw.Text(
      FlipperL10n.current.hotelQuotationTerms,
      style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
    );
  }

  static pw.Widget _panel({
    required String title,
    required List<pw.Widget> children,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: const pw.TextStyle(
            fontSize: 8,
            letterSpacing: 0.6,
            color: PdfColors.grey600,
          ),
        ),
        pw.SizedBox(height: 4),
        ...children,
      ],
    );
  }

  static pw.Widget _stampWidget(DocumentStamp stamp) {
    return pw.Align(
      alignment: _stampAlignment(stamp.placement),
      child: _stampImage(stamp),
    );
  }

  /// A hand-pressed stamp never lands square; a slight tilt is most of what
  /// separates "stamped" from "pasted".
  static const double _stampTiltRadians = -0.07; // about -4°

  static pw.Widget _stampImage(DocumentStamp stamp) {
    return pw.Transform.rotate(
      angle: _stampTiltRadians,
      child: pw.Opacity(
        opacity: stamp.opacity,
        child: pw.Image(
          pw.MemoryImage(stamp.bytes),
          width: stamp.widthPt,
          height: stamp.heightPt,
        ),
      ),
    );
  }

  static pw.Alignment _stampAlignment(DocumentStampPlacement placement) {
    switch (placement) {
      case DocumentStampPlacement.bottomLeft:
        return pw.Alignment.centerLeft;
      case DocumentStampPlacement.bottomCentre:
        return pw.Alignment.center;
      case DocumentStampPlacement.bottomRight:
      // besideTotals never reaches here — it is drawn inside the totals row.
      case DocumentStampPlacement.besideTotals:
        return pw.Alignment.centerRight;
    }
  }
}
