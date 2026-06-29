import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// A single KPI summary card shown in the branded report header.
class ReportKpiCard {
  const ReportKpiCard({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final PdfColor color;
}

/// Shared visual language for the exported PDF reports (Z/X, Sale, PLU).
///
/// Centralizes the palette, branded header, KPI summary cards, table chrome
/// and the branded footer so every report looks consistent. Previously each
/// report carried its own (diverging) styling — the Sale Report was polished
/// while the Z/X report looked dated; this unifies them.
class ReportTheme {
  ReportTheme._();

  // ---- Palette ------------------------------------------------------------
  static final PdfColor primaryBlue = PdfColor(0, 100, 168);
  static final PdfColor darkGray = PdfColor(64, 64, 64);
  static final PdfColor midGray = PdfColor(120, 120, 120);
  static final PdfColor borderGray = PdfColor(220, 220, 220);
  static final PdfColor lightGray = PdfColor(245, 245, 245);
  static final PdfColor sectionBand = PdfColor(225, 235, 245);
  static final PdfColor accentGreen = PdfColor(76, 175, 80);
  static final PdfColor accentPurple = PdfColor(150, 100, 200);
  static final PdfColor accentOrange = PdfColor(255, 150, 50);
  static final PdfColor accentRed = PdfColor(229, 57, 53);
  static final PdfColor white = PdfColor(255, 255, 255);

  static const String _logoAsset = 'packages/receipt/assets/flipper_logo.png';

  /// Left/right page margin used by all branded reports.
  static const double margin = 40;

  // ---- Fonts --------------------------------------------------------------
  static PdfFont titleFont() =>
      PdfStandardFont(PdfFontFamily.helvetica, 22, style: PdfFontStyle.bold);
  static PdfFont metaFont() => PdfStandardFont(PdfFontFamily.helvetica, 10);
  static PdfFont cardValueFont() =>
      PdfStandardFont(PdfFontFamily.helvetica, 16, style: PdfFontStyle.bold);
  static PdfFont cardLabelFont() =>
      PdfStandardFont(PdfFontFamily.helvetica, 10);
  static PdfFont sectionFont() =>
      PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold);

  /// Currency formatter shared by all reports. [trimZeros] drops a trailing
  /// `.00` for the compact KPI cards.
  static String formatRwf(num value, {bool trimZeros = false}) {
    final formatted =
        NumberFormat.currency(symbol: 'RWF ', decimalDigits: 2).format(value);
    return trimZeros ? formatted.replaceAll('.00', '') : formatted;
  }

  /// Draws the branded header: business name (left) + report title (right),
  /// an accent divider, then the `TIN | MRC | CIS` meta line and the period.
  /// Returns the Y position immediately below the header.
  static double drawHeader(
    PdfPage page,
    Size pageSize, {
    required String reportTitle,
    required Business? business,
    Ebm? ebm,
    required String periodText,
  }) {
    final PdfGraphics g = page.graphics;
    final double contentWidth = pageSize.width - margin * 2;
    double y = 30;

    final PdfFont tFont = titleFont();
    final String businessName = business?.name ?? 'Business';
    final String shownName = businessName.length > 24
        ? businessName.substring(0, 24)
        : businessName;

    g.drawString(
      shownName,
      tFont,
      brush: PdfSolidBrush(darkGray),
      bounds: Rect.fromLTWH(margin, y, contentWidth * 0.6, 30),
      format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle),
    );
    g.drawString(
      reportTitle,
      tFont,
      brush: PdfSolidBrush(primaryBlue),
      bounds:
          Rect.fromLTWH(margin + contentWidth * 0.4, y, contentWidth * 0.6, 30),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.right,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
    );
    y += 36;

    // Accent divider under the title.
    g.drawLine(
      PdfPen(primaryBlue, width: 2),
      Offset(margin, y),
      Offset(pageSize.width - margin, y),
    );
    y += 10;

    final PdfFont mFont = metaFont();
    g.drawString(
      'TIN: ${business?.tinNumber ?? 'N/A'}   |   MRC: ${ebm?.mrc ?? 'N/A'}   |   CIS: Flipper',
      mFont,
      brush: PdfSolidBrush(darkGray),
      bounds: Rect.fromLTWH(margin, y, contentWidth, 14),
    );
    y += 16;
    g.drawString(
      periodText,
      mFont,
      brush: PdfSolidBrush(midGray),
      bounds: Rect.fromLTWH(margin, y, contentWidth, 14),
    );
    y += 24;
    return y;
  }

  /// Draws a single row of equal-width KPI cards. Returns the Y below them.
  static double drawSummaryCards(
    PdfPage page,
    Size pageSize,
    double y,
    List<ReportKpiCard> cards,
  ) {
    if (cards.isEmpty) return y;
    final PdfGraphics g = page.graphics;
    final double contentWidth = pageSize.width - margin * 2;
    const double spacing = 8;
    const double height = 76;
    final double cardWidth =
        (contentWidth - spacing * (cards.length - 1)) / cards.length;

    final PdfFont labelFont = cardLabelFont();

    for (var i = 0; i < cards.length; i++) {
      final double left = margin + (cardWidth + spacing) * i;
      _drawCard(
        g,
        Rect.fromLTWH(left, y, cardWidth, height),
        cards[i],
        labelFont,
      );
    }
    return y + height + 24;
  }

  static void _drawCard(
    PdfGraphics g,
    Rect bounds,
    ReportKpiCard card,
    PdfFont labelFont,
  ) {
    // Flat card: fill only, no border.
    g.drawRectangle(
      brush: PdfSolidBrush(card.color),
      bounds: bounds,
    );
    // Auto-contrast text for light vs dark card colors (perceived luminance).
    final double luminance =
        (0.299 * card.color.r + 0.587 * card.color.g + 0.114 * card.color.b) /
            255;
    final PdfColor textColor = luminance > 0.6 ? PdfColor(0, 0, 0) : white;

    // Auto-fit the value to one line so long currency strings aren't clipped.
    final double maxValueWidth = bounds.width - 12;
    double valueSize = 17;
    PdfFont valueFont = PdfStandardFont(PdfFontFamily.helvetica, valueSize,
        style: PdfFontStyle.bold);
    while (valueSize > 9 &&
        valueFont.measureString(card.value).width > maxValueWidth) {
      valueSize -= 1;
      valueFont = PdfStandardFont(PdfFontFamily.helvetica, valueSize,
          style: PdfFontStyle.bold);
    }

    g.drawString(
      card.value,
      valueFont,
      brush: PdfSolidBrush(textColor),
      bounds: Rect.fromLTWH(bounds.left + 6, bounds.top + 14, bounds.width - 12,
          bounds.height * 0.45),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle,
        wordWrap: PdfWordWrapType.none,
      ),
    );
    g.drawString(
      card.label,
      labelFont,
      brush: PdfSolidBrush(textColor),
      bounds: Rect.fromLTWH(bounds.left + 4, bounds.top + bounds.height * 0.58,
          bounds.width - 8, bounds.height * 0.36),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
    );
  }

  /// Styles a [PdfGrid] header row in the brand blue with white text.
  static void styleTableHeader(PdfGridRow header) {
    header.style.backgroundBrush = PdfSolidBrush(primaryBlue);
    header.style.textBrush = PdfBrushes.white;
    header.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
    final PdfPen pen = PdfPen(white, width: 1);
    for (int i = 0; i < header.cells.count; i++) {
      header.cells[i].style.borders =
          PdfBorders(left: pen, right: pen, top: pen, bottom: pen);
      header.cells[i].style.stringFormat = PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle,
      );
    }
  }

  /// Styles a [PdfGrid] data row as a section band (tinted, bold blue label).
  static void styleSectionRow(PdfGridRow row) {
    for (int i = 0; i < row.cells.count; i++) {
      row.cells[i].style.backgroundBrush = PdfSolidBrush(sectionBand);
    }
    row.cells[0].style.font = sectionFont();
    row.cells[0].style.textBrush = PdfSolidBrush(primaryBlue);
  }

  /// Applies gray borders + alternating row shading to a finished [PdfGrid].
  static void styleGridBody(PdfGrid grid) {
    final PdfPen pen = PdfPen(borderGray, width: 0.5);
    for (int i = 0; i < grid.rows.count; i++) {
      final row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        row.cells[j].style.borders =
            PdfBorders(left: pen, right: pen, top: pen, bottom: pen);
      }
    }
  }

  /// Builds a branded footer template (divider, logo, "Powered by Flipper",
  /// generated timestamp, page number) to assign to `document.template.bottom`.
  /// The page number resolves per page because it is a [PdfPageTemplateElement].
  static Future<PdfPageTemplateElement> buildFooter(Size pageSize) async {
    final PdfPageTemplateElement footer =
        PdfPageTemplateElement(Rect.fromLTWH(0, 0, pageSize.width, 50));
    final PdfGraphics g = footer.graphics;

    g.drawLine(
      PdfPen(borderGray, width: 1),
      Offset(margin, 8),
      Offset(pageSize.width - margin, 8),
    );

    try {
      final ByteData data = await rootBundle.load(_logoAsset);
      final PdfBitmap logo = PdfBitmap(data.buffer.asUint8List());
      g.drawImage(logo, Rect.fromLTWH(margin, 14, 26, 26));
    } catch (_) {
      // Logo is optional; skip on failure.
    }

    final PdfFont brandFont =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
    final PdfFont smallFont = PdfStandardFont(PdfFontFamily.helvetica, 8);

    g.drawString(
      'Powered by Flipper',
      brandFont,
      brush: PdfSolidBrush(darkGray),
      bounds: Rect.fromLTWH(margin + 34, 16, 220, 14),
    );
    g.drawString(
      'Generated: ${DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())}',
      smallFont,
      brush: PdfSolidBrush(midGray),
      bounds: Rect.fromLTWH(margin + 34, 31, 280, 12),
    );

    final PdfCompositeField pageNumber = PdfCompositeField(
      font: smallFont,
      brush: PdfSolidBrush(midGray),
      text: 'Page {0} of {1}',
      fields: <PdfAutomaticField>[
        PdfPageNumberField(),
        PdfPageCountField(),
      ],
    );
    pageNumber.draw(g, Offset(pageSize.width - margin - 90, 31));

    return footer;
  }
}
