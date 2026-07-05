import 'package:flipper_models/sync/utils/pos_catalog_search.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isLikelyCatalogBarcodeQuery', () {
    test('full barcode is barcode-like', () {
      expect(isLikelyCatalogBarcodeQuery('2180378878'), isTrue);
    });

    test('short digits and plain names are not barcode-like', () {
      expect(isLikelyCatalogBarcodeQuery('123'), isFalse);
      expect(isLikelyCatalogBarcodeQuery('pain'), isFalse);
      expect(isLikelyCatalogBarcodeQuery('coca cola'), isFalse);
    });

    test('mixed itemCd stays barcode-like', () {
      expect(isLikelyCatalogBarcodeQuery('rw1nt3x'), isTrue);
    });
  });

  group('catalog barcode DQL builders', () {
    const filterQuery =
        'SELECT * FROM variants WHERE branchId = :branchId '
        "AND name NOT IN ('Cash In')";
    const orderSuffix =
        ' ORDER BY lastTouched DESC LIMIT :limit OFFSET :offset';

    int count(String s, Pattern p) => p.allMatches(s).length;

    // Regression: the barcode query used to append ORDER BY/LIMIT twice
    // (filter query already carried the suffix), producing invalid DQL and an
    // empty grid for any full-barcode search.
    test('exact query has a single ORDER BY / LIMIT / OFFSET', () {
      final q = catalogBarcodeExactQuery(filterQuery, orderSuffix);
      expect(count(q, 'ORDER BY'), 1);
      expect(count(q, 'LIMIT'), 1);
      expect(count(q, 'OFFSET'), 1);
      expect(q, contains(":bcdExact"));
      expect(q, endsWith(orderSuffix));
      expect(count(q, '('), count(q, ')'));
    });

    // Regression: the name fallback had unbalanced parentheses
    // ("(LOWER(COALESCE(name, ''))) LIKE …)") so it always threw.
    test('name fallback has balanced parens and a single suffix', () {
      final q = catalogBarcodeNameFallbackQuery(filterQuery, orderSuffix);
      expect(count(q, '('), count(q, ')'));
      expect(count(q, 'ORDER BY'), 1);
      expect(q, contains(':searchLike'));
      expect(q, endsWith(orderSuffix));
    });

    test('exact query keeps AND-joined filters intact', () {
      final q = catalogBarcodeExactQuery(filterQuery, orderSuffix);
      expect(q, startsWith(filterQuery));
      expect(
        q,
        contains(
          "AND (LOWER(TRIM(COALESCE(bcd, ''))) = :bcdExact OR "
          "LOWER(TRIM(COALESCE(itemCd, ''))) = :bcdExact)",
        ),
      );
    });
  });
}
