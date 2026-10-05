import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_document_math.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:intl/intl.dart';
import 'package:flipper_web/modules/accounting/data/mapper/accounting_transaction_semantics.dart';

/// Derive AR aging rows from open loan/credit sales in raw transaction maps.
List<AgingRow> deriveArAging(List<Map<String, dynamic>> transactions) {
  final now = DateTime.now();
  final rows = <AgingRow>[];

  for (final t in transactions) {
    if (!isOpenReceivable(t)) continue;

    final remaining = accountingRemainingBalance(t);
    final created = _parseDate(t['created_at'] ?? t['createdAt']) ?? now;
    final days = now.difference(created).inDays;
    final name =
        (t['customer_name'] ??
                t['customerName'] ??
                FlipperL10n.current.customer)
            .toString();
    final customerId = (t['customer_id'] ?? t['customerId'])?.toString();
    final inv =
        (t['receipt_number'] ?? t['receiptNumber'] ?? t['reference'] ?? t['id'])
            .toString();

    final buckets = _bucketAmount(remaining, days);
    rows.add(
      AgingRow(
        name: name,
        inv: inv,
        partyId: (customerId != null && customerId.isNotEmpty)
            ? customerId
            : null,
        current: buckets.$1,
        d30: buckets.$2,
        d60: buckets.$3,
        d90: buckets.$4,
      ),
    );
  }

  return rows;
}

/// Derive AP aging from open (unpaid) vendor bills in raw transaction maps.
List<AgingRow> deriveApAging(List<Map<String, dynamic>> transactions) {
  final now = DateTime.now();
  final rows = <AgingRow>[];

  for (final t in transactions) {
    if (!isOpenPayable(t)) continue;

    final remaining = accountingRemainingBalance(t);
    final created = _parseDate(t['created_at'] ?? t['createdAt']) ?? now;
    final days = now.difference(created).inDays;
    final name =
        (t['note'] ?? t['supplier_id'] ?? FlipperL10n.current.booksSupplier)
            .toString();
    final supplierId = (t['supplier_id'] ?? t['supplierId'])?.toString();
    final inv = (t['reference'] ?? t['receipt_number'] ?? t['id']).toString();
    final buckets = _bucketAmount(remaining, days);

    rows.add(
      AgingRow(
        name: name,
        inv: inv,
        partyId: (supplierId != null && supplierId.isNotEmpty)
            ? supplierId
            : null,
        current: buckets.$1,
        d30: buckets.$2,
        d60: buckets.$3,
        d90: buckets.$4,
      ),
    );
  }

  return rows;
}

/// Derive AP aging from open bills (purchases on credit, cashbook credit
/// expenses, Books bills), bucketed by days past the due date: "current" is
/// not yet due.
List<AgingRow> deriveApAgingFromBills(
  List<AccountingDocument> bills, {
  DateTime? now,
}) {
  final today = now ?? DateTime.now();
  final rows = <AgingRow>[];
  for (final b in bills) {
    if (!docIsOpen(b)) continue;
    final due = _parseDisplayDate(b.due) ?? _parseDisplayDate(b.date) ?? today;
    final buckets = _bucketAmount(docBalance(b), today.difference(due).inDays);
    rows.add(
      AgingRow(
        name: b.who.isEmpty ? FlipperL10n.current.booksSupplier : b.who,
        inv: b.id,
        partyId: b.supplierId,
        current: buckets.$1,
        d30: buckets.$2,
        d60: buckets.$3,
        d90: buckets.$4,
      ),
    );
  }
  return rows;
}

DateTime? _parseDisplayDate(String raw) {
  if (raw.isEmpty) return null;
  try {
    return DateFormat('d MMM y').parseLoose(raw);
  } catch (_) {
    return null;
  }
}

(int, int, int, int) _bucketAmount(int amount, int days) {
  if (days <= 0) return (amount, 0, 0, 0);
  if (days <= 30) return (0, amount, 0, 0);
  if (days <= 60) return (0, 0, amount, 0);
  return (0, 0, 0, amount);
}

DateTime? _parseDate(dynamic raw) {
  if (raw is String) return DateTime.tryParse(raw);
  if (raw is DateTime) return raw;
  return null;
}
