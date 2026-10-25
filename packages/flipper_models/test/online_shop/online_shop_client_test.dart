import 'dart:convert';

import 'package:flipper_models/online_shop/online_order.dart';
import 'package:flipper_models/online_shop/online_shop_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  late List<http.Request> sent;

  OnlineShopClient client(int status, Object body) {
    sent = [];
    return OnlineShopClient(
      baseUrl: () async => 'https://connector.test',
      httpClient: MockClient((request) async {
        sent.add(request);
        return http.Response(jsonEncode(body), status);
      }),
    );
  }

  const shopJson = {
    'id': 'shop1',
    'branchId': 'br1',
    'businessId': 'bz1',
    'slug': 'kigali-mart',
    'enabled': true,
    'displayName': 'Kigali Mart',
    'description': null,
    'showStock': true,
    'pickup': true,
    'delivery': false,
    'momoPayCode': '12345',
  };

  test('load sends branch_id and parses the state', () async {
    final state = await client(200, {
      'shop': shopJson,
      'hiddenVariantIds': ['v1', 'v2'],
      'url': 'https://useflipper.com/shop/kigali-mart',
      'smsBridgePaired': false,
    }).load('br1');

    expect(
      sent.single.url.toString(),
      'https://connector.test/api/online-shop?branch_id=br1',
    );
    expect(sent.single.method, 'GET');
    expect(state.shop!.slug, 'kigali-mart');
    expect(state.shop!.showStock, isTrue);
    expect(state.shop!.takesMobileMoney, isTrue);
    expect(state.hiddenVariantIds, {'v1', 'v2'});
    expect(state.url, 'https://useflipper.com/shop/kigali-mart');
    expect(state.smsBridgePaired, isFalse);
  });

  test('load before the first save has no shop', () async {
    final state = await client(200, {
      'shop': null,
      'hiddenVariantIds': [],
      'url': null,
      'smsBridgePaired': true,
    }).load('br1');
    expect(state.shop, isNull);
    expect(state.url, isNull);
    expect(state.smsBridgePaired, isTrue);
  });

  test('save PUTs camelCase, omits a blank slug, nulls blank fields', () async {
    await client(200, {'shop': shopJson}).save(
      'br1',
      const OnlineShopSettings(
        slug: ' ',
        enabled: true,
        displayName: ' Kigali Mart ',
        description: '',
        momoPayCode: ' 12345 ',
        pickup: true,
      ),
    );
    final req = sent.single;
    expect(req.method, 'PUT');
    expect(req.url.path, '/api/online-shop');
    final body = jsonDecode(req.body) as Map<String, dynamic>;
    expect(body.containsKey('slug'), isFalse);
    expect(body['branchId'], 'br1');
    expect(body['displayName'], 'Kigali Mart');
    expect(body['description'], isNull);
    expect(body['momoPayCode'], '12345');
    expect(body['enabled'], isTrue);
    expect(body['delivery'], isFalse);
  });

  test('a taken slug surfaces as slugTaken', () async {
    await expectLater(
      client(409, {
        'error': 'slug_taken',
      }).save('br1', const OnlineShopSettings(slug: 'taken', displayName: 'X')),
      throwsA(
        isA<OnlineShopException>()
            .having((e) => e.slugTaken, 'slugTaken', isTrue)
            .having((e) => e.statusCode, 'statusCode', 409),
      ),
    );
  });

  test('setHidden PUTs the ids and returns the new hidden set', () async {
    final hidden = await client(200, {
      'hiddenVariantIds': ['v1', 'v3'],
    }).setHidden(branchId: 'br1', variantIds: ['v3'], hidden: true);
    expect(sent.single.url.path, '/api/online-shop/hidden');
    expect(jsonDecode(sent.single.body), {
      'branchId': 'br1',
      'variantIds': ['v3'],
      'hidden': true,
    });
    expect(hidden, {'v1', 'v3'});
  });

  test('updateOrder PATCHes the action and parses the order', () async {
    final order =
        await client(200, {
          'id': 'o1',
          'branchId': 'br1',
          'orderNumber': 7,
          'status': 'accepted',
          'paymentStatus': 'paid',
          'items': [],
        }).updateOrder(
          branchId: 'br1',
          orderId: 'o1',
          action: OnlineOrderAction.confirmPayment,
          smsId: 'sms9',
        );
    expect(sent.single.method, 'PATCH');
    expect(sent.single.url.path, '/api/online-orders/o1');
    expect(jsonDecode(sent.single.body), {
      'branchId': 'br1',
      'action': 'confirm_payment',
      'smsId': 'sms9',
    });
    expect(order.status, OnlineOrderStatus.accepted);
    expect(order.isPaid, isTrue);
  });

  test('a 409 transition is a conflict', () async {
    await expectLater(
      client(409, {'error': 'invalid_transition'}).updateOrder(
        branchId: 'br1',
        orderId: 'o1',
        action: OnlineOrderAction.ready,
      ),
      throwsA(isA<OnlineShopException>().having((e) => e.conflict, 'c', true)),
    );
  });

  test('dismissing a suggestion sends its smsId', () async {
    await client(200, {
      'id': 'o1',
      'status': 'new',
      'paymentStatus': 'unpaid',
    }).updateOrder(
      branchId: 'br1',
      orderId: 'o1',
      action: OnlineOrderAction.dismissSuggestion,
      smsId: 'sms9',
    );
    expect(jsonDecode(sent.single.body), {
      'branchId': 'br1',
      'action': 'dismiss_suggestion',
      'smsId': 'sms9',
    });
  });

  test('onlineOrderConflict reads why a 409 was refused', () {
    OnlineOrderConflict? of(String message, {int status = 409}) =>
        onlineOrderConflict(
          OnlineShopException(message, statusCode: status, code: message),
        );
    expect(
      of(
        "the order's ticket is not a completed sale yet; sell it at the till first",
      ),
      OnlineOrderConflict.sellAtTillFirst,
    );
    expect(
      of('sell the order at the till before completing it'),
      OnlineOrderConflict.sellAtTillFirst,
    );
    expect(
      of(
        'that SMS was already recorded in the Cash Book or paid another order',
      ),
      OnlineOrderConflict.smsAlreadyUsed,
    );
    expect(
      of('that SMS already paid another order'),
      OnlineOrderConflict.smsAlreadyUsed,
    );
    expect(
      of('that payment is no longer the one suggested'),
      OnlineOrderConflict.suggestionChanged,
    );
    expect(
      of('the order changed; reload it'),
      OnlineOrderConflict.orderChanged,
    );
    expect(of('order not found', status: 404), isNull);
    expect(onlineOrderConflict(StateError('x')), isNull);
  });

  test('slug helpers', () {
    expect(isValidOnlineShopSlug('kigali-mart'), isTrue);
    expect(isValidOnlineShopSlug('ab'), isFalse);
    expect(isValidOnlineShopSlug('Kigali'), isFalse);
    expect(isValidOnlineShopSlug('a' * 49), isFalse);
    expect(suggestOnlineShopSlug('  Chez Aline & Co. '), 'chez-aline-co');
  });
}
