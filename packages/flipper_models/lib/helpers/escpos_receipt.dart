import 'dart:typed_data';

import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/helpers/receipt_totals.dart';
import 'package:flipper_services/builtin_printer/escpos.dart';
import 'package:supabase_models/brick/models/all_models.dart';

/// The RRA EBM sale receipt laid out for a 58 mm (32-column) thermal printer
/// in native printer fonts. Same content and order as the roll PDF built by
/// `receipt/omni_printer.dart`; the amounts come from [ReceiptTotals], which
/// mirrors that PDF's arithmetic.
class EscPosReceipt {
  EscPosReceipt({
    required this.items,
    required this.receiptType,
    required this.vatEnabled,
    required this.totalDiscount,
    required this.taxA,
    required this.totalTax,
    required this.brandName,
    required this.brandAddress,
    required this.brandTel,
    required this.brandTIN,
    required this.customerName,
    required this.paymentTypeCode,
    required this.invoiceNum,
    required this.saleDate,
    required this.whenCreated,
    this.brandEmail,
    this.customerTin,
    this.customerPhone,
    this.originalInvoiceNumber,
    this.isFiscalReceipt = true,
    this.sdcId = '',
    this.rcptNo = 0,
    this.totRcptNo = 0,
    this.internalData = '',
    this.receiptSignature = '',
    this.receiptQrCode = '',
    this.mrc = '',
    this.timeFromServer,
    this.logo,
    this.qrMode = EscPosQrMode.raster,
  });

  final List<TransactionItem> items;
  final String receiptType;
  final bool vatEnabled;
  final double totalDiscount;
  final double taxA;
  final String totalTax;
  final String brandName;
  final String brandAddress;
  final String brandTel;
  final String brandTIN;
  final String? brandEmail;
  final String customerName;
  final String? customerTin;
  final String? customerPhone;
  final int? originalInvoiceNumber;
  final String? paymentTypeCode;
  final int invoiceNum;

  /// The transaction's date (the PDF's `DATE:`), and the receipt's creation
  /// time (`TIME:`).
  final DateTime? saleDate;
  final DateTime whenCreated;

  final bool isFiscalReceipt;
  final String sdcId;
  final int rcptNo;
  final int totRcptNo;
  final String internalData;
  final String receiptSignature;
  final String receiptQrCode;
  final String mrc;
  final DateTime? timeFromServer;
  final MonoBitmap? logo;
  final EscPosQrMode qrMode;

  Uint8List build() {
    final totals = ReceiptTotals(
      items: items,
      receiptType: receiptType,
      vatEnabled: vatEnabled,
      totalDiscount: totalDiscount,
      taxA: taxA,
      totalTax: totalTax,
    );
    final p = EscPos()..init();
    _header(p);
    _items(p, totals);
    _summary(p, totals);
    _footer(p);
    p.cut();
    return p.bytes();
  }

  bool get _isRefund =>
      receiptType == 'NR' || receiptType == 'TR' || receiptType == 'CR';

  void _header(EscPos p) {
    if (logo != null) {
      p
        ..image(logo!)
        ..feed();
    }
    for (final line in EscPos.wrap(brandName, 16)) {
      p.text(line, align: EscPosAlign.center, bold: true, width: 2, height: 2);
    }
    if (brandAddress.trim().isNotEmpty) {
      p.wrapped(brandAddress, align: EscPosAlign.center);
    }
    p
      ..wrapped('TEL: ${brandTel.normalizePhone()}')
      ..wrapped('EMAIL: ${brandEmail ?? ''}')
      ..wrapped('TIN: $brandTIN')
      ..text('WELCOME TO OUR SHOP', align: EscPosAlign.center)
      ..rule();

    if (receiptType == 'TS' || receiptType == 'TR') {
      p.text('TRAINING MODE', align: EscPosAlign.center, bold: true);
      if (receiptType == 'TS') p.rule();
    }
    if (receiptType == 'PS') {
      p
        ..text('PROFORMA', align: EscPosAlign.center, bold: true)
        ..rule();
    }
    if (receiptType == 'CS' || receiptType == 'CR') {
      p.text('COPY', align: EscPosAlign.center, bold: true);
    }
    if (_isRefund) {
      p
        ..text('Refund', align: EscPosAlign.center, bold: true)
        ..rule()
        ..wrapped(
          'REF.NORMAL RECEIPT:# ${originalInvoiceNumber ?? ''}',
          align: EscPosAlign.center,
        )
        ..rule()
        ..wrapped(
          'REFUND IS APPROVED ONLY FOR ORIGINAL SALES RECEIPT',
          align: EscPosAlign.center,
        )
        ..rule();
    }
    _customer(p);
    p.rule();
  }

  void _customer(EscPos p) {
    if (customerTin?.isNotEmpty ?? false) {
      p.wrapped('TIN: $customerTin', bold: !_isRefund);
    }
    p.wrapped('Name: $customerName', bold: !_isRefund);
    if (customerPhone?.isNotEmpty ?? false) {
      p.wrapped('TEL: ${customerPhone!.normalizePhone()}', bold: !_isRefund);
    }
  }

  void _items(EscPos p, ReceiptTotals totals) {
    for (final item in items) {
      final total = ReceiptTotals.lineTotal(item);
      final price = ReceiptTotals.num0(item.price).toStringAsFixed(2);
      final qty = _qty(ReceiptTotals.num0(item.qty));
      final label = item.ttCatCd == 'TT' && vatEnabled
          ? '(${item.taxTyCd ?? 'B'}&TT)'
          : totals.taxLabel(item);
      p
        ..wrapped(item.name)
        ..row(
          '${price}x $qty',
          '${totals.linePrefix}${total.toNoCurrencyFormatted()}$label',
        );
      final dcRt = ReceiptTotals.num0(item.dcRt);
      if (dcRt != 0) {
        p.row(
          'Discount - ${_qty(dcRt)} %',
          (total - total * dcRt / 100).toStringAsFixed(2),
        );
      }
    }
    p.rule();
    if (['TS', 'PS', 'CS', 'CR', 'TR'].contains(receiptType)) {
      p
        ..text('THIS IS NOT AN OFFICIAL RECEIPT', align: EscPosAlign.center)
        ..rule();
    }
  }

  void _summary(EscPos p, ReceiptTotals totals) {
    var first = true;
    for (final line in totals.summary()) {
      // TOTAL stands out, like the bold row on the PDF.
      p.row(line.label, line.value, bold: first);
      first = false;
    }
    p
      ..rule()
      ..row(
        '${ReceiptTotals.paymentTypeName(paymentTypeCode)}:',
        totals.paidAmount,
      )
      ..row('ITEMS NUMBER:', '${items.length}')
      ..rule();
    if (receiptType == 'CS' || receiptType == 'CR') {
      p
        ..text('COPY', align: EscPosAlign.center)
        ..rule();
    }
    if (receiptType == 'TS' || receiptType == 'TR') {
      p
        ..text('TRAINING MODE', align: EscPosAlign.center, bold: true)
        ..rule();
    }
    if (receiptType == 'PS') {
      p
        ..text('PROFORMA', align: EscPosAlign.center, bold: true)
        ..rule();
    }
  }

  void _footer(EscPos p) {
    if (isFiscalReceipt) {
      p
        ..text('SDC INFORMATION', align: EscPosAlign.center)
        ..rule()
        ..text('Date: ${(timeFromServer ?? whenCreated).isoDateTime}')
        ..row('SDC ID:', sdcId)
        ..row('RECEIPT NUMBER:', '$rcptNo / $totRcptNo $receiptType');
      if (receiptType != 'PS' && receiptType != 'TS' && receiptType != 'TR') {
        p
          ..text('Internal Data', align: EscPosAlign.center)
          ..wrapped(
            internalData.toDashedStringInternalData(),
            align: EscPosAlign.center,
          )
          ..text('Receipt Signature:')
          ..wrapped(receiptSignature.toDashedStringRcptSign());
      }
      if (receiptType != 'PS' &&
          receiptType != 'TS' &&
          receiptType != 'CR' &&
          receiptType != 'TR') {
        p.qr(receiptQrCode, mode: qrMode);
      }
      p.rule();
    }
    p
      ..row('RECEIPT NUMBER:', '$invoiceNum')
      ..row(
        'DATE:${saleDate?.formattedDate ?? ''}',
        'TIME:${whenCreated.formattedTime}',
      );
    if (isFiscalReceipt) p.row('MRC:', mrc);
    p
      ..rule()
      ..text('THANK YOU', align: EscPosAlign.center, bold: true)
      ..text('COME BACK AGAIN', align: EscPosAlign.center);
    if (isFiscalReceipt) {
      p.wrapped(
        'Flipper V2 Powered by RRA VSDC EBM 2.1',
        align: EscPosAlign.center,
      );
    }
  }

  /// `2` rather than `2.0`, `1.5` stays `1.5` (the PDF prints raw doubles;
  /// on 32 columns the trailing `.0` costs a column per line).
  static String _qty(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();
}

extension on String {
  /// Same rule as the receipt package's `normalizePhoneNumber`.
  String normalizePhone() {
    final digits = replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('00')) return '0${digits.substring(2)}';
    if (digits.length == 9 && digits.startsWith('7')) return '0$digits';
    return digits;
  }
}
