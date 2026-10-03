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
int docGrandTotal(AccountingDocument doc) {
  if (doc.total != null) return doc.total!;
  // Purchase bill lines carry VAT-inclusive prices: adding 18% would
  // overstate them.
  if (doc.purchaseId != null) {
    var sum = 0;
    for (final l in doc.lines) {
      sum += (l.qty * l.price).round();
    }
    return sum;
  }
  return docTotals(doc.lines).total;
}

/// Still owed on a document; never negative.
int docBalance(AccountingDocument doc) {
  if (doc.status == DocStatus.paid) return 0;
  final left = docGrandTotal(doc) - doc.amountPaid;
  return left < 0 ? 0 : left;
}

/// Sent, part-paid or overdue documents with money still owed.
bool docIsOpen(AccountingDocument doc) =>
    !doc.isLegacyPurchaseBill &&
    (doc.status == DocStatus.sent ||
        doc.status == DocStatus.partiallyPaid ||
        doc.status == DocStatus.overdue) &&
    docBalance(doc) > 0;

/// Whether a bill can take a payment. Drafts cannot: a purchase still waiting
/// for approval owes nothing yet, and declining it deletes the bill.
bool billCanBePaid(AccountingDocument doc) =>
    doc.status != DocStatus.paid && doc.status != DocStatus.draft;

/// [doc] with [amountPaid] taken from its payment records: what was paid
/// upfront plus every synced payment. The cached field on the document can
/// lag when two devices pay offline, so the larger of the two wins.
AccountingDocument withPaymentsApplied(
  AccountingDocument doc,
  int paymentsTotal,
) {
  final derived = doc.paidUpfront + paymentsTotal;
  return derived > doc.amountPaid ? doc.copyWith(amountPaid: derived) : doc;
}

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
