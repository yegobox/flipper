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

  group('pendingSaleCartNeedsItemLookup', () {
    test('only blank zero-value carts need item lookup', () {
      expect(
        pendingSaleCartNeedsItemLookup(subTotal: 0, ticketName: null),
        isTrue,
      );
      expect(
        pendingSaleCartNeedsItemLookup(subTotal: 0, ticketName: 'Jean'),
        isFalse,
      );
      expect(
        pendingSaleCartNeedsItemLookup(subTotal: 100, ticketName: null),
        isFalse,
      );
    });
  });

  group('classifyPendingSaleCarts', () {
    test('deleteNonEmpty wipes every candidate', () {
      final plan = classifyPendingSaleCarts(
        candidates: [
          {'id': 'a', 'subTotal': 0},
          {'id': 'b', 'subTotal': 50, 'ticketName': 'Jean'},
        ],
        idsWithItems: {},
        deleteNonEmpty: true,
      );
      expect(plan.deleteIds, ['a', 'b']);
      expect(plan.reparkRows, isEmpty);
    });

    test('batches empty carts for delete and re-parks named/valued ones', () {
      final plan = classifyPendingSaleCarts(
        candidates: [
          {'id': 'empty', 'subTotal': 0},
          {'id': 'named', 'subTotal': 0, 'ticketName': 'Jean'},
          {'id': 'valued', 'subTotal': 19000},
          {'id': 'has-lines', 'subTotal': 0},
        ],
        idsWithItems: {'has-lines'},
        deleteNonEmpty: false,
      );
      expect(plan.deleteIds, ['empty']);
      expect(
        plan.reparkRows.map((r) => r['id']),
        ['named', 'valued', 'has-lines'],
      );
    });
  });
}
