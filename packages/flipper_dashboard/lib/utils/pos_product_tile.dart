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

/// The colour a customer picked for a product, or null when they picked none.
///
/// Stored as a hex string on `Variant.color` / `Product.color` (the product
/// editor's colour picker writes it). Returns null for empty, whitespace and
/// malformed values — [HexColor] itself throws on those — so callers can fall
/// back to the neutral tile instead of crashing the catalog on bad data.
Color? posParseTileColor(String? hex) {
  final raw = hex?.trim().replaceAll('#', '');
  if (raw == null || raw.isEmpty) return null;
  if (raw.length != 6 && raw.length != 8) return null;
  final value = int.tryParse(raw, radix: 16);
  if (value == null) return null;
  return Color(raw.length == 6 ? 0xFF000000 | value : value);
}

/// Readable ink for text drawn on [background].
Color posInkOn(Color background) =>
    background.computeLuminance() > 0.55 ? PosTokens.ink1 : Colors.white;

/// First ~3 letters (letters/spaces only), matching handoff [abbr].
String posTileAbbr(String name) {
  final cleaned = name.replaceAll(RegExp(r'[^A-Za-z ]'), '');
  if (cleaned.isNotEmpty) {
    return cleaned.length > 3 ? cleaned.substring(0, 3) : cleaned;
  }
  return name.length > 3 ? name.substring(0, 3) : name;
}

/// Sellable qty for POS tiles: on-hand minus lines already on the pending cart.
int posAvailableStockForDisplay({
  required num physicalStock,
  required int inCartQty,
}) {
  final available = physicalStock.floor().toInt() - inCartQty;
  return available < 0 ? 0 : available;
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
      final n = currentStock is int ? currentStock : currentStock.floor();
      return '$n in stock';
  }
}
