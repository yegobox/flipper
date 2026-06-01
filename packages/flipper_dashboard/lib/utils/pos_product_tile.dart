import 'package:flutter/material.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';

/// Harmonious tile palette — medium-dark colors for white text contrast.
const List<Color> posTileColors = [
  Color(0xFF3B6FE0),
  Color(0xFF5457D6),
  Color(0xFF7A56E8),
  Color(0xFF9A5BC4),
  Color(0xFFC2557E),
  Color(0xFFC76B45),
  Color(0xFFB5893B),
  Color(0xFF5E8C3C),
  Color(0xFF2E9E83),
  Color(0xFF2C8FB0),
  Color(0xFF5B7488),
  Color(0xFF9A6248),
];

enum PosStockVisual { ok, low, out }

int posHashIdx(String str, int mod) {
  var h = 0;
  for (var i = 0; i < str.length; i++) {
    h = (h * 31 + str.codeUnitAt(i)) >>> 0;
  }
  return h % mod;
}

Color posTileColorForName(String name) {
  if (name.isEmpty) return posTileColors.first;
  return posTileColors[posHashIdx(name, posTileColors.length)];
}

/// First ~3 letters (letters/spaces only), matching handoff [abbr].
String posTileAbbr(String name) {
  final cleaned = name.replaceAll(RegExp(r'[^A-Za-z ]'), '');
  if (cleaned.isNotEmpty) {
    return cleaned.length > 3 ? cleaned.substring(0, 3) : cleaned;
  }
  return name.length > 3 ? name.substring(0, 3) : name;
}

PosStockVisual posStockVisual({
  required num currentStock,
  required num lowStockThreshold,
}) {
  if (currentStock <= 0) return PosStockVisual.out;
  if (currentStock <= lowStockThreshold) return PosStockVisual.low;
  return PosStockVisual.ok;
}

Color posStockTextColor(PosStockVisual visual) {
  switch (visual) {
    case PosStockVisual.ok:
      return PosTokens.gainInk;
    case PosStockVisual.low:
      return PosTokens.warnAmber;
    case PosStockVisual.out:
      return PosTokens.lossInk;
  }
}

String posStockLabel(PosStockVisual visual, num currentStock) {
  switch (visual) {
    case PosStockVisual.out:
      return 'Out of stock';
    case PosStockVisual.low:
    case PosStockVisual.ok:
      final n = currentStock is int
          ? currentStock
          : currentStock.floor();
      return '$n in stock';
  }
}
