import 'package:flipper_web/modules/accounting/data/accounting_models.dart';

/// Derive AR aging rows from open loan/credit sales in raw transaction maps.
List<AgingRow> deriveArAging(List<Map<String, dynamic>> transactions) {
  final now = DateTime.now();
  final rows = <AgingRow>[];

  for (final t in transactions) {
    final isLoan = t['is_loan'] == true || t['isLoan'] == true;
    if (!isLoan) continue;
    if (t['status'] != 'COMPLETE') continue;

    final remaining = _int(t['remaining_balance'] ?? t['remainingBalance']);
    final amount = remaining > 0
        ? remaining
        : _int(t['sub_total'] ?? t['subTotal']);
    if (amount <= 0) continue;

    final created = _parseDate(t['created_at'] ?? t['createdAt']) ?? now;
    final days = now.difference(created).inDays;
    final name = (t['customer_name'] ?? t['customerName'] ?? 'Customer').toString();
    final inv = (t['receipt_number'] ?? t['receiptNumber'] ?? t['reference'] ?? t['id'])
        .toString();

    final buckets = _bucketAmount(amount, days);
    rows.add(AgingRow(
      name: name,
      inv: inv,
      current: buckets.$1,
      d30: buckets.$2,
      d60: buckets.$3,
      d90: buckets.$4,
    ));
  }

  return rows;
}

/// Derive AP aging from completed expense transactions.
List<AgingRow> deriveApAging(List<Map<String, dynamic>> transactions) {
  final now = DateTime.now();
  final rows = <AgingRow>[];

  for (final t in transactions) {
    final isExpense = t['is_expense'] == true || t['isExpense'] == true;
    if (!isExpense) continue;
    if (t['status'] != 'COMPLETE') continue;

    final amount = _int(t['sub_total'] ?? t['subTotal']);
    if (amount <= 0) continue;

    final created = _parseDate(t['created_at'] ?? t['createdAt']) ?? now;
    final days = now.difference(created).inDays;
    final name = (t['note'] ?? t['supplier_id'] ?? 'Supplier').toString();
    final inv = (t['reference'] ?? t['receipt_number'] ?? t['id']).toString();
    final buckets = _bucketAmount(amount, days);

    rows.add(AgingRow(
      name: name,
      inv: inv,
      current: buckets.$1,
      d30: buckets.$2,
      d60: buckets.$3,
      d90: buckets.$4,
    ));
  }

  return rows;
}

(int, int, int, int) _bucketAmount(int amount, int days) {
  if (days <= 0) return (amount, 0, 0, 0);
  if (days <= 30) return (0, amount, 0, 0);
  if (days <= 60) return (0, 0, amount, 0);
  return (0, 0, 0, amount);
}

int _int(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.round();
  return int.tryParse(v.toString()) ?? 0;
}

DateTime? _parseDate(dynamic raw) {
  if (raw is String) return DateTime.tryParse(raw);
  if (raw is DateTime) return raw;
  return null;
}
