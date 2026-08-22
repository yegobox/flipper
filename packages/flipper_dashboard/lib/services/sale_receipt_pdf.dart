import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Business identity stamped on a locally built sale copy.
class SaleReceiptIssuer {
  const SaleReceiptIssuer({
    this.businessName,
    this.branchName,
    this.tin,
    this.address,
    this.phone,
  });

  final String? businessName;
  final String? branchName;
  final String? tin;
  final String? address;
  final String? phone;
}

/// Builds a receipt/invoice PDF straight from local sale data.
///
/// The EBM flow uploads a signed PDF at sale time and stamps
/// [ITransaction.receiptFileName]; this builder is the fallback for every sale
/// that has no stored PDF (credit sales, VAT-disabled businesses, sales made
/// before receipt upload, or an upload that never completed) so Share, Download
/// and Print always produce a document instead of an error.
class SaleReceiptPdf {
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

  static Future<String?> _logoMarkup() async {
    if (_flipperLogoSvg != null) return _flipperLogoSvg;
    try {
      _flipperLogoSvg = await rootBundle.loadString(_flipperLogoSvgAsset);
    } catch (_) {}
    return _flipperLogoSvg;
  }

  static Future<Uint8List> build({
    required ITransaction transaction,
    required List<TransactionItem> items,
    required String currency,
    SaleReceiptIssuer issuer = const SaleReceiptIssuer(),
    Receipt? fiscalReceipt,
    DateTime? generatedAt,
  }) async {
    final logoSvg = await _logoMarkup();
    final fallback = await _unicodeFallback();
    final money = NumberFormat('#,##0.##');
    final stamp = transaction.createdAt ??
        transaction.lastTouched ??
        transaction.updatedAt;
    final isExpense = transaction.isExpense == true ||
        transaction.isIncome == false ||
        transaction.transactionType == 'Cash Out';

    var lineTotal = 0.0;
    var discountTotal = 0.0;
    for (final item in items) {
      lineTotal += (item.price * item.qty).toDouble();
      final rate = item.dcRt?.toDouble() ?? 0;
      if (rate != 0) {
        discountTotal += item.price.toDouble() * (rate / 100) * item.qty.toDouble();
      }
    }
    final grandTotal = transaction.subTotal?.toDouble() ??
        (lineTotal - discountTotal);
    final tax = transaction.taxAmount?.toDouble() ?? 0;
    final cash = transaction.cashReceived?.toDouble() ?? 0;
    final change = transaction.customerChangeDue?.toDouble() ?? 0;
    final refunded = transaction.isRefunded == true;

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
            title: isExpense ? 'Expense record' : 'Sale receipt',
            copy: fiscalReceipt == null,
          ),
          pw.SizedBox(height: 18),
          _metaBlock(
            transaction: transaction,
            stamp: stamp,
            refunded: refunded,
          ),
          pw.SizedBox(height: 16),
          if (items.isEmpty)
            pw.Text(
              'No line items were recorded for this transaction.',
              style: const pw.TextStyle(fontSize: 10),
            )
          else
            pw.TableHelper.fromTextArray(
              headers: ['Item', 'Qty', 'Unit price', 'Amount'],
              data: items.map((item) {
                final gross = (item.price * item.qty).toDouble();
                final rate = item.dcRt?.toDouble() ?? 0;
                final net = rate == 0 ? gross : gross * (1 - rate / 100);
                return [
                  item.name,
                  money.format(item.qty),
                  money.format(item.price),
                  money.format(net),
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              cellStyle: const pw.TextStyle(fontSize: 10),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.centerRight,
              },
            ),
          pw.SizedBox(height: 12),
          _totals(
            currency: currency,
            money: money,
            lineTotal: lineTotal,
            discountTotal: discountTotal,
            tax: tax,
            grandTotal: grandTotal,
            cash: cash,
            change: change,
            paymentType: transaction.paymentType,
          ),
          if (refunded) ...[
            pw.SizedBox(height: 14),
            _refundNote(
              transaction: transaction,
              currency: currency,
              money: money,
            ),
          ],
          if (fiscalReceipt != null) ...[
            pw.SizedBox(height: 16),
            _fiscalBlock(fiscalReceipt),
          ],
          pw.SizedBox(height: 20),
          pw.Text(
            fiscalReceipt == null
                ? 'Customer copy generated from Flipper records on '
                    '${DateFormat('dd MMM yyyy HH:mm').format((generatedAt ?? DateTime.now()).toLocal())}. '
                    'This document is not an EBM fiscal receipt.'
                : 'Reprint of the EBM receipt signed for this sale. '
                    'Generated ${DateFormat('dd MMM yyyy HH:mm').format((generatedAt ?? DateTime.now()).toLocal())}.',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
        ],
      ),
    );
    return doc.save();
  }

  static pw.Widget _header({
    required String? logoSvg,
    required SaleReceiptIssuer issuer,
    required String title,
    required bool copy,
  }) {
    final lines = <String>[
      if ((issuer.branchName ?? '').isNotEmpty) issuer.branchName!,
      if ((issuer.tin ?? '').isNotEmpty) 'TIN: ${issuer.tin}',
      if ((issuer.address ?? '').isNotEmpty) issuer.address!,
      if ((issuer.phone ?? '').isNotEmpty) issuer.phone!,
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
              title.toUpperCase(),
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13),
            ),
            if (copy)
              pw.Text(
                'CUSTOMER COPY',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey600,
                ),
              ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _metaBlock({
    required ITransaction transaction,
    required DateTime? stamp,
    required bool refunded,
  }) {
    final rows = <List<String>>[
      ['Reference', _reference(transaction)],
      [
        'Date',
        stamp != null
            ? DateFormat('dd MMM yyyy HH:mm').format(stamp.toLocal())
            : '—',
      ],
      ['Payment', _paymentLabel(transaction.paymentType)],
      [
        'Status',
        refunded
            ? (transaction.status ?? 'refunded').toUpperCase()
            : (transaction.status ?? '—').toUpperCase(),
      ],
      if ((transaction.customerName ?? '').trim().isNotEmpty)
        ['Customer', transaction.customerName!.trim()],
      if ((transaction.customerPhone ?? '').trim().isNotEmpty)
        ['Phone', transaction.customerPhone!.trim()],
      if ((transaction.customerTin ?? '').trim().isNotEmpty)
        ['Customer TIN', transaction.customerTin!.trim()],
    ];

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          for (final row in rows)
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 3),
              child: pw.Row(
                children: [
                  pw.SizedBox(
                    width: 96,
                    child: pw.Text(
                      row[0],
                      style: const pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      row[1],
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  static pw.Widget _totals({
    required String currency,
    required NumberFormat money,
    required double lineTotal,
    required double discountTotal,
    required double tax,
    required double grandTotal,
    required double cash,
    required double change,
    required String? paymentType,
  }) {
    final isCash = (paymentType ?? '').toUpperCase().contains('CASH');
    final rows = <List<String>>[
      ['Subtotal', '$currency ${money.format(lineTotal)}'],
      if (discountTotal > 0)
        ['Discount', '- $currency ${money.format(discountTotal)}'],
      if (tax > 0) ['Tax', '$currency ${money.format(tax)}'],
    ];

    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.SizedBox(
        width: 240,
        child: pw.Column(
          children: [
            for (final row in rows)
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 3),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(row[0], style: const pw.TextStyle(fontSize: 10)),
                    pw.Text(row[1], style: const pw.TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            pw.Divider(height: 8, color: PdfColors.grey400),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Total',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  '$currency ${money.format(grandTotal)}',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (isCash && cash > 0) ...[
              pw.SizedBox(height: 6),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Cash received',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                  pw.Text(
                    '$currency ${money.format(cash)}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Change', style: const pw.TextStyle(fontSize: 10)),
                  pw.Text(
                    '$currency ${money.format(change)}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  static pw.Widget _refundNote({
    required ITransaction transaction,
    required String currency,
    required NumberFormat money,
  }) {
    final amount = transaction.refundedAmount?.toDouble() ??
        transaction.subTotal?.toDouble() ??
        0;
    final method = transaction.refundMethod == 'momo' ? 'MoMo' : 'Cash';
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.red50,
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Refunded: $currency ${money.format(amount)} via $method',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          if ((transaction.refundReason ?? '').isNotEmpty)
            pw.Text(
              'Reason: ${transaction.refundReason}',
              style: const pw.TextStyle(fontSize: 9),
            ),
        ],
      ),
    );
  }

  static pw.Widget _fiscalBlock(Receipt receipt) {
    final rows = <List<String>>[
      if ((receipt.sdcId ?? '').isNotEmpty) ['SDC ID', receipt.sdcId!],
      if ((receipt.mrcNo ?? '').isNotEmpty) ['MRC', receipt.mrcNo!],
      if (receipt.rcptNo != null)
        ['Receipt no.', '${receipt.rcptNo}/${receipt.totRcptNo ?? '—'}'],
      if ((receipt.intrlData ?? '').isNotEmpty)
        ['Internal data', receipt.intrlData!],
      if ((receipt.rcptSign ?? '').isNotEmpty)
        ['Signature', receipt.rcptSign!],
    ];
    if (rows.isEmpty) return pw.SizedBox();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'EBM details',
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        for (final row in rows)
          pw.Row(
            children: [
              pw.SizedBox(
                width: 96,
                child: pw.Text(
                  row[0],
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey700,
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  row[1],
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ),
            ],
          ),
      ],
    );
  }

  static String _reference(ITransaction transaction) {
    final ref = transaction.reference?.trim();
    if (ref != null && ref.isNotEmpty) {
      return ref.startsWith('#') ? ref : '#$ref';
    }
    final id = transaction.id;
    if (id.isEmpty) return '—';
    return '#${id.length > 8 ? id.substring(0, 8) : id}';
  }

  static String _paymentLabel(String? paymentType) {
    if (paymentType == null || paymentType.trim().isEmpty) return '—';
    final upper = paymentType.toUpperCase();
    if (upper.contains('MOMO') || upper.contains('MOBILE')) return 'MoMo';
    if (upper.contains('CARD')) return 'Card';
    if (upper.contains('CASH')) return 'Cash';
    return paymentType;
  }
}
