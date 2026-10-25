import 'dart:convert';

import 'package:flipper_web/features/shop/shop_api.dart';
import 'package:flipper_web/features/shop/shop_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _catalog = {
  'shop': {
    'slug': 'kigali-mart',
    'name': 'Kigali Mart',
    'description': 'Fresh every day',
    'logoUrl': null,
    'contactPhone': '0788000000',
    'whatsapp': '+250 788 000 000',
    'pickup': true,
    'delivery': true,
    'deliveryNote': 'Kicukiro only',
    'currency': 'RWF',
    'payment': {
      'momo': true,
      'momoPayCode': '12345',
      'momoNumber': null,
      'airtelNumber': '0730000000',
    },
  },
  'categories': [
    {'id': 'c1', 'name': 'Dairy'},
  ],
  'items': [
    {
      'id': 'v1',
      'name': 'Milk 1L',
      'price': 1000,
      'imageUrl': 'https://img.test/milk.png',
      'categoryId': 'c1',
      'categoryName': 'Dairy',
      'inStock': true,
      'stock': 4,
    },
    {
      'id': 'v2',
      'name': 'Bread',
      'price': 1500.5,
      'inStock': false,
      'stock': null,
    },
  ],
};

const _order = {
  'id': 'o1',
  'orderNumber': 12,
  'status': 'new',
  'paymentStatus': 'unpaid',
  'paymentMethod': 'momo',
  'total': 5000,
  'amountDue': 4997,
  'currency': 'RWF',
  'payBy': '2026-10-25T10:00:00Z',
  'fulfilment': 'pickup',
  'createdAt': '2026-10-25T09:00:00Z',
  'claimPending': false,
  'items': [
    {
      'variantId': 'v1',
      'name': 'Milk 1L',
      'qty': 5,
      'unitPrice': 1000,
      'lineTotal': 5000,
    },
  ],
  'pay': {
    'momoPayCode': '12345',
    'momoNumber': null,
    'airtelNumber': '0730000000',
    'ussd': '*182*8*1*12345*4997#',
  },
  'token': 'tok',
};

void main() {
  late List<http.Request> sent;

  ShopApi api(int status, Object body) {
    sent = [];
    return ShopApi(
      baseUrl: 'https://connector.test',
      client: MockClient((request) async {
        sent.add(request);
        return http.Response(jsonEncode(body), status);
      }),
    );
  }

  test('catalog parses the shop, categories and items', () async {
    final c = await api(200, _catalog).catalog('kigali-mart');
    expect(
      sent.single.url.toString(),
      'https://connector.test/api/shop/kigali-mart',
    );
    expect(sent.single.headers.containsKey('Authorization'), isFalse);
    expect(c.shop.name, 'Kigali Mart');
    expect(c.shop.delivery, isTrue);
    expect(c.shop.payment.momo, isTrue);
    expect(c.shop.payment.airtelNumber, '0730000000');
    expect(c.categories.single.name, 'Dairy');
    expect(c.items, hasLength(2));
    expect(c.item('v1')!.maxQty, 4);
    expect(c.item('v2')!.inStock, isFalse);
    expect(c.item('v2')!.price, 1500.5);
  });

  test('an unknown or closed shop is notFound', () async {
    await expectLater(
      api(404, {'error': 'not_found'}).catalog('nope'),
      throwsA(isA<ShopApiException>().having((e) => e.notFound, 'nf', true)),
    );
  });

  test(
    'placeOrder posts the order with no auth and parses the token',
    () async {
      final order = await api(201, _order).placeOrder(
        'kigali-mart',
        const ShopOrderRequest(
          customerName: ' Aline ',
          customerPhone: '0788123456',
          fulfilment: 'pickup',
          note: '',
          payerPhone: '0788999999',
          items: [ShopOrderRequestLine(variantId: 'v1', qty: 5)],
          idempotencyKey: 'k1',
        ),
      );
      final req = sent.single;
      expect(req.method, 'POST');
      expect(req.url.path, '/api/shop/kigali-mart/orders');
      expect(req.headers.containsKey('Authorization'), isFalse);
      expect(jsonDecode(req.body), {
        'customerName': 'Aline',
        'customerPhone': '0788123456',
        'fulfilment': 'pickup',
        'payerPhone': '0788999999',
        'items': [
          {'variantId': 'v1', 'qty': 5},
        ],
        'idempotencyKey': 'k1',
      });
      expect(order.token, 'tok');
      expect(order.amountDue, 4997);
      expect(order.pay.ussd, '*182*8*1*12345*4997#');
      expect(order.pay.ussdUri.toString(), 'tel:*182*8*1*12345*4997%23');
    },
  );

  test('item_unavailable carries the variant ids', () async {
    await expectLater(
      api(409, {
        'error': 'item_unavailable',
        'variantIds': ['v2'],
      }).placeOrder(
        's',
        const ShopOrderRequest(
          customerName: 'A',
          customerPhone: '0788123456',
          fulfilment: 'pickup',
          items: [],
          idempotencyKey: 'k',
        ),
      ),
      throwsA(
        isA<ShopApiException>()
            .having((e) => e.itemUnavailable, 'unavailable', true)
            .having((e) => e.variantIds, 'ids', ['v2']),
      ),
    );
  });

  test('order and claimPayment send the token in a header', () async {
    await api(200, _order).order('kigali-mart', 'o1', 'tok');
    expect(
      sent.single.url.toString(),
      'https://connector.test/api/shop/kigali-mart/orders/o1',
    );
    expect(sent.single.headers[kShopOrderTokenHeader], 'tok');
    final o = await api(200, {..._order, 'claimPending': true}).claimPayment(
      'kigali-mart',
      'o1',
      token: 'tok',
      transactionId: ' 123456789 ',
    );
    expect(sent.single.url.path, '/api/shop/kigali-mart/orders/o1/payment');
    expect(sent.single.headers[kShopOrderTokenHeader], 'tok');
    expect(jsonDecode(sent.single.body), {'transactionId': '123456789'});
    expect(o.claimPending, isTrue);
  });

  test('the server\'s refusals are told apart by status', () {
    ShopApiException e(int status, [String? code]) =>
        ShopApiException(status, code: code);
    expect(e(413).tooLarge, isTrue);
    expect(e(503).busy, isTrue);
    expect(e(400).invalid, isTrue);
    expect(e(409, 'this checkout was already placed').alreadyPlaced, isTrue);
    expect(e(409, 'item_unavailable').alreadyPlaced, isFalse);
    final open = e(429, 'you have too many unpaid orders at this shop');
    expect(open.tooManyOpen, isTrue);
    expect(open.rateLimited, isTrue);
    expect(e(429, 'too many requests').tooManyOpen, isFalse);
    expect(e(429).tooManyOpen, isFalse);
    expect(e(500, 'x').toString(), 'ShopApiException(500, x)');
  });

  test('no answer, a timeout and a non-JSON error body', () async {
    final offline = ShopApi(
      baseUrl: 'https://connector.test/',
      client: MockClient((_) async => throw http.ClientException('down')),
    );
    await expectLater(
      offline.catalog('s'),
      throwsA(isA<ShopApiException>().having((e) => e.offline, 'off', true)),
    );
    final slow = ShopApi(
      baseUrl: 'https://connector.test',
      timeout: const Duration(milliseconds: 10),
      client: MockClient((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        return http.Response('{}', 200);
      }),
    );
    await expectLater(
      slow.catalog('s'),
      throwsA(
        isA<ShopApiException>()
            .having((e) => e.offline, 'off', true)
            .having((e) => e.code, 'code', 'timeout'),
      ),
    );
    await expectLater(
      ShopApi(
        baseUrl: 'https://connector.test',
        client: MockClient((_) async => http.Response('<html>', 502)),
      ).catalog('s'),
      throwsA(
        isA<ShopApiException>()
            .having((e) => e.statusCode, 'status', 502)
            .having((e) => e.code, 'code', isNull),
      ),
    );
    // A 2xx that is not an object reads as empty.
    final empty = await ShopApi(
      baseUrl: 'https://connector.test',
      client: MockClient((_) async => http.Response('[]', 200)),
    ).catalog('s');
    expect(empty.items, isEmpty);
  });

  test('the default base URL and client', () {
    expect(shopApiBaseUrl(), 'http://localhost:8084');
    expect(ShopApi(), isA<ShopApi>());
  });

  test('order lines send fractions only for what is sold by measure', () {
    expect(const ShopOrderRequestLine(variantId: 'v', qty: 1.5).toJson(), {
      'variantId': 'v',
      'qty': 1.5,
    });
    expect(
      const ShopOrderRequest(
        customerName: 'A',
        customerPhone: '0788123456',
        fulfilment: 'delivery',
        deliveryAddress: ' KG 11 Ave ',
        note: 'Gate 2',
        items: [],
        idempotencyKey: 'k',
      ).toJson(),
      containsPair('deliveryAddress', 'KG 11 Ave'),
    );
  });

  test('items: whole units unless sold by measure, at least 1 RWF', () {
    const count = ShopItem(id: 'a', name: 'Soap', price: 500, stock: 2.5);
    const kg = ShopItem(
      id: 'b',
      name: 'Rice',
      price: 1200,
      stock: 2.5,
      soldByMeasure: true,
    );
    expect(count.maxQty, 2);
    expect(kg.maxQty, 2.5);
    expect(const ShopItem(id: 'c', name: 'C', price: 1).maxQty, isNull);
    expect(count.allowsQty(2), isTrue);
    expect(count.allowsQty(1.5), isFalse);
    expect(count.allowsQty(0), isFalse);
    expect(count.allowsQty(double.nan), isFalse);
    expect(kg.allowsQty(1.5), isTrue);
    expect(kg.allowsQty(0.0001), isFalse);
    expect(
      ShopItem.fromJson(const {'id': 'b', 'soldByMeasure': true}).soldByMeasure,
      isTrue,
    );
  });

  group('WhatsApp link', () {
    test('a national number takes the dial code of the shop currency', () {
      expect(
        shopWhatsappDigits('0788 000 001', currency: 'RWF'),
        '250788000001',
      );
      expect(
        shopWhatsappDigits('0788000001', currency: ' rwf '),
        '250788000001',
      );
      expect(
        ShopInfo.fromJson(const {
          'slug': 's',
          'whatsapp': '0788000001',
          'currency': 'RWF',
        }).whatsappUri,
        Uri.parse('https://wa.me/250788000001'),
      );
    });

    test('an international number is kept as its digits', () {
      expect(
        shopWhatsappDigits('+250 788 000 001', currency: 'USD'),
        '250788000001',
      );
      expect(
        shopWhatsappDigits('00250788000001', currency: 'USD'),
        '250788000001',
      );
      // The server stores digits only, so `+250…` arrives as `250…`.
      expect(
        shopWhatsappDigits('250788000001', currency: 'RWF'),
        '250788000001',
      );
      expect(
        ShopCatalog.fromJson(_catalog).shop.whatsappUri,
        Uri.parse('https://wa.me/250788000000'),
      );
    });

    test('no number, or one no country can be found for, has no link', () {
      expect(shopWhatsappDigits(null, currency: 'RWF'), isNull);
      expect(shopWhatsappDigits(' - ', currency: 'RWF'), isNull);
      // USD is used by many countries: no guessing the dial code.
      expect(shopWhatsappDigits('0788000001', currency: 'USD'), isNull);
      expect(shopWhatsappDigits('0788000001', currency: 'XYZ'), isNull);
      expect(const ShopInfo(slug: 's', name: 'S').whatsappUri, isNull);
      expect(
        const ShopInfo(
          slug: 's',
          name: 'S',
          whatsapp: '0788000001',
          currency: 'EUR',
        ).whatsappUri,
        isNull,
      );
    });

    test('the dial code comes from the one country using the currency', () {
      expect(shopDialCodeForCurrency('RWF'), '250');
      expect(shopDialCodeForCurrency('KES'), '254');
      expect(shopDialCodeForCurrency('EUR'), isNull);
    });
  });

  test('a line without lineTotal is priced from qty and unit price', () {
    final o = ShopOrderView.fromJson({
      ..._order,
      'items': [
        {'variantId': 'v1', 'name': 'Milk', 'qty': 2, 'unitPrice': 1000},
      ],
    });
    expect(o.items.single.lineTotal, 2000);
  });

  group('ShopOrderView.canClaim', () {
    final payBy = DateTime.utc(2026, 10, 25, 10);
    ShopOrderView view(String paymentStatus, {String method = 'momo'}) =>
        ShopOrderView.fromJson({
          ..._order,
          'paymentStatus': paymentStatus,
          'paymentMethod': method,
        });

    test('needs_review offers the transaction id field at once', () {
      expect(
        view('needs_review').canClaim(DateTime.utc(2026, 10, 25, 9)),
        isTrue,
      );
    });

    test('unpaid only after payBy', () {
      expect(
        view('unpaid').canClaim(payBy.subtract(const Duration(minutes: 1))),
        isFalse,
      );
      expect(
        view('unpaid').canClaim(payBy.add(const Duration(minutes: 1))),
        isTrue,
      );
    });

    test('never when paid or paying on delivery', () {
      final late = payBy.add(const Duration(hours: 1));
      expect(view('paid').canClaim(late), isFalse);
      expect(view('unpaid', method: 'on_delivery').canClaim(late), isFalse);
    });
  });
}
