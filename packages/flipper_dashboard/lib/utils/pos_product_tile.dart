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
/// editor's colour picker writes it). Accepts `RRGGBB` or `AARRGGBB` with an
/// optional single leading `#`, and nothing else: [HexColor] strips every `#`
/// and defers to `int.parse`, which happily accepts `-12345` and `+abcde` and
/// then throws on the rest — either a garbage colour or a crashed catalog.
Color? posParseTileColor(String? hex) {
  final raw = hex?.trim();
  if (raw == null || raw.isEmpty) return null;
  final match = _hexColorPattern.firstMatch(raw);
  if (match == null) return null;
  final digits = match.group(1)!;
  final value = int.parse(digits, radix: 16);
  return Color(digits.length == 6 ? 0xFF000000 | value : value);
}

final RegExp _hexColorPattern = RegExp(r'^#?([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$');

/// Readable ink for text drawn on [background].
///
/// Picks whichever of [PosTokens.ink1] / white has the better WCAG contrast
/// once [background] is composited over the card surface — a customer may
/// pick a pale colour, and an `AARRGGBB` value may be translucent or fully
/// transparent, where the tile really shows the surface underneath.
Color posInkOn(Color background, {Color surface = PosTokens.surface}) {
  final composited = Color.alphaBlend(background, surface);
  return _contrast(PosTokens.ink1, composited) >=
          _contrast(Colors.white, composited)
      ? PosTokens.ink1
      : Colors.white;
}

/// WCAG relative-contrast ratio between two opaque colours.
double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final lighter = la > lb ? la : lb;
  final darker = la > lb ? lb : la;
  return (lighter + 0.05) / (darker + 0.05);
}

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
