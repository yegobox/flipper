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

  test('order reads with the token; claimPayment posts the txn id', () async {
    await api(200, _order).order('kigali-mart', 'o1', 'tok');
    expect(
      sent.single.url.toString(),
      'https://connector.test/api/shop/kigali-mart/orders/o1?t=tok',
    );
    final o = await api(200, {..._order, 'claimPending': true}).claimPayment(
      'kigali-mart',
      'o1',
      token: 'tok',
      transactionId: ' 123456789 ',
    );
    expect(sent.single.url.path, '/api/shop/kigali-mart/orders/o1/payment');
    expect(jsonDecode(sent.single.body), {
      'token': 'tok',
      'transactionId': '123456789',
    });
    expect(o.claimPending, isTrue);
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
