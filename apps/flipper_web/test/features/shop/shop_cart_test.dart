import 'package:flipper_web/features/shop/shop_cart.dart';
import 'package:flipper_web/features/shop/shop_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _catalog = ShopCatalog(
  shop: ShopInfo(slug: 's', name: 'S'),
  items: [
    ShopItem(id: 'milk', name: 'Milk', price: 1000, stock: 3),
    ShopItem(id: 'bread', name: 'Bread', price: 1500),
    ShopItem(id: 'eggs', name: 'Eggs', price: 200, inStock: false),
  ],
);

void main() {
  group('ShopCart', () {
    test('add, remove and total', () {
      var cart = const ShopCart().add('milk').add('milk').add('bread');
      expect(cart.qty('milk'), 2);
      expect(cart.count, 3);
      expect(cart.total(_catalog), 3500);
      cart = cart.remove('bread');
      expect(cart.lines.containsKey('bread'), isFalse);
    });

    test('add stops at the stock shown', () {
      var cart = const ShopCart();
      for (var i = 0; i < 5; i++) {
        cart = cart.add('milk', max: 3);
      }
      expect(cart.qty('milk'), 3);
    });

    test('reconcile drops gone and sold-out lines and trims to stock', () {
      final cart = const ShopCart({
        'milk': 7,
        'eggs': 1,
        'gone': 2,
        'bread': 1,
      });
      final next = cart.reconcile(_catalog);
      expect(next.lines, {'milk': 3.0, 'bread': 1.0});
    });

    test('counted items stay whole; measured ones keep three decimals', () {
      final cart = const ShopCart()
          .set('soap', 2.7, max: 2.5)
          .set('rice', 1.23456, whole: false)
          .set('oil', 9, max: 2.5, whole: false);
      expect(cart.lines, {'soap': 2.0, 'rice': 1.235, 'oil': 2.5});
      expect(const ShopCart().set('soap', 0.5).isEmpty, isTrue);
      expect(const ShopCart({'rice': 1.5}).remove('rice', whole: false).lines, {
        'rice': 0.5,
      });
    });

    test('reconcile rounds a saved fraction of a counted item down', () {
      const catalog = ShopCatalog(
        shop: ShopInfo(slug: 's', name: 'S'),
        items: [
          ShopItem(id: 'soap', name: 'Soap', price: 500),
          ShopItem(id: 'rice', name: 'Rice', price: 1200, soldByMeasure: true),
        ],
      );
      expect(
        const ShopCart({'soap': 2.5, 'rice': 1.5}).reconcile(catalog).lines,
        {'soap': 2.0, 'rice': 1.5},
      );
    });

    test('without drops the listed lines', () {
      final cart = const ShopCart({'milk': 1, 'bread': 2}).without(['milk']);
      expect(cart.lines, {'bread': 2.0});
    });

    test('encode/decode round-trips and ignores junk', () {
      final cart = const ShopCart({'milk': 2, 'bread': 1});
      expect(ShopCart.decode(cart.encode()).lines, cart.lines);
      expect(ShopCart.decode('not json').isEmpty, isTrue);
      expect(ShopCart.decode('{"a": "x", "b": -1, "c": 2}').lines, {'c': 2.0});
      expect(ShopCart.decode(null).isEmpty, isTrue);
    });
  });

  group('ShopStore', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('cart and order link persist per shop', () async {
      const store = ShopStore();
      await store.saveCart('a', const ShopCart({'milk': 2}));
      expect((await store.loadCart('a')).lines, {'milk': 2.0});
      expect((await store.loadCart('b')).isEmpty, isTrue);

      await store.saveOrder('a', const ShopOrderLink(id: 'o1', token: 't'));
      final link = await store.loadOrder('a');
      expect(link!.id, 'o1');
      expect(link.token, 't');
      await store.clearOrder('a');
      expect(await store.loadOrder('a'), isNull);

      await store.saveCart('a', const ShopCart());
      expect((await store.loadCart('a')).isEmpty, isTrue);
    });
  });

  group('validateShopCheckout', () {
    Map<String, ShopCheckoutError> check({
      String name = 'Aline',
      String phone = '0788123456',
      String payer = '',
      String? fulfilment = 'pickup',
      String address = '',
      bool cartEmpty = false,
    }) => validateShopCheckout(
      name: name,
      phone: phone,
      payerPhone: payer,
      fulfilment: fulfilment,
      address: address,
      cartEmpty: cartEmpty,
    );

    test('a complete pickup order passes', () {
      expect(check(), isEmpty);
      expect(check(phone: '+250 788 123 456'), isEmpty);
    });

    test('each missing field is reported', () {
      expect(check(name: ' '), {'name': ShopCheckoutError.nameRequired});
      expect(check(phone: '12'), {'phone': ShopCheckoutError.phoneInvalid});
      expect(check(payer: 'abc'), {
        'payerPhone': ShopCheckoutError.payerPhoneInvalid,
      });
      expect(check(fulfilment: null), {
        'fulfilment': ShopCheckoutError.fulfilmentRequired,
      });
      expect(check(fulfilment: 'delivery'), {
        'address': ShopCheckoutError.addressRequired,
      });
      expect(check(cartEmpty: true), {'cart': ShopCheckoutError.cartEmpty});
    });

    test('delivery with an address passes', () {
      expect(check(fulfilment: 'delivery', address: 'KG 11 Ave'), isEmpty);
    });
  });
}
