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

/// Grand total of a document: the stored total when present, else derived
/// from its lines.
int docGrandTotal(AccountingDocument doc) =>
    doc.total ?? docTotals(doc.lines).total;

/// Still owed on a document; never negative.
int docBalance(AccountingDocument doc) {
  if (doc.status == DocStatus.paid) return 0;
  final left = docGrandTotal(doc) - doc.amountPaid;
  return left < 0 ? 0 : left;
}

/// Sent, part-paid or overdue documents with money still owed.
bool docIsOpen(AccountingDocument doc) =>
    (doc.status == DocStatus.sent ||
        doc.status == DocStatus.partiallyPaid ||
        doc.status == DocStatus.overdue) &&
    docBalance(doc) > 0;

String docStatusLabel(DocStatus status) => switch (status) {
      DocStatus.draft => 'Draft',
      DocStatus.sent => 'Sent',
      DocStatus.partiallyPaid => 'Part paid',
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
