import 'package:flipper_models/helpers/pending_sale_cart_cleanup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isEmptyPendingSaleCart', () {
    test('no line items is deletable even with stale subTotal or name', () {
      expect(
        isEmptyPendingSaleCart(subTotal: 0, ticketName: null, hasItems: false),
        isTrue,
      );
      expect(
        isEmptyPendingSaleCart(
          subTotal: 19000,
          ticketName: 'Jean',
          customerName: 'Jean',
          hasItems: false,
        ),
        isTrue,
      );
    });

    test('cart with line items is not deletable', () {
      expect(
        isEmptyPendingSaleCart(
          subTotal: 0,
          ticketName: null,
          hasItems: true,
        ),
        isFalse,
      );
      expect(
        isEmptyPendingSaleCart(
          subTotal: 1500,
          ticketName: 'Till · ABC123',
          hasItems: true,
        ),
        isFalse,
      );
    });
  });

  group('pendingSaleCartNeedsItemLookup', () {
    test('every candidate needs item lookup before re-park', () {
      expect(
        pendingSaleCartNeedsItemLookup(subTotal: 0, ticketName: null),
        isTrue,
      );
      expect(
        pendingSaleCartNeedsItemLookup(subTotal: 0, ticketName: 'Jean'),
        isTrue,
      );
      expect(
        pendingSaleCartNeedsItemLookup(subTotal: 100, ticketName: null),
        isTrue,
      );
    });
  });

  group('pendingSaleCartReparkTicketName', () {
    test('keeps existing ticketName', () {
      expect(
        pendingSaleCartReparkTicketName(
          id: 'b232f9aa-1111-2222-3333-444444444444',
          ticketName: 'Jean',
          customerName: 'Other',
        ),
        'Jean',
      );
    });

    test('falls back to customerName before inventing a till label', () {
      expect(
        pendingSaleCartReparkTicketName(
          id: 'b232f9aa-1111-2222-3333-444444444444',
          ticketName: null,
          customerName: 'Jean',
          reference: 190,
        ),
        'Jean',
      );
    });

    test('falls back to reference then short id', () {
      expect(
        pendingSaleCartReparkTicketName(
          id: 'b232f9aa-1111-2222-3333-444444444444',
          reference: 190,
        ),
        'Till · 190',
      );
      expect(
        pendingSaleCartReparkTicketName(
          id: 'b232f9aa-1111-2222-3333-444444444444',
        ),
        'Till · B232F9',
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

    test('re-parks only carts with line items; deletes stale ghosts', () {
      final plan = classifyPendingSaleCarts(
        candidates: [
          {'id': 'empty', 'subTotal': 0},
          {'id': 'named-ghost', 'subTotal': 0, 'ticketName': 'Jean'},
          {'id': 'valued-ghost', 'subTotal': 19000},
          {'id': 'customer-ghost', 'subTotal': 0, 'customerName': 'Paul'},
          {'id': 'has-lines', 'subTotal': 0},
          {'id': 'has-lines-named', 'subTotal': 500, 'ticketName': 'Jean'},
        ],
        idsWithItems: {'has-lines', 'has-lines-named'},
        deleteNonEmpty: false,
      );
      expect(
        plan.deleteIds,
        ['empty', 'named-ghost', 'valued-ghost', 'customer-ghost'],
      );
      expect(
        plan.reparkRows.map((r) => r['id']),
        ['has-lines', 'has-lines-named'],
      );
    });
  });
}
