import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/shop/shop_api.dart';
import 'package:flipper_web/features/shop/shop_cart.dart';
import 'package:flipper_web/features/shop/shop_catalog_page.dart';
import 'package:flipper_web/features/shop/shop_checkout_page.dart';
import 'package:flipper_web/features/shop/shop_models.dart';
import 'package:flipper_web/features/shop/shop_order_page.dart';
import 'package:flipper_web/features/shop/shop_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _shop = ShopInfo(
  slug: 'kigali',
  name: 'Kigali Mart',
  description: 'Fresh every day',
  logoUrl: 'https://img.test/logo.png',
  contactPhone: '0788000000',
  whatsapp: '0788000001',
  delivery: true,
  deliveryNote: 'Kicukiro only',
  payment: ShopPayment(momo: true),
);

const _items = [
  ShopItem(
    id: 'milk',
    name: 'Milk 1L',
    price: 1000,
    stock: 2,
    categoryId: 'dairy',
    imageUrl: 'https://img.test/milk.png',
  ),
  ShopItem(
    id: 'rice',
    name: 'Rice',
    price: 1200,
    categoryId: 'grain',
    soldByMeasure: true,
  ),
  ShopItem(id: 'eggs', name: 'Eggs', price: 200, inStock: false),
];

Map<String, dynamic> _orderJson({
  String status = 'new',
  String paymentStatus = 'unpaid',
  String paymentMethod = 'momo',
  String? payBy,
  bool claimPending = false,
}) => {
  'id': 'o1',
  'orderNumber': 12,
  'status': status,
  'paymentStatus': paymentStatus,
  'paymentMethod': paymentMethod,
  'total': 5000,
  'amountDue': 4997,
  'currency': 'RWF',
  'payBy': payBy,
  'claimPending': claimPending,
  'items': [
    {'variantId': 'milk', 'name': 'Milk 1L', 'qty': 5, 'unitPrice': 1000},
  ],
  'pay': {
    'momoNumber': '0788111111',
    'airtelNumber': '0730000000',
    'ussd': '*182*8*1*12345*4997#',
  },
};

class _FakeApi extends ShopApi {
  _FakeApi() : super(baseUrl: 'https://unused.test');

  Object? catalogError;
  ShopCatalog catalogValue = const ShopCatalog(
    shop: _shop,
    categories: [
      ShopCategory(id: 'dairy', name: 'Dairy'),
      ShopCategory(id: 'grain', name: 'Grain'),
    ],
    items: _items,
  );

  Object? placeError;
  String? placedToken = 'server-token';
  final placed = <ShopOrderRequest>[];

  /// Answers to `order`, one per call; the last repeats.
  List<Object> orders = [ShopOrderView.fromJson(_orderJson())];
  final orderTokens = <String>[];
  int _orderCalls = 0;

  Object? claimError;
  final claims = <(String, String)>[];

  @override
  Future<ShopCatalog> catalog(String slug) async {
    if (catalogError != null) throw catalogError!;
    return catalogValue;
  }

  @override
  Future<ShopOrderView> placeOrder(
    String slug,
    ShopOrderRequest request,
  ) async {
    placed.add(request);
    if (placeError != null) throw placeError!;
    return ShopOrderView.fromJson({..._orderJson(), 'token': placedToken});
  }

  @override
  Future<ShopOrderView> order(String slug, String id, String token) async {
    orderTokens.add(token);
    final next =
        orders[_orderCalls < orders.length ? _orderCalls : orders.length - 1];
    _orderCalls++;
    if (next is ShopOrderView) return next;
    throw next;
  }

  @override
  Future<ShopOrderView> claimPayment(
    String slug,
    String id, {
    required String token,
    required String transactionId,
  }) async {
    claims.add((token, transactionId));
    if (claimError != null) throw claimError!;
    return ShopOrderView.fromJson(_orderJson(claimPending: true));
  }
}

final _launched = <String>[];

void _fakeLauncher() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/url_launcher'),
        (call) async {
          _launched.add('${(call.arguments as Map)['url']}');
          return true;
        },
      );
}

Future<void> _pumpRouter(
  WidgetTester tester,
  _FakeApi api,
  String location,
) async {
  tester.view.physicalSize = const Size(1080, 4200);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final router = GoRouter(
    initialLocation: location,
    routes: [
      GoRoute(
        path: '/shop/:slug',
        builder: (_, s) => ShopCatalogPage(slug: s.pathParameters['slug']!),
        routes: [
          GoRoute(
            path: 'checkout',
            builder: (_, s) =>
                ShopCheckoutPage(slug: s.pathParameters['slug']!),
          ),
          GoRoute(
            path: 'order/:id',
            builder: (_, s) => Text(
              'order ${s.pathParameters['id']} ${s.uri.queryParameters['t']}',
            ),
          ),
        ],
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [shopApiProvider.overrideWithValue(api)],
      child: MaterialApp.router(
        routerConfig: router,
        locale: const Locale('en'),
        localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
        supportedLocales: FlipperAppLocalizations.supportedLocales,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpOrder(
  WidgetTester tester,
  _FakeApi api, {
  String? token = 'server-token',
  DateTime Function()? now,
}) async {
  tester.view.physicalSize = const Size(1080, 4200);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [shopApiProvider.overrideWithValue(api)],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
        supportedLocales: FlipperAppLocalizations.supportedLocales,
        home: ShopOrderPage(
          slug: 'kigali',
          orderId: 'o1',
          token: token,
          now: now ?? () => DateTime.utc(2026, 10, 25, 9),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Ends the order page's poll so the test can finish.
Future<void> _unmount(WidgetTester tester) =>
    tester.pumpWidget(const SizedBox());

Future<void> _tapKey(WidgetTester tester, String key) async {
  await tester.ensureVisible(find.byKey(Key(key)));
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
}

Future<void> _fillCheckout(WidgetTester tester) async {
  await tester.enterText(find.byKey(const Key('shop_name')), 'Aline');
  await tester.enterText(find.byKey(const Key('shop_phone')), '0788123456');
  await tester.tap(find.text('Pick up'));
  await tester.pumpAndSettle();
}

void main() {
  late FlipperAppLocalizations l10n;

  setUpAll(() async {
    l10n = await FlipperAppLocalizations.delegate.load(const Locale('en'));
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    _launched.clear();
    _fakeLauncher();
  });

  group('catalog', () {
    testWidgets('header, search, categories and the open order', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({
        'shop_order_kigali': '{"id": "o1", "token": "server-token"}',
      });
      await _pumpRouter(tester, _FakeApi(), '/shop/kigali');
      expect(find.text('Fresh every day'), findsOneWidget);
      expect(find.text('Out of stock'), findsOneWidget);

      await tester.tap(find.text('Dairy'));
      await tester.pumpAndSettle();
      expect(find.text('Rice'), findsNothing);
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('shop_search')), 'ric');
      await tester.pumpAndSettle();
      expect(find.text('Milk 1L'), findsNothing);
      expect(find.text('Rice'), findsOneWidget);

      await _tapKey(tester, 'shop_open_order');
      expect(find.text('order o1 server-token'), findsOneWidget);
    });

    testWidgets('a measured item takes a typed amount', (tester) async {
      await _pumpRouter(tester, _FakeApi(), '/shop/kigali');
      final rice = find.byKey(const ValueKey('shop_item_rice'));
      await tester.tap(find.descendant(of: rice, matching: find.text('Add')));
      await tester.pumpAndSettle();
      await _tapKey(tester, 'shop_qty_edit');

      await tester.enterText(find.byKey(const Key('shop_qty_field')), 'abc');
      await _tapKey(tester, 'shop_qty_save');
      expect(find.text(l10n.shopQtyInvalid), findsOneWidget);

      await tester.enterText(find.byKey(const Key('shop_qty_field')), '1,5');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(find.text('1.5'), findsOneWidget);
      expect(find.text('View cart · 1.5 · 1,800 RWF'), findsOneWidget);

      // Cancel keeps the amount.
      await _tapKey(tester, 'shop_qty_edit');
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('1.5'), findsOneWidget);

      await tester.tap(
        find.descendant(of: rice, matching: find.byIcon(Icons.remove)),
      );
      await tester.pumpAndSettle();
      expect(find.text('0.5'), findsOneWidget);

      await _tapKey(tester, 'shop_view_cart');
      expect(find.text(l10n.shopCheckoutTitle), findsOneWidget);
    });

    testWidgets('an unknown shop and a failed load', (tester) async {
      final api = _FakeApi()..catalogError = const ShopApiException(404);
      await _pumpRouter(tester, api, '/shop/kigali');
      expect(find.text(l10n.shopNotFound), findsOneWidget);

      api.catalogError = const ShopApiException(0);
      await tester.tap(find.text(l10n.retry));
      await tester.pumpAndSettle();
      expect(find.text(l10n.shopLoadFailed), findsOneWidget);

      api.catalogError = null;
      await tester.tap(find.text(l10n.retry));
      await tester.pumpAndSettle();
      expect(find.text('Kigali Mart'), findsOneWidget);
    });
  });

  group('checkout', () {
    testWidgets('uses the token the server returned for the order link', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({
        'shop_cart_kigali': '{"milk": 1, "rice": 1.25}',
      });
      final api = _FakeApi();
      await _pumpRouter(tester, api, '/shop/kigali/checkout');
      expect(find.byKey(const Key('shop_qty_edit')), findsOneWidget);
      final milk = find.ancestor(
        of: find.text('Milk 1L'),
        matching: find.byType(Row),
      );
      await tester.tap(
        find.descendant(of: milk.first, matching: find.byIcon(Icons.add)),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(of: milk.first, matching: find.byIcon(Icons.remove)),
      );
      await tester.pumpAndSettle();
      await _fillCheckout(tester);
      // A cleared payer phone falls back to the customer's.
      await tester.enterText(find.byKey(const Key('shop_payer_phone')), '');
      await _tapKey(tester, 'shop_place_order');

      expect(api.placed.single.payerPhone, '0788123456');
      expect(api.placed.single.items.map((l) => l.qty), [1, 1.25]);

      expect(api.placed.single.idempotencyKey, isNot('server-token'));
      expect(find.text('order o1 server-token'), findsOneWidget);
      final link = await const ShopStore().loadOrder('kigali');
      expect(link!.token, 'server-token');
    });

    testWidgets('a measured line can be retyped at checkout', (tester) async {
      SharedPreferences.setMockInitialValues({
        'shop_cart_kigali': '{"rice": 1}',
      });
      await _pumpRouter(tester, _FakeApi(), '/shop/kigali/checkout');
      await _tapKey(tester, 'shop_qty_edit');
      await tester.enterText(find.byKey(const Key('shop_qty_field')), '2.5');
      await _tapKey(tester, 'shop_qty_save');
      expect(find.text('3,000 RWF'), findsWidgets);
    });

    testWidgets('an answer without a token is not followed', (tester) async {
      SharedPreferences.setMockInitialValues({
        'shop_cart_kigali': '{"milk": 1}',
      });
      final api = _FakeApi()..placedToken = null;
      await _pumpRouter(tester, api, '/shop/kigali/checkout');
      await _fillCheckout(tester);
      await _tapKey(tester, 'shop_place_order');
      expect(find.text(l10n.shopErrGeneric), findsOneWidget);
      expect(find.textContaining('order o1'), findsNothing);
    });

    testWidgets('sold-out items leave the cart; other errors are shown', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({
        'shop_cart_kigali': '{"milk": 1, "rice": 2}',
      });
      final api = _FakeApi()
        ..placeError = const ShopApiException(
          409,
          code: 'item_unavailable',
          variantIds: ['milk'],
        );
      await _pumpRouter(tester, api, '/shop/kigali/checkout');
      await _fillCheckout(tester);
      await _tapKey(tester, 'shop_place_order');
      expect(find.text(l10n.shopErrUnavailable), findsOneWidget);
      expect(find.text('Milk 1L'), findsNothing);

      api.placeError = const ShopApiException(
        429,
        code: 'you have too many unpaid orders at this shop',
      );
      await _tapKey(tester, 'shop_place_order');
      expect(find.text(l10n.shopErrTooManyOpen), findsOneWidget);
      await _tapKey(tester, 'shop_place_order');
      // The same checkout retries with the same key.
      expect(api.placed[1].idempotencyKey, api.placed[2].idempotencyKey);

      api.placeError = StateError('boom');
      await _tapKey(tester, 'shop_place_order');
      expect(find.text(l10n.shopErrGeneric), findsOneWidget);
    });

    testWidgets('delivery asks for an address; a typed payer phone sticks', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({
        'shop_cart_kigali': '{"milk": 1}',
      });
      final api = _FakeApi();
      await _pumpRouter(tester, api, '/shop/kigali/checkout');
      await tester.enterText(find.byKey(const Key('shop_name')), 'Aline');
      await tester.enterText(
        find.byKey(const Key('shop_payer_phone')),
        '0788999999',
      );
      await tester.enterText(find.byKey(const Key('shop_phone')), '0788123456');
      await tester.tap(find.text('Delivery'));
      await tester.pumpAndSettle();
      expect(find.text('Kicukiro only'), findsOneWidget);
      await _tapKey(tester, 'shop_place_order');
      expect(find.text(l10n.shopErrAddress), findsOneWidget);

      await tester.enterText(find.byKey(const Key('shop_address')), 'KG 11');
      await _tapKey(tester, 'shop_place_order');
      expect(api.placed.single.payerPhone, '0788999999');
      expect(api.placed.single.deliveryAddress, 'KG 11');
    });

    testWidgets('an empty cart, a failed load and back to the shop', (
      tester,
    ) async {
      final api = _FakeApi()..catalogError = const ShopApiException(0);
      await _pumpRouter(tester, api, '/shop/kigali/checkout');
      expect(find.text(l10n.shopLoadFailed), findsOneWidget);
      api.catalogError = null;
      await tester.tap(find.text(l10n.retry));
      await tester.pumpAndSettle();
      expect(find.text(l10n.shopCartEmpty), findsOneWidget);

      await tester.tap(find.byTooltip(l10n.shopBackToShop));
      await tester.pumpAndSettle();
      expect(find.text('Fresh every day'), findsOneWidget);
    });

    test('shopCheckoutErrorText maps each refusal', () {
      String text(int status, [String? code]) =>
          shopCheckoutErrorText(l10n, ShopApiException(status, code: code));
      expect(text(409, 'item_unavailable'), l10n.shopErrUnavailable);
      expect(text(429, 'too many unpaid orders'), l10n.shopErrTooManyOpen);
      expect(text(429, 'too many requests'), l10n.shopErrRateLimited);
      expect(text(413), l10n.shopErrTooLarge);
      expect(text(409, 'already placed'), l10n.shopErrAlreadyPlaced);
      expect(text(503), l10n.shopErrBusy);
      expect(text(400), l10n.shopErrInvalid);
      expect(text(0), l10n.shopErrOffline);
      expect(text(500), l10n.shopErrGeneric);
    });
  });

  group('order', () {
    testWidgets('pay instructions, pay-by copy and contact links', (
      tester,
    ) async {
      final api = _FakeApi()
        ..orders = [
          ShopOrderView.fromJson(
            _orderJson(payBy: DateTime.utc(2026, 10, 25, 11).toIso8601String()),
          ),
        ];
      await _pumpOrder(tester, api);
      expect(api.orderTokens.first, 'server-token');
      expect(find.text('MoMo: 0788111111'), findsOneWidget);
      expect(find.text('Airtel Money: 0730000000'), findsOneWidget);
      final payBy = tester.widget<Text>(find.byKey(const Key('shop_pay_by')));
      expect(payBy.data, startsWith('Pay by '));
      expect(payBy.data, contains('24 hours'));

      await _tapKey(tester, 'shop_pay_ussd');
      await _tapKey(tester, 'shop_whatsapp');
      await tester.tap(find.text(l10n.shopCallShop));
      await tester.pumpAndSettle();
      expect(_launched, [
        'tel:*182*8*1*12345*4997%23',
        'https://wa.me/0788000001',
        'tel:0788000000',
      ]);
      await _unmount(tester);
    });

    test('pay-by shows the date when it is not today', () {
      final order = ShopOrderView.fromJson(_orderJson(status: 'accepted'));
      final now = DateTime(2026, 10, 25, 9);
      expect(
        shopPayByText(l10n, order, DateTime(2026, 10, 25, 11, 5), now),
        'Pay by 11:05, or this order is cancelled.',
      );
      expect(
        shopPayByText(l10n, order, DateTime(2026, 10, 26, 9, 30), now),
        'Pay by Oct 26 09:30, or this order is cancelled.',
      );
    });

    testWidgets('the saved token is used when the link has none', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({
        'shop_order_kigali': '{"id": "o1", "token": "saved"}',
      });
      final api = _FakeApi();
      await _pumpOrder(tester, api, token: null);
      expect(api.orderTokens.first, 'saved');
      await _unmount(tester);
    });

    testWidgets('a paid, finished order stops and forgets the link', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({
        'shop_order_kigali': '{"id": "o1", "token": "server-token"}',
      });
      final api = _FakeApi()
        ..orders = [
          ShopOrderView.fromJson(
            _orderJson(status: 'completed', paymentStatus: 'paid'),
          ),
        ];
      await _pumpOrder(tester, api);
      expect(find.byKey(const Key('shop_paid')), findsOneWidget);
      expect(find.text(l10n.shopOrderStatusCompleted), findsOneWidget);
      expect(await const ShopStore().loadOrder('kigali'), isNull);
      await tester.pump(kShopOrderPoll * 2);
      expect(api.orderTokens, hasLength(1));
    });

    testWidgets('every status has its words', (tester) async {
      for (final status in [
        'accepted',
        'ready',
        'rejected',
        'cancelled',
        'expired',
      ]) {
        final api = _FakeApi()
          ..orders = [
            ShopOrderView.fromJson(
              _orderJson(status: status, paymentMethod: 'on_delivery'),
            ),
          ];
        await _pumpOrder(tester, api);
        expect(
          find.byKey(const Key('shop_order_status')),
          findsOneWidget,
          reason: status,
        );
        await _unmount(tester);
      }
    });

    testWidgets('pay on delivery says so', (tester) async {
      final api = _FakeApi()
        ..orders = [
          ShopOrderView.fromJson(_orderJson(paymentMethod: 'on_delivery')),
        ];
      await _pumpOrder(tester, api);
      expect(find.text(l10n.shopPayOnDelivery), findsOneWidget);
      await _unmount(tester);
    });

    testWidgets('an unknown link, a failed load, then a retry', (tester) async {
      final api = _FakeApi()
        ..orders = [
          const ShopApiException(404),
          const ShopApiException(0),
          ShopOrderView.fromJson(_orderJson()),
        ];
      await _pumpOrder(tester, api);
      expect(find.text(l10n.shopOrderNotFound), findsOneWidget);
      await tester.tap(find.text(l10n.retry));
      await tester.pumpAndSettle();
      expect(find.text(l10n.shopLoadFailed), findsOneWidget);
      await tester.tap(find.text(l10n.retry));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('shop_pay')), findsOneWidget);
      await _unmount(tester);
    });

    testWidgets('polls while visible and pauses while hidden', (tester) async {
      final api = _FakeApi();
      await _pumpOrder(tester, api);
      expect(api.orderTokens, hasLength(1));
      await tester.pump(kShopOrderPoll);
      expect(api.orderTokens, hasLength(2));

      for (final state in [
        AppLifecycleState.inactive,
        AppLifecycleState.hidden,
      ]) {
        tester.binding.handleAppLifecycleStateChanged(state);
      }
      await tester.pump(kShopOrderPoll * 2);
      expect(api.orderTokens, hasLength(2));
      for (final state in [
        AppLifecycleState.inactive,
        AppLifecycleState.resumed,
      ]) {
        tester.binding.handleAppLifecycleStateChanged(state);
      }
      await tester.pump();
      expect(api.orderTokens, hasLength(3));
      await _unmount(tester);
    });

    testWidgets('claiming a payment, with each way it can fail', (
      tester,
    ) async {
      final api = _FakeApi()
        ..orders = [
          ShopOrderView.fromJson(_orderJson(paymentStatus: 'needs_review')),
        ];
      await _pumpOrder(tester, api);
      final field = find.byKey(const Key('shop_claim_txn'));
      Future<void> send(String txn) async {
        await tester.enterText(field, txn);
        await tester.tap(find.text(l10n.shopClaimSubmit));
        await tester.pumpAndSettle();
      }

      await send('12');
      expect(find.text(l10n.shopClaimInvalid), findsOneWidget);
      expect(api.claims, isEmpty);

      api.claimError = const ShopApiException(429);
      await send('FT123456');
      expect(find.text(l10n.shopErrTooManyTries), findsOneWidget);
      expect(api.claims.single, ('server-token', 'FT123456'));

      api.claimError = null;
      await send('FT123456');
      expect(find.byKey(const Key('shop_claim_pending')), findsOneWidget);
      await _unmount(tester);
    });

    test('shopClaimErrorText maps each failure', () {
      expect(
        shopClaimErrorText(l10n, const ShopApiException(0)),
        l10n.shopErrOffline,
      );
      expect(
        shopClaimErrorText(l10n, const ShopApiException(400)),
        l10n.shopClaimInvalid,
      );
      expect(
        shopClaimErrorText(l10n, const ShopApiException(500)),
        l10n.shopErrGeneric,
      );
      expect(shopClaimErrorText(l10n, StateError('x')), l10n.shopErrGeneric);
    });

    testWidgets('back goes to the shop', (tester) async {
      final api = _FakeApi();
      tester.view.physicalSize = const Size(1080, 4200);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final router = GoRouter(
        initialLocation: '/shop/kigali/order/o1',
        routes: [
          GoRoute(
            path: '/shop/kigali',
            builder: (_, __) => const Text('the shop'),
          ),
          GoRoute(
            path: '/shop/kigali/order/o1',
            builder: (_, __) => const ShopOrderPage(
              slug: 'kigali',
              orderId: 'o1',
              token: 'server-token',
            ),
          ),
        ],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [shopApiProvider.overrideWithValue(api)],
          child: MaterialApp.router(
            routerConfig: router,
            locale: const Locale('en'),
            localizationsDelegates:
                FlipperAppLocalizations.localizationsDelegates,
            supportedLocales: FlipperAppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip(l10n.shopBackToShop));
      await tester.pumpAndSettle();
      expect(find.text('the shop'), findsOneWidget);
    });
  });

  test('the cart notifier: typed amounts, drop, reconcile and clear', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(shopCartProvider('kigali').notifier);
    notifier.setQty(_items[1], 1.75);
    notifier.add(_items[0]);
    expect(container.read(shopCartProvider('kigali')).lines, {
      'rice': 1.75,
      'milk': 1.0,
    });
    notifier.drop(['milk']);
    notifier.reconcile(
      const ShopCatalog(
        shop: _shop,
        items: [ShopItem(id: 'x', name: 'X', price: 1)],
      ),
    );
    expect(container.read(shopCartProvider('kigali')).isEmpty, isTrue);
    notifier.add(_items[0]);
    notifier.clear();
    expect(container.read(shopCartProvider('kigali')).isEmpty, isTrue);
  });
}
