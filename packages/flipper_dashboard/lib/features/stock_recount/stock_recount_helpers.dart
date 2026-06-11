import 'dart:async';

import 'package:flipper_dashboard/transaction_report_cashier_utils.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_models/brick/models/stock_recount_item.model.dart';

import 'stock_recount_tokens.dart';

final _qtyFormat = NumberFormat.decimalPattern('en_US');
final _dateFormat = DateFormat('MMM dd, yyyy');
final _timeFormat = DateFormat('HH:mm');

abstract final class StockRecountHelpers {
  static TextStyle text({
    double size = 14,
    FontWeight weight = FontWeight.w500,
    Color color = StockRecountTokens.ink1,
    bool tabular = false,
    double? letterSpacing,
  }) {
    // Platform / theme fonts only — no Google Fonts runtime fetch (see FlipperTheme).
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      fontFeatures: tabular ? const [FontFeature.tabularFigures()] : null,
    );
  }

  static String formatQty(num value) => _qtyFormat.format(value);

  static String formatSignedVariance(num value) {
    if (value == 0) return '0';
    final prefix = value > 0 ? '+' : '';
    return '$prefix${formatQty(value)}';
  }

  static String formatDateTime(DateTime dt) =>
      '${_dateFormat.format(dt.toLocal())} · ${_timeFormat.format(dt.toLocal())}';

  static String formatDate(DateTime dt) => _dateFormat.format(dt.toLocal());

  static String formatTime(DateTime dt) => _timeFormat.format(dt.toLocal());

  static String initials(String name) {
    final cleaned = name.replaceAll(RegExp(r'[^\w\s]'), ' ').trim();
    final parts = cleaned.split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final list = parts.toList();
    if (list.isEmpty) return '?';
    if (list.length == 1) {
      return list.first
          .substring(0, list.first.length.clamp(0, 2))
          .toUpperCase();
    }
    return '${list[0][0]}${list[1][0]}'.toUpperCase();
  }

  static Color swatchColor(String name) {
    var hash = 0;
    for (final code in name.codeUnits) {
      hash = code + ((hash << 5) - hash);
    }
    final index = hash.abs() % StockRecountTokens.swatchPalette.length;
    return StockRecountTokens.swatchPalette[index];
  }

  static double horizontalPadding(double width) => width <= 560 ? 16 : 20;
}

class RecountItemStats {
  const RecountItemStats({
    required this.count,
    required this.match,
    required this.over,
    required this.short,
    required this.net,
    required this.sysTot,
    required this.cntTot,
  });

  factory RecountItemStats.fromItems(List<StockRecountItem> items) {
    var match = 0;
    var over = 0;
    var short = 0;
    var net = 0.0;
    var sysTot = 0.0;
    var cntTot = 0.0;
    for (final item in items) {
      final diff = item.difference;
      if (diff == 0) {
        match++;
      } else if (diff > 0) {
        over++;
      } else {
        short++;
      }
      net += diff;
      sysTot += item.previousQuantity;
      cntTot += item.countedQuantity;
    }
    return RecountItemStats(
      count: items.length,
      match: match,
      over: over,
      short: short,
      net: net,
      sysTot: sysTot,
      cntTot: cntTot,
    );
  }

  final int count;
  final int match;
  final int over;
  final int short;
  final double net;
  final double sysTot;
  final double cntTot;
}

/// Resolves a human-readable counter name for PDF export (never raw UUID when avoidable).
abstract final class StockRecountExportContext {
  static Future<String> resolveCounterName({String? userId}) async {
    final currentId = ProxyService.box.getUserId()?.trim();
    final targetId = (userId ?? currentId)?.trim();

    final stored = ProxyService.box.getUserName()?.trim();
    if (stored != null &&
        stored.isNotEmpty &&
        !agentIdLooksLikeOpaqueTechnicalId(stored)) {
      if (targetId == null || targetId == currentId) return stored;
    }

    if (targetId != null &&
        targetId.isNotEmpty &&
        ProxyService.ditto.isReady()) {
      try {
        final access = await ProxyService.ditto
            .getUserAccess(targetId)
            .timeout(const Duration(seconds: 3));
        final name = access?['name']?.toString().trim();
        if (name != null && name.isNotEmpty) return name;
      } catch (_) {}
    }

    if (stored != null &&
        stored.isNotEmpty &&
        !agentIdLooksLikeOpaqueTechnicalId(stored)) {
      return stored;
    }

    final phone = ProxyService.box.getUserPhone()?.trim();
    if (phone != null && phone.isNotEmpty) return phone;

    if (targetId != null && !agentIdLooksLikeOpaqueTechnicalId(targetId)) {
      return cashierLabelFromAgentId(targetId);
    }

    return 'Agent';
  }

  static Future<Map<String, String>> resolveVariantSkus(
    List<StockRecountItem> items,
  ) async {
    final ids = items
        .map((i) => i.variantId)
        .where((id) => id.trim().isNotEmpty)
        .toSet()
        .toList();
    if (ids.isEmpty) return {};

    try {
      final variants = await ProxyService.strategy
          .batchGetVariantsByIds(ids)
          .timeout(const Duration(seconds: 8));
      final skus = <String, String>{};
      for (final entry in variants.entries) {
        final variant = entry.value;
        final sku = variant.sku?.trim();
        if (sku != null && sku.isNotEmpty) {
          skus[entry.key] = sku;
          continue;
        }
        final code = variant.itemCd?.trim() ?? variant.bcd?.trim();
        if (code != null && code.isNotEmpty) skus[entry.key] = code;
      }
      return skus;
    } catch (_) {
      return {};
    }
  }
}
