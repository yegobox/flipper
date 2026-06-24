import 'package:flipper_models/models/lead.dart';

/// One row for the lead detail "items of interest" UI.
class LeadItemRow {
  final String title;
  final int quantity;
  /// Match score in 0–100 for display, or null if unknown.
  final double? matchPercent;
  final String? variantId;

  const LeadItemRow({
    required this.title,
    required this.quantity,
    this.matchPercent,
    this.variantId,
  });
}

List<LeadItemRow> parseLeadItemRows(Lead lead) {
  final extracted = lead.aiExtracted;
  final matches = extracted?['matches'];
  if (matches is List && matches.isNotEmpty) {
    final rows = <LeadItemRow>[];
    for (final e in matches) {
      if (e is! Map) continue;
      final m = Map<String, dynamic>.from(e);
      final conf = m['confidence'];
      double? pct;
      if (conf is num) {
        final x = conf.toDouble();
        pct = x <= 1.0 ? x * 100.0 : x.clamp(0, 100);
      }
      final qtyRaw = m['quantity'];
      final qty = qtyRaw is num
          ? qtyRaw.round().clamp(1, 999999)
          : int.tryParse(qtyRaw?.toString() ?? '')?.clamp(1, 999999) ?? 1;
      final title =
          (m['variantName'] ?? m['query'] ?? 'Item').toString().trim();
      if (title.isEmpty) continue;
      rows.add(
        LeadItemRow(
          title: title,
          quantity: qty,
          matchPercent: pct,
          variantId: m['variantId']?.toString(),
        ),
      );
    }
    if (rows.isNotEmpty) return rows;
  }

  if (extracted != null && extracted['items'] is List) {
    final items = (extracted['items'] as List)
        .map((e) => e.toString())
        .where((e) => e.trim().isNotEmpty)
        .toList();
    if (items.isNotEmpty) {
      return items
          .map((t) => LeadItemRow(title: t, quantity: 1, matchPercent: null))
          .toList();
    }
  }

  final raw = lead.productsInterestedIn ?? '';
  if (raw.trim().isEmpty) {
    return const [LeadItemRow(title: '—', quantity: 1)];
  }
  final parts = raw
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
  if (parts.isEmpty) {
    return const [LeadItemRow(title: '—', quantity: 1)];
  }
  return parts
      .map((t) => LeadItemRow(title: t, quantity: 1))
      .toList();
}

/// Seeds for building proforma lines from a lead.
class ProformaLineSeed {
  final String name;
  final double unitPrice;
  final int qty;
  final String? variantId;

  const ProformaLineSeed({
    required this.name,
    required this.unitPrice,
    required this.qty,
    this.variantId,
  });
}

List<ProformaLineSeed> proformaSeedsFromLead(Lead lead) {
  final matches = lead.aiExtracted?['matches'];
  if (matches is List && matches.isNotEmpty) {
    final seeds = <ProformaLineSeed>[];
    for (final e in matches) {
      if (e is! Map) continue;
      final m = Map<String, dynamic>.from(e);
      final name =
          (m['variantName'] ?? m['query'] ?? 'Item').toString().trim();
      if (name.isEmpty) continue;
      final qtyRaw = m['quantity'];
      final qty = qtyRaw is num
          ? qtyRaw.round().clamp(1, 999999)
          : int.tryParse(qtyRaw?.toString() ?? '')?.clamp(1, 999999) ?? 1;
      double unit = 0;
      final up = m['unitPrice'];
      if (up is num) {
        unit = up.toDouble();
      }
      seeds.add(
        ProformaLineSeed(
          name: name,
          unitPrice: unit,
          qty: qty,
          variantId: m['variantId']?.toString(),
        ),
      );
    }
    if (seeds.isEmpty) {
      return _fallbackSeedsFromText(lead);
    }
    _applyEstimatedTotalSplit(lead, seeds);
    return seeds;
  }
  return _fallbackSeedsFromText(lead);
}

void _applyEstimatedTotalSplit(Lead lead, List<ProformaLineSeed> seeds) {
  final total = (lead.estimatedValue ?? 0).toDouble();
  if (total <= 0) return;

  final pricedSum = seeds.fold<double>(
    0.0,
    (a, s) => a + (s.unitPrice * s.qty),
  );
  if (pricedSum > 0) {
    return;
  }

  final n = seeds.length;
  if (n == 0) return;
  final per = total / n;
  for (var i = 0; i < seeds.length; i++) {
    final s = seeds[i];
    seeds[i] = ProformaLineSeed(
      name: s.name,
      unitPrice: per / s.qty,
      qty: s.qty,
      variantId: s.variantId,
    );
  }
}

List<ProformaLineSeed> _fallbackSeedsFromText(Lead lead) {
  final raw = (lead.productsInterestedIn ?? '').trim();
  if (raw.isEmpty) {
    return [
      const ProformaLineSeed(
        name: 'Item',
        unitPrice: 0,
        qty: 1,
      ),
    ];
  }
  final names = raw
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
  if (names.isEmpty) {
    return [
      const ProformaLineSeed(
        name: 'Item',
        unitPrice: 0,
        qty: 1,
      ),
    ];
  }
  final total = (lead.estimatedValue ?? 0).toDouble();
  final per = names.isEmpty ? 0.0 : total / names.length;
  return names
      .map(
        (n) => ProformaLineSeed(
          name: n,
          unitPrice: per,
          qty: 1,
        ),
      )
      .toList();
}
