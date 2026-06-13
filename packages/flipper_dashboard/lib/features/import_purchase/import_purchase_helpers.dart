import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_models/brick/models/all_models.dart';

import 'import_purchase_tokens.dart';

final _moneyFormat = NumberFormat('#,##0.##', 'en_US');

abstract final class ImportPurchaseHelpers {
  static TextStyle text({
    double size = 14,
    FontWeight weight = FontWeight.w600,
    Color color = ImportPurchaseTokens.ink,
    bool tabular = false,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      fontFeatures: tabular ? const [FontFeature.tabularFigures()] : null,
    );
  }

  static String formatMoney(num? value) {
    if (value == null) return '0';
    return _moneyFormat.format(value);
  }

  static String importStatusKey(Variant variant) {
    if (variant.imptItemSttsCd == '2') return 'pending';
    if (variant.imptItemSttsCd == '3') return 'approved';
    return 'rejected';
  }

  static String importStatusLabel(String key) => switch (key) {
    'pending' || 'wait' => 'Pending',
    'approved' => 'Approved',
    'rejected' => 'Rejected',
    'processing' => 'Processing',
    _ => key,
  };

  static String? importFilterCode(String? filterKey) => switch (filterKey) {
    'all' => null,
    'pending' || 'wait' => '2',
    'approved' => '3',
    'rejected' => '4',
    _ => filterKey,
  };

  static bool matchesImportFilter(Variant variant, String filterKey) {
    if (filterKey == 'all') return true;
    final code = importFilterCode(filterKey);
    if (code == '4') {
      return variant.imptItemSttsCd != '2' && variant.imptItemSttsCd != '3';
    }
    return variant.imptItemSttsCd == code;
  }

  static String purchaseStatusKey(Variant variant) {
    if (variant.pchsSttsCd == '01') return 'pending';
    if (variant.pchsSttsCd == '02' || variant.pchsSttsCd == '03') {
      return 'approved';
    }
    return 'rejected';
  }

  static String purchaseStatusLabel(String key) => switch (key) {
    'pending' || 'waiting' => 'Pending',
    'approved' => 'Approved',
    'rejected' => 'Rejected',
    'processing' => 'Processing',
    _ => key,
  };

  static String? purchaseFilterCode(String? filterKey) => switch (filterKey) {
    'all' => null,
    'pending' || 'waiting' => '01',
    'approved' => '02',
    'rejected' => '04',
    _ => filterKey,
  };

  static bool matchesPurchaseVariantFilter(Variant variant, String filterKey) {
    if (filterKey == 'all') return true;
    if (filterKey == 'approved') {
      return variant.pchsSttsCd == '02' || variant.pchsSttsCd == '03';
    }
    return variant.pchsSttsCd == purchaseFilterCode(filterKey);
  }

  static String? assignedVariantName(
    Variant importItem,
    Map<String, List<Variant>> variantMap,
  ) {
    for (final entry in variantMap.entries) {
      if (entry.value.any((v) => v.id == importItem.id)) {
        return entry.value.first.name != importItem.name ? entry.key : null;
      }
    }
    for (final entry in variantMap.entries) {
      if (entry.value.any((v) => v.id == importItem.id)) {
        final catalog = entry.value;
        if (catalog.isNotEmpty) {
          return catalog.first.name;
        }
      }
    }
    return null;
  }

  static String? catalogVariantIdForImport(
    Variant importItem,
    Map<String, List<Variant>> variantMap,
  ) {
    for (final entry in variantMap.entries) {
      if (entry.value.any((v) => v.id == importItem.id)) {
        return entry.key;
      }
    }
    return null;
  }

  static double purchaseGroupTotal(Purchase purchase) {
    final items = purchase.variants ?? [];
    return items.fold<double>(
      0,
      (sum, v) => sum + (v.supplyPrice ?? 0) * (v.stock?.currentStock ?? 0.0),
    );
  }
}
