import 'dart:convert';

import 'package:flipper_models/models/lead.dart';
import 'package:supabase_models/supabase_models.dart';

/// Rank variants by overlap with lead text so the model sees a relevant slice.
List<Variant> rankVariantsForLead(List<Variant> all, Lead lead) {
  final text = [
    lead.productsInterestedIn,
    lead.notes,
  ].whereType<String>().join(' ').toLowerCase();
  final tokens = text
      .split(RegExp(r'[^a-zA-Z0-9]+'))
      .where((t) => t.length >= 2)
      .toSet();
  if (tokens.isEmpty || all.isEmpty) {
    return all.take(200).toList(growable: false);
  }

  final scored = <({Variant v, int score})>[];
  for (final v in all) {
    var score = 0;
    final n = v.name.toLowerCase();
    for (final t in tokens) {
      if (n.contains(t)) score += 3;
      final sku = v.sku?.toLowerCase();
      if (sku != null && sku.contains(t)) score += 5;
      final bcd = v.bcd;
      if (bcd != null && bcd.contains(t)) score += 5;
    }
    scored.add((v: v, score: score));
  }
  scored.sort((a, b) => b.score.compareTo(a.score));

  final top = <Variant>[];
  final seen = <String>{};
  for (final e in scored) {
    if (e.score > 0 && top.length < 200) {
      top.add(e.v);
      seen.add(e.v.id);
    }
  }
  if (top.length >= 20) return top;

  for (final e in scored) {
    if (top.length >= 200) break;
    if (seen.add(e.v.id)) top.add(e.v);
  }
  return top;
}

Map<String, Map<String, dynamic>> catalogueMaps(List<Variant> variants) {
  final out = <String, Map<String, dynamic>>{};
  for (final v in variants) {
    final price = v.prc ?? v.retailPrice ?? v.dftPrc;
    out[v.id] = {
      'id': v.id,
      'name': v.name,
      'sku': v.sku,
      'bcd': v.bcd,
      'unitPrice': price,
    };
  }
  return out;
}

String catalogueJsonForPrompt(List<Variant> variants) {
  final list = <Map<String, dynamic>>[];
  for (final v in variants) {
    final price = v.prc ?? v.retailPrice ?? v.dftPrc;
    list.add({
      'id': v.id,
      'name': v.name,
      'sku': v.sku,
      'bcd': v.bcd,
      'unitPrice': price,
    });
  }
  return const JsonEncoder.withIndent('  ').convert(list);
}
