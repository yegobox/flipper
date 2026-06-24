import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';

/// VAT-exclusive line totals (18% Rwanda standard).
DocTotals docTotals(List<DocLine> lines, {double rate = 0.18}) {
  var subtotal = 0;
  for (final l in lines) {
    subtotal += (l.qty * l.price).round();
  }
  final vat = (subtotal * rate).round();
  return DocTotals(subtotal: subtotal, vat: vat, total: subtotal + vat);
}

String docStatusLabel(DocStatus status) => switch (status) {
      DocStatus.draft => 'Draft',
      DocStatus.sent => 'Sent',
      DocStatus.paid => 'Paid',
      DocStatus.overdue => 'Overdue',
    };

String nextDocumentId(DocKind kind, List<AccountingDocument> docs) {
  final prefix = kind == DocKind.invoice ? 'INV-' : 'BILL-';
  var max = 0;
  for (final d in docs) {
    final digits = d.id.replaceAll(RegExp(r'\D'), '');
    final n = int.tryParse(digits) ?? 0;
    if (n > max) max = n;
  }
  return '$prefix${max + 1}';
}
