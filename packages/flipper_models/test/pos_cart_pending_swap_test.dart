import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flutter_test/flutter_test.dart';

/// The pending-cart observer emits `items.first ORDER BY lastTouched DESC`, so a
/// PENDING row minted a moment ago outranks the cart the cashier is filling.
/// When replication makes that query blink empty, `_ensureNextPendingCartIfNeeded`
/// mints a second id, it wins the ordering, and adopting it re-resolved the
/// display to an empty sale — 57 scanned lines gone in one frame.
void main() {
  group('shouldAdoptEmittedPendingCart', () {
    test('refuses to replace a cart that has lines with an empty one', () {
      expect(
        shouldAdoptEmittedPendingCart(
          currentCartId: 'cart-with-57-lines',
          incomingCartId: 'freshly-minted',
          currentHasLines: true,
          incomingHasLines: false,
          completing: false,
        ),
        isFalse,
      );
    });

    test('adopts a different cart that itself has lines', () {
      // A genuine switch (resumed ticket, another cart taking over) is not the
      // failure mode and must still work.
      expect(
        shouldAdoptEmittedPendingCart(
          currentCartId: 'cart-a',
          incomingCartId: 'cart-b',
          currentHasLines: true,
          incomingHasLines: true,
          completing: false,
        ),
        isTrue,
      );
    });

    test('adopts when the cart on screen is empty', () {
      expect(
        shouldAdoptEmittedPendingCart(
          currentCartId: 'cart-a',
          incomingCartId: 'cart-b',
          currentHasLines: false,
          incomingHasLines: false,
          completing: false,
        ),
        isTrue,
      );
    });

    test('hands over after a sale, even though the sold cart has lines', () {
      // The completion path suppresses the sold id; refusing here would strand
      // the till on a cart it has already sold.
      expect(
        shouldAdoptEmittedPendingCart(
          currentCartId: 'sold-cart',
          incomingCartId: 'next-cart',
          currentHasLines: true,
          incomingHasLines: false,
          suppressedCartId: 'sold-cart',
          completing: false,
        ),
        isTrue,
      );
    });

    test('hands over while a completion is in flight', () {
      expect(
        shouldAdoptEmittedPendingCart(
          currentCartId: 'cart-a',
          incomingCartId: 'cart-b',
          currentHasLines: true,
          incomingHasLines: false,
          completing: true,
        ),
        isTrue,
      );
    });

    test('a suppressed id for some other cart does not license the swap', () {
      expect(
        shouldAdoptEmittedPendingCart(
          currentCartId: 'cart-a',
          incomingCartId: 'cart-b',
          currentHasLines: true,
          incomingHasLines: false,
          suppressedCartId: 'some-older-sale',
          completing: false,
        ),
        isFalse,
      );
    });

    test('the same id is always adopted (it is a refresh, not a swap)', () {
      expect(
        shouldAdoptEmittedPendingCart(
          currentCartId: 'cart-a',
          incomingCartId: 'cart-a',
          currentHasLines: true,
          incomingHasLines: false,
          completing: false,
        ),
        isTrue,
      );
    });

    test('adopts anything when there is no cart yet', () {
      expect(
        shouldAdoptEmittedPendingCart(
          currentCartId: '',
          incomingCartId: 'cart-a',
          currentHasLines: false,
          incomingHasLines: false,
          completing: false,
        ),
        isTrue,
      );
    });

    test('never adopts an empty id', () {
      expect(
        shouldAdoptEmittedPendingCart(
          currentCartId: 'cart-a',
          incomingCartId: '',
          currentHasLines: false,
          incomingHasLines: false,
          completing: false,
        ),
        isFalse,
      );
    });
  });
}
