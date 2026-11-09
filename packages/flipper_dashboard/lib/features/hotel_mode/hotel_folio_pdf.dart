import 'dart:typed_data';

import 'package:flipper_dashboard/features/hotel_mode/hotel_quotation_pdf.dart';
import 'package:flipper_dashboard/services/pdf_assets.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/models/branch_document_settings.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:flipper_services/constants.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

/// Where the folio stands, which decides what the document calls itself.
enum HotelFolioDocumentKind {
  /// Still open: a bill to look at, not a tax invoice.
  proforma,

  /// Settled at checkout.
  invoice,

  /// Settled on credit: invoiced, with a balance still owed.
  credit,
}

/// What a folio document is called, from the folio as stored.
HotelFolioDocumentKind hotelFolioDocumentKind(ITransaction? folio) {
  if (folio == null) return HotelFolioDocumentKind.proforma;
  if (folio.isLoan == true) return HotelFolioDocumentKind.credit;
  if (folio.status == COMPLETE) return HotelFolioDocumentKind.invoice;
  return HotelFolioDocumentKind.proforma;
}

/// Whether [stay]'s folio has not fully synced down yet, so a document now
/// would be wrong: a checked-out stay without its folio would print as a
/// pro-forma, and a billed folio without its lines as an invoice for nothing.
/// An open stay may simply have no folio yet; that is a pro-forma, not a gap.
bool hotelFolioStillSyncing({
  required HotelStay stay,
  required ITransaction? folio,
  required List<TransactionItem> lines,
}) {
  if (folio == null) return stay.hasFolio && !stay.isOpen;
  return (folio.subTotal ?? 0) > 0 && lines.isEmpty;
}

/// The guest's folio as an A4 page: every night and every extra on one
/// document, with what was paid ahead and what is left.
///
/// The fiscal record is still the RRA receipt filed at checkout; this is the
/// whole-stay bill guests and the companies paying for them ask for, and it
/// names that receipt when there is one.
abstract final class HotelFolioPdf {
  static Future<Uint8List> build({
    required HotelStay stay,
    required List<TransactionItem> lines,
    required ITransaction? folio,
    required String currency,
    HotelQuotationIssuer issuer = const HotelQuotationIssuer(),
    DocumentStamp? stamp,
    DateTime? generatedAt,
  }) async {
    final logoSvg = await PdfAssets.flipperLogoMarkup();
    final fallback = await PdfAssets.unicodeFallback();
    final money = NumberFormat('#,##0.##');
    String amount(num v) => '$currency ${money.format(v)}';
    final issued = generatedAt ?? DateTime.now();
    final kind = hotelFolioDocumentKind(folio);
    final l10n = FlipperL10n.current;

    final breakdown = hotelFolioTaxBreakdown(lines);
    final kept = [
      for (final a in stay.advances)
        if (a.status != HotelAdvanceStatus.refunded) a,
    ];
    final advanced = kept.fold<double>(0, (s, a) => s + a.amount);

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
            kind: kind,
            folio: folio,
            issued: issued,
          ),
          pw.SizedBox(height: 18),
          _stayBlock(stay, billedTo: _billedTo(stay, folio)),
          pw.SizedBox(height: 18),
          _linesTable(lines, amount),
          pw.SizedBox(height: 10),
          _totalRow(l10n.subtotal, amount(breakdown.subtotal)),
          _totalRow(l10n.hotelTaxIncl, amount(breakdown.tax)),
          _withStamp(
            _totalRow(l10n.hotelTotal, amount(breakdown.total), bold: true),
            // "Beside the total" draws it here; every other placement below.
            stamp?.placement == DocumentStampPlacement.besideTotals
                ? stamp
                : null,
          ),
          if (kept.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            _advances(kept, amount),
          ],
          pw.SizedBox(height: 8),
          _balance(
            kind: kind,
            folio: folio,
            total: breakdown.total,
            advanced: advanced,
            amount: amount,
          ),
          pw.SizedBox(height: 18),
          pw.Text(
            kind == HotelFolioDocumentKind.proforma
                ? l10n.hotelFolioNotTaxInvoice
                : l10n.hotelFolioThanks,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
          if (stamp != null &&
              stamp.placement != DocumentStampPlacement.besideTotals) ...[
            pw.SizedBox(height: 16),
            pw.Align(
              alignment: HotelQuotationPdf.stampAlignment(stamp.placement),
              child: HotelQuotationPdf.stampImage(stamp),
            ),
          ],
        ],
      ),
    );
    return doc.save();
  }

  static String _title(HotelFolioDocumentKind kind) {
    final l10n = FlipperL10n.current;
    switch (kind) {
      case HotelFolioDocumentKind.proforma:
        return l10n.hotelFolioProformaTitle;
      case HotelFolioDocumentKind.invoice:
      case HotelFolioDocumentKind.credit:
        return l10n.hotelFolioInvoiceTitle;
    }
  }

  static pw.Widget _header({
    required String? logoSvg,
    required HotelQuotationIssuer issuer,
    required HotelFolioDocumentKind kind,
    required ITransaction? folio,
    required DateTime issued,
  }) {
    final l10n = FlipperL10n.current;
    final lines = <String>[
      if ((issuer.branchName ?? '').isNotEmpty) issuer.branchName!,
      if ((issuer.tin ?? '').isNotEmpty) '${l10n.tin}: ${issuer.tin}',
      if ((issuer.address ?? '').isNotEmpty) issuer.address!,
      if ((issuer.phone ?? '').isNotEmpty) issuer.phone!,
      if ((issuer.email ?? '').isNotEmpty) issuer.email!,
    ];
    final receipt = folio?.receiptNumber;
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
              _title(kind),
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13),
            ),
            if (receipt != null && receipt > 0)
              pw.Text(
                l10n.hotelFolioReceiptNumber('$receipt'),
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            pw.Text(
              DateFormat('dd MMM yyyy, HH:mm').format(issued.toLocal()),
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
          ],
        ),
      ],
    );
  }

  /// Who the invoice is billed to when that is not the guest: the customer
  /// a credit checkout put the folio on (an employer, a travel agency).
  static String? _billedTo(HotelStay stay, ITransaction? folio) {
    final name = folio?.customerName?.trim() ?? '';
    if (name.isEmpty || name == stay.guestName.trim()) return null;
    return name;
  }

  static pw.Widget _withStamp(pw.Widget row, DocumentStamp? stamp) {
    if (stamp == null) return row;
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        HotelQuotationPdf.stampImage(stamp),
        pw.SizedBox(width: 16),
        pw.Expanded(child: row),
      ],
    );
  }

  static pw.Widget _stayBlock(HotelStay stay, {String? billedTo}) {
    final l10n = FlipperL10n.current;
    final day = DateFormat('dd MMM yyyy');
    pw.Widget field(String label, String value) => pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label.toUpperCase(),
            style: const pw.TextStyle(
              fontSize: 8,
              letterSpacing: 0.6,
              color: PdfColors.grey600,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
    return pw.Column(
      children: [
        pw.Row(
          children: [
            field(l10n.hotelGuestName, stay.guestName),
            field(l10n.phone, stay.guestPhone ?? '—'),
            field(l10n.hotelRoom, stay.roomName),
          ],
        ),
        if (billedTo != null) ...[
          pw.SizedBox(height: 10),
          pw.Row(children: [field(l10n.customer, billedTo)]),
        ],
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            field(l10n.hotelArrival, day.format(stay.checkInAt.toLocal())),
            field(
              l10n.hotelDeparture,
              day.format(
                (stay.checkedOutAt ?? stay.expectedCheckOutAt).toLocal(),
              ),
            ),
            field(l10n.hotelStay, l10n.hotelNightsCount(stay.nights)),
          ],
        ),
      ],
    );
  }

  static pw.Widget _linesTable(
    List<TransactionItem> lines,
    String Function(num) amount,
  ) {
    final l10n = FlipperL10n.current;
    final qty = NumberFormat('#,##0.##');
    return pw.Table(
      border: const pw.TableBorder(
        horizontalInside: pw.BorderSide(color: PdfColors.grey300),
      ),
      columnWidths: const {
        0: pw.FlexColumnWidth(),
        1: pw.FixedColumnWidth(50),
        2: pw.FixedColumnWidth(95),
        3: pw.FixedColumnWidth(105),
      },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _cell(l10n.hotelDescription, bold: true),
            _cell(l10n.quantity, bold: true, alignRight: true),
            _cell(l10n.unitPrice, bold: true, alignRight: true),
            _cell(l10n.amount, bold: true, alignRight: true),
          ],
        ),
        for (final line in lines)
          pw.TableRow(
            children: [
              _cell(line.name),
              _cell(qty.format(line.qty), alignRight: true),
              _cell(amount(line.price), alignRight: true),
              _cell(amount(hotelFolioTotal([line])), alignRight: true),
            ],
          ),
      ],
    );
  }

  static pw.Widget _advances(
    List<HotelAdvance> advances,
    String Function(num) amount,
  ) {
    final l10n = FlipperL10n.current;
    final day = DateFormat('dd MMM yyyy');
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          l10n.hotelAdvances.toUpperCase(),
          style: const pw.TextStyle(
            fontSize: 8,
            letterSpacing: 0.6,
            color: PdfColors.grey600,
          ),
        ),
        pw.SizedBox(height: 4),
        for (final a in advances)
          _totalRow(
            '${day.format(a.paidAt.toLocal())} · ${_method(a.paymentMethod)}',
            '− ${amount(a.amount)}',
          ),
      ],
    );
  }

  static String _method(String wire) {
    final l10n = FlipperL10n.current;
    switch (wire) {
      case 'Cash':
        return l10n.cash;
      case 'MOBILE MONEY':
        return l10n.paymentMobileMoney;
      case 'DEBIT&CREDIT CARD':
        return l10n.hotelPaymentCard;
      default:
        return wire;
    }
  }

  static pw.Widget _balance({
    required HotelFolioDocumentKind kind,
    required ITransaction? folio,
    required double total,
    required double advanced,
    required String Function(num) amount,
  }) {
    final l10n = FlipperL10n.current;
    switch (kind) {
      case HotelFolioDocumentKind.proforma:
        final plan = HotelAdvanceSettlement.of(total: total, held: advanced);
        return plan.surplus > 0
            ? _totalRow(
                l10n.hotelAdvanceToRefund,
                amount(plan.surplus),
                bold: true,
              )
            : _totalRow(l10n.hotelBalanceDue, amount(plan.balance), bold: true);
      case HotelFolioDocumentKind.credit:
        final owed = folio?.remainingBalance ?? (total - advanced);
        return _totalRow(
          l10n.hotelFolioBalanceOwed,
          amount(owed < 0 ? 0 : owed),
          bold: true,
        );
      case HotelFolioDocumentKind.invoice:
        // An advance above the folio was handed back at checkout: the rows
        // above list it whole, so say what went back.
        final surplus = HotelAdvanceSettlement.of(
          total: total,
          held: advanced,
        ).surplus;
        final paid = _totalRow(
          l10n.hotelFolioPaidInFull,
          amount(total),
          bold: true,
        );
        if (surplus <= 0) return paid;
        return pw.Column(
          children: [
            _totalRow(l10n.hotelAdvanceRefunded, amount(surplus)),
            paid,
          ],
        );
    }
  }

  static pw.Widget _totalRow(String label, String value, {bool bold = false}) {
    final style = pw.TextStyle(
      fontSize: bold ? 12 : 10,
      fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
    );
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Text('$label  ', style: style),
          pw.SizedBox(
            width: 120,
            child: pw.Text(value, textAlign: pw.TextAlign.right, style: style),
          ),
        ],
      ),
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
}
