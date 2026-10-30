/// Renders the device sales snapshot as compact, model-friendly text
/// (small models follow plain key/value + bullet lists better than raw JSON),
/// including a per-item breakdown so item questions are grounded in real data.
void writeDeviceSalesContext(
  StringBuffer b,
  Map<String, dynamic> sales,
  String currency,
) {
  String money(Object? v) {
    final s = v?.toString() ?? '';
    if (s.isEmpty) return s;
    return currency.isNotEmpty ? '$currency $s' : s;
  }

  final periodLabel = (sales['period_label'] as String?)?.trim();
  final period = (periodLabel == null || periodLabel.isEmpty)
      ? 'this period'
      : periodLabel;
  final txCount = (sales['transaction_count'] as num?) ?? 0;

  b
    ..writeln()
    ..writeln('Sales for $period (from this device):');

  if (txCount == 0) {
    b.writeln(
      '- No sales recorded for $period. If asked, say there were no sales '
      '$period (do not invent figures or items).',
    );
    return;
  }

  if (sales['total_revenue'] != null) {
    b.writeln('- Revenue: ${money(sales['total_revenue'])}');
  }
  if (sales['units_sold'] != null) {
    b.writeln('- Units sold: ${sales['units_sold']}');
  }
  b.writeln('- Transactions: $txCount');

  final items = sales['top_items'];
  if (items is List && items.isNotEmpty) {
    b.writeln('Items sold $period (name — quantity, revenue):');
    for (final raw in items) {
      if (raw is! Map) continue;
      final name = raw['name'] ?? 'Unnamed item';
      final qty = raw['qty'] ?? '?';
      final rev = money(raw['revenue']);
      b.writeln('- $name — $qty units, $rev');
    }
  } else {
    b.writeln(
      'No item-level breakdown is available for $period — if asked which '
      'items sold, say you do not have that detail on-device.',
    );
  }
}
