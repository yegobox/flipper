import 'package:flipper_models/helpers/pending_sale_cart_cleanup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isEmptyPendingSaleCart', () {
    test('empty operator cart is deletable', () {
      expect(
        isEmptyPendingSaleCart(subTotal: 0, ticketName: null, hasItems: false),
        isTrue,
      );
      expect(
        isEmptyPendingSaleCart(subTotal: 0, ticketName: '  ', hasItems: false),
        isTrue,
      );
    });

    test('resumed ticket with items is not deletable', () {
      expect(
        isEmptyPendingSaleCart(
          subTotal: 1500,
          ticketName: 'Till · ABC123',
          hasItems: true,
        ),
        isFalse,
      );
    });

    test('cart with items but zero subTotal is not deletable', () {
      expect(
        isEmptyPendingSaleCart(subTotal: 0, ticketName: null, hasItems: true),
        isFalse,
      );
    });

    test('named ticket without items yet is not deletable', () {
      expect(
        isEmptyPendingSaleCart(
          subTotal: 0,
          ticketName: 'Walk-in',
          hasItems: false,
        ),
        isFalse,
      );
    });
  });
}
