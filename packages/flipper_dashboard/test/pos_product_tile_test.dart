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

    test('posAvailableStockForDisplay subtracts in-cart qty', () {
      expect(posAvailableStockForDisplay(physicalStock: 3, inCartQty: 0), 3);
      expect(posAvailableStockForDisplay(physicalStock: 3, inCartQty: 2), 1);
      expect(posAvailableStockForDisplay(physicalStock: 2, inCartQty: 3), 0);
    });
  });

  test('PosTokens match handoff surface colors', () {
    expect(PosTokens.posBg, const Color(0xFFF4F6FB));
    expect(PosTokens.blue, const Color(0xFF2563EB));
  });

  group('posParseTileColor', () {
    test('parses the hex the product editor writes', () {
      expect(posParseTileColor('#673AB7'), const Color(0xFF673AB7));
      expect(posParseTileColor('673AB7'), const Color(0xFF673AB7));
      expect(posParseTileColor('  #ff0000  '), const Color(0xFFFF0000));
      expect(posParseTileColor('#80FF0000'), const Color(0x80FF0000));
    });

    test('returns null when the customer set no colour', () {
      expect(posParseTileColor(null), isNull);
      expect(posParseTileColor(''), isNull);
      expect(posParseTileColor('   '), isNull);
      expect(posParseTileColor('#'), isNull);
    });

    test('returns null for malformed values instead of throwing', () {
      // HexColor would throw a FormatException here and take the whole
      // catalog grid down with it.
      expect(posParseTileColor('not-a-colour'), isNull);
      expect(posParseTileColor('#12345'), isNull);
      expect(posParseTileColor('#GGGGGG'), isNull);
      expect(posParseTileColor('red'), isNull);
    });

    test('rejects signs and embedded hashes rather than coercing them', () {
      // int.parse accepts these, which produced a negative value (and so a
      // garbage colour) once OR-ed with the opaque alpha.
      expect(posParseTileColor('-12345'), isNull);
      expect(posParseTileColor('+abcde'), isNull);
      expect(posParseTileColor('1#2#3#4#5#6'), isNull);
      expect(posParseTileColor('##FF0000'), isNull);
      expect(posParseTileColor('0x123456'), isNull);
    });
  });

  group('posInkOn', () {
    test('white on dark, ink on light', () {
      expect(posInkOn(const Color(0xFF111111)), Colors.white);
      expect(posInkOn(const Color(0xFF673AB7)), Colors.white);
      expect(posInkOn(const Color(0xFFFFF176)), PosTokens.ink1);
      expect(posInkOn(const Color(0xFFFFFFFF)), PosTokens.ink1);
    });

    test('composites translucent colours over the surface it sits on', () {
      // Fully transparent: the tile really shows the white card, so white ink
      // would be invisible.
      expect(posInkOn(const Color(0x00000000)), PosTokens.ink1);
      // A wash of black over white is still light enough for dark ink.
      expect(posInkOn(const Color(0x11000000)), PosTokens.ink1);
      // Opaque black stays white-on-black.
      expect(posInkOn(const Color(0xFF000000)), Colors.white);
    });
  });
}
