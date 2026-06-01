import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flipper_dashboard/utils/pos_product_tile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('pos_product_tile', () {
    test('posTileColorForName is stable for same input', () {
      final a = posTileColorForName('Cellure GJS');
      final b = posTileColorForName('Cellure GJS');
      expect(a, b);
    });

    test('posTileAbbr strips non-letters', () {
      expect(posTileAbbr("Urukezo 18' nziza"), 'Uru');
    });

    test('posStockVisual uses threshold', () {
      expect(
        posStockVisual(currentStock: 0, lowStockThreshold: 10),
        PosStockVisual.out,
      );
      expect(
        posStockVisual(currentStock: 5, lowStockThreshold: 10),
        PosStockVisual.low,
      );
      expect(
        posStockVisual(currentStock: 50, lowStockThreshold: 10),
        PosStockVisual.ok,
      );
    });
  });

  test('PosTokens match handoff surface colors', () {
    expect(PosTokens.posBg, const Color(0xFFF4F6FB));
    expect(PosTokens.blue, const Color(0xFF2563EB));
  });
}
