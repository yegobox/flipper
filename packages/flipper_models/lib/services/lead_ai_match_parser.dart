import 'dart:convert';

/// Strips model reasoning wrappers and markdown fences, then decodes a JSON object.
Map<String, dynamic>? decodeLeadAiJsonObject(String raw) {
  var s = raw.trim();
  s = s.replaceAll(
    RegExp(
      r'\{\{REASONING\}\}[\s\S]*?\{\{/REASONING\}\}',
      multiLine: true,
    ),
    '',
  ).trim();

  final fence = RegExp(
    r'```(?:json)?\s*([\s\S]*?)```',
    caseSensitive: false,
  ).firstMatch(s);
  if (fence != null) {
    s = fence.group(1)!.trim();
  }

  final start = s.indexOf('{');
  final end = s.lastIndexOf('}');
  if (start < 0 || end <= start) return null;

  try {
    final decoded = jsonDecode(s.substring(start, end + 1));
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
  } catch (_) {
    return null;
  }
  return null;
}

/// Normalizes confidence to 0..1 when possible.
double? normalizeConfidence(dynamic v) {
  if (v == null) return null;
  if (v is num) {
    final x = v.toDouble();
    if (x > 1.0 && x <= 100.0) return x / 100.0;
    if (x >= 0 && x <= 1.0) return x;
    if (x > 100) return 1.0;
    if (x < 0) return 0.0;
    return x;
  }
  return null;
}

/// Builds [aiExtracted] and overall [aiConfidence] from model JSON + catalogue.
({Map<String, dynamic> extracted, num? confidence}) buildAiExtractedFromModelJson({
  required Map<String, dynamic> modelJson,
  required Map<String, Map<String, dynamic>> catalogueById,
  required String sourceLabel,
  required String modelLabel,
}) {
  final rawMatches = modelJson['matches'];
  if (rawMatches is! List) {
    return (
      extracted: {
        'items': <String>[],
        'matches': <Map<String, dynamic>>[],
        'source': sourceLabel,
        'model': modelLabel,
        'matchedAt': DateTime.now().toUtc().toIso8601String(),
        'error': 'no_matches_array',
      },
      confidence: null,
    );
  }

  final matches = <Map<String, dynamic>>[];
  final itemLabels = <String>[];
  final confidences = <double>[];

  for (final e in rawMatches) {
    if (e is! Map) continue;
    final m = Map<String, dynamic>.from(e);
    final query = m['query']?.toString() ?? '';
    var variantId = m['variantId']?.toString();
    if (variantId != null && variantId.isEmpty) variantId = null;
    final qtyRaw = m['quantity'];
    final quantity = qtyRaw is num
        ? qtyRaw.round().clamp(1, 999999)
        : int.tryParse(qtyRaw?.toString() ?? '')?.clamp(1, 999999) ?? 1;
    final conf = normalizeConfidence(m['confidence']);

    Map<String, dynamic>? cat;
    if (variantId != null && catalogueById.containsKey(variantId)) {
      cat = catalogueById[variantId];
    } else {
      variantId = null;
    }

    final variantName =
        cat?['name']?.toString() ??
        m['variantName']?.toString() ??
        (query.isNotEmpty ? query : 'Item');
    final unitPrice = cat?['unitPrice'] is num
        ? (cat!['unitPrice'] as num).toDouble()
        : (m['unitPrice'] is num
              ? (m['unitPrice'] as num).toDouble()
              : null);

    final row = <String, dynamic>{
      'query': query,
      'variantId': variantId,
      'variantName': variantName,
      'sku': cat?['sku'] ?? m['sku'],
      'bcd': cat?['bcd'] ?? m['bcd'],
      'quantity': quantity,
      if (conf != null) 'confidence': conf,
      if (m['reason'] != null) 'reason': m['reason'].toString(),
      if (unitPrice != null) 'unitPrice': unitPrice,
    };

    matches.add(row);
    itemLabels.add(variantName);
    if (conf != null) confidences.add(conf);
  }

  double? overall;
  if (confidences.isNotEmpty) {
    overall = confidences.reduce((a, b) => a + b) / confidences.length;
  }

  return (
    extracted: {
      'items': itemLabels,
      'matches': matches,
      'source': sourceLabel,
      'model': modelLabel,
      'matchedAt': DateTime.now().toUtc().toIso8601String(),
    },
    confidence: overall,
  );
}
