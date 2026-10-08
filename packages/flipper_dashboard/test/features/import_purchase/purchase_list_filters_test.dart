import 'package:flipper_dashboard/features/import_purchase/purchase_list_filters.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/all_models.dart';

Purchase _purchase({
  String supplier = 'Mariko Traders',
  String tin = '101234567',
  int invoice = 14,
  List<String> items = const ['Rice 25kg'],
}) => Purchase(
  spplrTin: tin,
  spplrNm: supplier,
  spplrBhfId: '00',
  spplrInvcNo: invoice,
  rcptTyCd: 'S',
  pmtTyCd: '02',
  cfmDt: '2026-10-08 09:00:00',
  salesDt: '20261008',
  totItemCnt: items.length,
  taxblAmtA: 0,
  taxblAmtB: 200,
  taxblAmtC: 0,
  taxblAmtD: 0,
  taxRtA: 0,
  taxRtB: 18,
  taxRtC: 0,
  taxRtD: 0,
  taxAmtA: 0,
  taxAmtB: 30.51,
  taxAmtC: 0,
  taxAmtD: 0,
  totTaxblAmt: 200,
  totTaxAmt: 30.51,
  totAmt: 200,
  createdAt: DateTime(2026, 10, 8),
  variants: [for (final name in items) Variant(name: name, branchId: 'b1')],
);

void main() {
  group('purchaseMatchesQuery', () {
    final purchase = _purchase();

    test('an empty query matches everything', () {
      expect(purchaseMatchesQuery(purchase, ''), isTrue);
      expect(purchaseMatchesQuery(purchase, '   '), isTrue);
    });

    test('matches the supplier name, ignoring case', () {
      expect(purchaseMatchesQuery(purchase, 'mari'), isTrue);
      expect(purchaseMatchesQuery(purchase, 'TRADERS'), isTrue);
      expect(purchaseMatchesQuery(purchase, 'manzi'), isFalse);
    });

    test('matches the invoice number and supplier TIN', () {
      expect(purchaseMatchesQuery(purchase, '14'), isTrue);
      expect(purchaseMatchesQuery(purchase, '101234'), isTrue);
      expect(purchaseMatchesQuery(purchase, '999'), isFalse);
    });

    test('matches an item on the purchase', () {
      expect(purchaseMatchesQuery(purchase, 'rice'), isTrue);
      expect(purchaseMatchesQuery(purchase, 'sugar'), isFalse);
    });

    test('every word must match somewhere', () {
      expect(purchaseMatchesQuery(purchase, 'mariko rice'), isTrue);
      expect(purchaseMatchesQuery(purchase, 'mariko  sugar'), isFalse);
    });

    test('a purchase without lines still matches on its header', () {
      final bare = _purchase(items: const []);
      expect(purchaseMatchesQuery(bare, 'mariko'), isTrue);
      expect(purchaseMatchesQuery(bare, 'rice'), isFalse);
    });
  });
}
