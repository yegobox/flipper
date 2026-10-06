import 'package:flipper_models/helperModels/extensions.dart';
import 'package:supabase_models/brick/models/all_models.dart';

/// One printed line of an EBM receipt: label left, amount right.
typedef ReceiptLine = ({String label, String value});

/// The RRA EBM receipt arithmetic, kept free of any page layout so the PDF
/// (`receipt/omni_printer.dart`) and the 58 mm ESC/POS receipt print the same
/// numbers. Mirrors `OmniPrinter._body` line for line, including which rows
/// are skipped and the minus sign on refunds.
class ReceiptTotals {
  ReceiptTotals({
    required this.items,
    required this.receiptType,
    required this.vatEnabled,
    required this.totalDiscount,
    required this.taxA,
    required this.totalTax,
  });

  final List<TransactionItem> items;
  final String receiptType;
  final bool vatEnabled;
  final double totalDiscount;

  /// Total of tax-A (exempt) items after discount, as passed to the PDF.
  final double taxA;

  /// VAT on B items as computed by the caller (`TaxController`).
  final String totalTax;

  /// Refunds (normal, training, copy of refund) print every amount negative.
  bool get isRefund =>
      receiptType == 'NR' || receiptType == 'CR' || receiptType == 'TR';

  static double num0(Object? v) {
    if (v == null) return 0;
    if (v is num) return v.isFinite ? v.toDouble() : 0;
    return double.tryParse(v.toString().replaceAll(',', '').trim()) ?? 0;
  }

  static double lineTotal(TransactionItem i) => num0(i.price) * num0(i.qty);

  static double discounted(TransactionItem i) =>
      lineTotal(i) * (1 - num0(i.dcRt) / 100);

  /// The amount due: line totals less discounts. Also what the PDF prints
  /// against the payment type.
  double get total =>
      items.fold<double>(0, (s, i) => s + lineTotal(i)) - num0(totalDiscount);

  String _signed(String formatted) => isRefund ? '-$formatted' : formatted;

  /// The item's tax label, e.g. `(B)`, `(B&TT)`, `(D&TT)`.
  String taxLabel(TransactionItem item) {
    if (item.ttCatCd == 'TT') {
      return vatEnabled
          ? (item.taxTyCd != null ? '(${item.taxTyCd}&TT)' : '(B)')
          : '(D&TT)';
    }
    return item.taxTyCd != null ? '(${item.taxTyCd})' : '(B)';
  }

  /// `-` on refund lines, as on the PDF.
  String get linePrefix => isRefund ? '-' : '';

  double get _ttTax => items
      .where((i) => i.ttCatCd == 'TT')
      .fold<double>(0, (s, i) => s + discounted(i) * 3 / 103);

  bool get _allC =>
      items.isNotEmpty &&
      items.every((i) => i.taxTyCd == 'C' || i.taxTyCd == null);

  /// The tax summary block, in print order, with zero rows already dropped.
  List<ReceiptLine> summary() {
    final lines = <ReceiptLine>[];
    void add(String label, String value) =>
        lines.add((label: label, value: value));

    var t = total;
    if (isRefund) t = -t;
    add('TOTAL:', t.toNoCurrencyFormatted());

    final totalB = items
        .where((i) => i.taxTyCd == 'B')
        .fold<double>(0, (s, i) => s + discounted(i));
    if (totalB != 0) {
      add('TOTAL B-18%:', _signed(totalB.toNoCurrencyFormatted()));
    }
    final taxB = totalB * 18 / 118;
    if (taxB != 0) add('TOTAL TAX B:', _signed(taxB.toNoCurrencyFormatted()));

    final a = num0(taxA);
    if (a != 0) add('TOTAL A-EX:', _signed(a.toNoCurrencyFormatted()));

    if (items.any((i) => i.taxTyCd == 'C')) {
      // The PDF shows TOTAL C before discounts.
      final c = items
          .where((i) => i.taxTyCd == 'C')
          .fold<double>(0, (s, i) => s + lineTotal(i));
      add('TOTAL C:', _signed(c.toNoCurrencyFormatted()));
      if (_allC) add('TOTAL TAX:', _signed('0.00'));
    }

    final totalD = items
        .where(
          (i) => i.taxTyCd == 'D' && (vatEnabled ? i.ttCatCd != 'TT' : true),
        )
        .fold<double>(0, (s, i) => s + discounted(i));
    if (totalD != 0) add('TOTAL D:', _signed(totalD.toNoCurrencyFormatted()));

    final hasTT = items.any((i) => i.ttCatCd == 'TT');
    if (vatEnabled && hasTT && _ttTax != 0) {
      add('TOTAL TT:', _signed(_ttTax.toNoCurrencyFormatted()));
    }

    if (!_allC) {
      final tax = (num0(totalTax) + (hasTT ? _ttTax : 0)).toStringAsFixed(2);
      if (!vatEnabled && hasTT) add('TOTAL TT:', _signed(tax));
      if (vatEnabled || !hasTT) add('TOTAL TAX:', _signed(tax));
    }
    return lines;
  }

  /// The payment line amount (same sign rule as the PDF).
  String get paidAmount => isRefund
      ? '-${total.toNoCurrencyFormatted()}'
      : total.toNoCurrencyFormatted();

  static String paymentTypeName(String? code) {
    switch (code) {
      case '01':
        return 'CASH';
      case '02':
        return 'CREDIT CARD';
      case '03':
        return 'CASH/CREDIT CARD';
      case '04':
        return 'BANK CHECK';
      case '05':
        return 'DEBIT&CREDIT CARD';
      case '06':
        return 'MOBILE MONEY';
      default:
        return 'OTHER';
    }
  }
}
