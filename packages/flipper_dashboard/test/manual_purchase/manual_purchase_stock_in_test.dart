import 'package:flipper_dashboard/manual_purchase/manual_purchase_stock_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/all_models.dart';

Variant _line({String? status = '01', double qty = 5}) =>
    Variant(name: 'Rice 25kg', branchId: 'b1', pchsSttsCd: status, qty: qty);

void main() {
  group('planPurchaseLineStockIn', () {
    test('a catalog line adds to the product it was picked from', () {
      expect(
        planPurchaseLineStockIn(_line(), targetVariantId: 'v-rice'),
        PurchaseLineStockAction.addToExisting,
      );
    });

    test('a new item creates a product', () {
      expect(
        planPurchaseLineStockIn(_line()),
        PurchaseLineStockAction.createProduct,
      );
      expect(
        planPurchaseLineStockIn(_line(), targetVariantId: ''),
        PurchaseLineStockAction.createProduct,
      );
    });

    test('lines already stocked in, approved or declined never move stock '
        'again', () {
      for (final status in ['02', '03', '04']) {
        expect(
          planPurchaseLineStockIn(_line(status: status), targetVariantId: 'v'),
          PurchaseLineStockAction.skip,
          reason: status,
        );
      }
    });

    test('a waiting line without a status is still stocked in', () {
      expect(
        planPurchaseLineStockIn(_line(status: null), targetVariantId: 'v'),
        PurchaseLineStockAction.addToExisting,
      );
    });

    test('nothing to add for a zero quantity', () {
      expect(
        planPurchaseLineStockIn(_line(qty: 0), targetVariantId: 'v'),
        PurchaseLineStockAction.skip,
      );
    });
  });
}
