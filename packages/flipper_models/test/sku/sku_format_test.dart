import 'package:flipper_models/sku/sku_format.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/sku/sku_format_test.dart
// data-connector's src/sku/format.rs applies the same rules; keep both in step.
void main() {
  group('deriveSkuPrefix', () {
    test('a valid category prefix wins', () {
      expect(deriveSkuPrefix(skuPrefix: 'BEV', categoryName: 'Food'), 'BEV');
      expect(deriveSkuPrefix(skuPrefix: 'AB12CD', categoryName: 'x'), 'AB12CD');
    });

    test('an invalid prefix falls back to the category name', () {
      for (final bad in ['bev', 'B', 'TOOLONG7', 'BE-V', '']) {
        expect(
          deriveSkuPrefix(skuPrefix: bad, categoryName: 'Drinks'),
          'DRI',
          reason: bad,
        );
      }
    });

    test('the name keeps ASCII letters and digits, first three', () {
      expect(deriveSkuPrefix(categoryName: 'Beverages'), 'BEV');
      expect(deriveSkuPrefix(categoryName: 'soft drinks'), 'SOF');
      expect(deriveSkuPrefix(categoryName: 'Café & Thé'), 'CAF');
      expect(deriveSkuPrefix(categoryName: '4x4 parts'), '4X4');
    });

    test('two characters give a two-letter prefix', () {
      expect(deriveSkuPrefix(categoryName: 'TV'), 'TV');
      expect(deriveSkuPrefix(categoryName: 'é-T-V'), 'TV');
    });

    test('fewer than two characters, or no category, give SKU', () {
      expect(deriveSkuPrefix(categoryName: 'X'), kDefaultSkuPrefix);
      expect(deriveSkuPrefix(categoryName: 'ééé'), kDefaultSkuPrefix);
      expect(deriveSkuPrefix(), kDefaultSkuPrefix);
      expect(deriveSkuPrefix(categoryName: ''), kDefaultSkuPrefix);
    });
  });

  group('formatSku', () {
    test('pads the number to five digits', () {
      expect(formatSku('BEV', 42), 'BEV-00042');
      expect(formatSku('SKU', 1), 'SKU-00001');
    });

    test('longer numbers are not truncated', () {
      expect(formatSku('BEV', 1234567), 'BEV-1234567');
    });

    test('variant index above 1 adds a two-digit suffix', () {
      expect(formatSku('BEV', 42, variantIndex: 1), 'BEV-00042');
      expect(formatSku('BEV', 42, variantIndex: 2), 'BEV-00042-02');
      expect(formatSku('BEV', 42, variantIndex: 12), 'BEV-00042-12');
    });
  });

  group('skuBase / skuVariantIndex', () {
    test('generated SKUs are recognised', () {
      expect(skuBase('BEV-00042'), 'BEV-00042');
      expect(skuBase('BEV-00042-03'), 'BEV-00042');
      expect(skuVariantIndex('BEV-00042'), 1);
      expect(skuVariantIndex('BEV-00042-03'), 3);
    });

    test('typed and legacy SKUs are not', () {
      for (final other in ['42', 'bev-00042', 'BEV-42', 'ABC', null, '']) {
        expect(skuBase(other), isNull, reason: '$other');
        expect(skuVariantIndex(other), isNull, reason: '$other');
      }
    });
  });

  group('nextVariantSku', () {
    test('the base alone counts as variant 1', () {
      expect(nextVariantSku('BEV-00042', ['BEV-00042']), 'BEV-00042-02');
    });

    test('takes one past the highest sibling suffix', () {
      expect(
        nextVariantSku('BEV-00042', [
          'BEV-00042',
          'BEV-00042-02',
          'BEV-00042-05',
          'BEV-00099-09',
          null,
        ]),
        'BEV-00042-06',
      );
    });

    test('works from any sibling of the base', () {
      expect(nextVariantSku('BEV-00042-02', ['BEV-00042-02']), 'BEV-00042-03');
    });

    test('a non-generated SKU has no suffix rule', () {
      expect(nextVariantSku('42', ['42']), isNull);
    });
  });

  group('legacySkuNumber', () {
    test('plain integers up to seven digits count', () {
      expect(legacySkuNumber('42'), 42);
      expect(legacySkuNumber(' 9999999 '), 9999999);
    });

    test('longer digit runs are barcodes and are ignored', () {
      expect(legacySkuNumber('12345678'), isNull);
      expect(legacySkuNumber('6001234567890'), isNull);
    });

    test('the PREFIX-number form counts', () {
      expect(legacySkuNumber('BEV-00063'), 63);
      expect(legacySkuNumber('BEV-00063-02'), 63);
      expect(legacySkuNumber('a1-7'), 7);
    });

    test('anything else is ignored', () {
      for (final other in ['abc', 'BEV-', '-42', 'TOOLONG7-1', null, '']) {
        expect(legacySkuNumber(other), isNull, reason: '$other');
      }
    });
  });

  test('normalizeSku trims and lower-cases', () {
    expect(normalizeSku('  BEV-00042 '), 'bev-00042');
    expect(normalizeSku(null), '');
  });
}
