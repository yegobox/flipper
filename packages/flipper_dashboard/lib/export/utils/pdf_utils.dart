import 'dart:ui';
import 'package:flipper_models/db_model_export.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../models/export_config.dart';

/// Custom PDF header/footer details class
class CustomPdfHeaderFooterDetails {
  final PdfDocument pdfDocument;
  final PdfPage pdfPage;
  final PdfDocumentTemplate pdfDocumentTemplate;

  CustomPdfHeaderFooterDetails(this.pdfDocument, this.pdfPage)
      : pdfDocumentTemplate = PdfDocumentTemplate();
}

/// Utility class for PDF-related operations
class PdfUtils {
  /// Adds a footer to the PDF document
  static void addFooter(
    dynamic headerFooterExport, {
    required ExportConfig config,
  }) {
    // Handle both DataGridPdfHeaderFooterExportDetails and CustomPdfHeaderFooterDetails
    final PdfPage pdfPage =
        headerFooterExport is DataGridPdfHeaderFooterExportDetails
            ? headerFooterExport.pdfPage
            : headerFooterExport.pdfPage;

    final PdfDocumentTemplate template =
        headerFooterExport is DataGridPdfHeaderFooterExportDetails
            ? headerFooterExport.pdfDocumentTemplate
            : headerFooterExport.pdfDocumentTemplate;

    final double width = pdfPage.getClientSize().width;

    // Create a footer element with specific height
    final PdfPageTemplateElement footer = PdfPageTemplateElement(
      Rect.fromLTWH(0, 0, width, 40), // Footer height adjusted
    );

    // Create a PdfGrid for the footer layout
    final PdfGrid footerGrid = PdfGrid();
    footerGrid.columns.add(count: 4);

    // Adjust column widths for the layout
    footerGrid.columns[0].width = width * 0.2; // "Total:" label
    footerGrid.columns[1].width = width * 0.4; // Empty space
    footerGrid.columns[2].width = width * 0.2; // First value (e.g., "400")
    footerGrid.columns[3].width = width * 0.2; // Second value (e.g., "8000")

    // Add a row for the footer
    final PdfGridRow footerRow = footerGrid.rows.add();
    footerRow.height = 30; // Adjust row height if needed

    // Add data to the cells
    footerRow.cells[0].value = 'Total:';
    footerRow.cells[0].style = PdfGridCellStyle(
      borders: PdfBorders(
        left: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        right: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        top: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        bottom: PdfPen(PdfColor(211, 211, 211), width: 0.5),
      ),
      font: PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.bold),
    );

    // Leave the second cell empty
    footerRow.cells[1].value = '';
    footerRow.cells[1].style = PdfGridCellStyle(
      borders: PdfBorders(
        left: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        right: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        top: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        bottom: PdfPen(PdfColor(211, 211, 211), width: 0.5),
      ),
      font: PdfStandardFont(PdfFontFamily.helvetica, 12),
    );

    // Add values to the third and fourth cells
    footerRow.cells[2].value = config.transactions
        .fold<double>(0, (sum, trans) => sum + (trans.subTotal ?? 0))
        .toStringAsFixed(2);
    footerRow.cells[2].style = PdfGridCellStyle(
      borders: PdfBorders(
        left: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        right: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        top: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        bottom: PdfPen(PdfColor(211, 211, 211), width: 0.5),
      ),
      font: PdfStandardFont(PdfFontFamily.helvetica, 12),
    );

    footerRow.cells[3].value = config.transactions
        .fold<double>(0, (sum, trans) => sum + (trans.cashReceived ?? 0))
        .toStringAsFixed(2);
    footerRow.cells[3].style = PdfGridCellStyle(
      borders: PdfBorders(
        left: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        right: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        top: PdfPen(PdfColor(211, 211, 211), width: 0.5),
        bottom: PdfPen(PdfColor(211, 211, 211), width: 0.5),
      ),
      font: PdfStandardFont(PdfFontFamily.helvetica, 12,
          style: PdfFontStyle.bold),
    );

    // Draw the grid in the footer
    footerGrid.draw(
      graphics: footer.graphics,
      bounds: Rect.fromLTWH(0, 0, width, 30), // Positioning of the grid
    );

    // Set the footer for the PDF document
    template.bottom = footer;
  }

  /// Adds a header to the PDF document
  static void exportToPdf(
    dynamic headerFooterExport,
    Business business,
    ExportConfig config, {
    required String headerTitle,
  }) {
    // Handle both DataGridPdfHeaderFooterExportDetails and CustomPdfHeaderFooterDetails
    final PdfPage pdfPage =
        headerFooterExport is DataGridPdfHeaderFooterExportDetails
            ? headerFooterExport.pdfPage
            : headerFooterExport.pdfPage;

    final PdfDocumentTemplate template =
        headerFooterExport is DataGridPdfHeaderFooterExportDetails
            ? headerFooterExport.pdfDocumentTemplate
            : headerFooterExport.pdfDocumentTemplate;

    final double width = pdfPage.getClientSize().width;

    // Adjust the header size to only fit the necessary content
    final PdfPageTemplateElement header = PdfPageTemplateElement(
      Rect.fromLTWH(0, 0, width, 150), // Adjusted height for compact spacing
    );

    // Create fonts
    final PdfStandardFont titleFont =
        PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);
    final PdfStandardFont headerFont =
        PdfStandardFont(PdfFontFamily.helvetica, 11);
    final PdfStandardFont headerBoldFont =
        PdfStandardFont(PdfFontFamily.helvetica, 11, style: PdfFontStyle.bold);

    header.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(68, 114, 196)), // Blue background
      bounds: Rect.fromLTWH(
          0, 0, width, 40), // Increased height for better visibility
    );

    header.graphics.drawString(
      headerTitle,
      titleFont,
      brush: PdfBrushes.white, // White text for better contrast
      bounds: Rect.fromLTWH(0, 10, width, 30), // Adjusted Y-position and height
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        lineAlignment: PdfVerticalAlignment.middle,
      ),
    );

    // Define the vertical offset for content positioning
    double currentY = 40; // Start closer to the title for compact spacing

    // Increment the Y position for the next content block
    currentY += 20; // Reduced space between sections

    // Draw the first row of information
    _drawLabelValuePair(
      header,
      headerBoldFont,
      headerFont,
      'TIN Number:',
      business.tinNumber?.toString() ?? '',
      0,
      currentY,
      width,
    );

    _drawLabelValuePair(
      header,
      headerBoldFont,
      headerFont,
      'Start Date:',
      config.startDate?.toIso8601String().substring(0, 10) ?? '',
      width * 0.5,
      currentY,
      width,
    );

    // Increment Y position for the next row
    currentY += 20; // Reduced space between rows

    // Draw the second row of information
    _drawLabelValuePair(
      header,
      headerBoldFont,
      headerFont,
      'BHF ID:',
      '00',
      0,
      currentY,
      width,
    );

    _drawLabelValuePair(
      header,
      headerBoldFont,
      headerFont,
      'End Date:',
      config.endDate?.toIso8601String().substring(0, 10) ?? '',
      width * 0.5,
      currentY,
      width,
    );

    // Set the adjusted header to the PDF document template
    template.top = header;
  }

  /// Creates a custom header/footer details object for PDF export
  static CustomPdfHeaderFooterDetails createHeaderFooterDetails(
      PdfDocument document) {
    // Create a new page in the document
    final page = document.pages.add();

    // Create and return the custom details object
    return CustomPdfHeaderFooterDetails(document, page);
  }

  /// Helper method to draw a label-value pair in the PDF
  static void _drawLabelValuePair(
    PdfPageTemplateElement element,
    PdfFont boldFont,
    PdfFont regularFont,
    String label,
    String value,
    double x,
    double y,
    double width,
  ) {
    // Draw the label in bold
    element.graphics.drawString(
      label,
      boldFont,
      bounds: Rect.fromLTWH(x, y, width * 0.2, 20),
    );

    // Draw the value next to the label
    element.graphics.drawString(
      value,
      regularFont,
      bounds: Rect.fromLTWH(x + width * 0.2, y, width * 0.3, 20),
    );
  }
}
