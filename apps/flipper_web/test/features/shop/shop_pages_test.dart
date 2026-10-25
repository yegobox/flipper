import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/features/shop/shop_api.dart';
import 'package:flipper_web/features/shop/shop_catalog_page.dart';
import 'package:flipper_web/features/shop/shop_checkout_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flipper_web/features/shop/shop_models.dart';
import 'package:flipper_web/features/shop/shop_order_page.dart';
import 'package:flipper_web/features/shop/shop_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeApi extends ShopApi {
  _FakeApi({this.paymentStatus = 'unpaid'})
    : super(baseUrl: 'https://unused.test');

  final String paymentStatus;
  ShopOrderRequest? placed;

  @override
  Future<ShopOrderView> placeOrder(
    String slug,
    ShopOrderRequest request,
  ) async {
    placed = request;
    return ShopOrderView.fromJson({
      'id': 'o1',
      'orderNumber': 12,
      'status': 'new',
      'paymentStatus': 'unpaid',
      'paymentMethod': 'momo',
      'total': 1000,
      'amountDue': 997,
      'token': 'tok',
    });
  }

  @override
  Future<ShopCatalog> catalog(String slug) async => const ShopCatalog(
    shop: ShopInfo(
      slug: 'kigali',
      name: 'Kigali Mart',
      whatsapp: '0788000000',
      delivery: true,
      payment: ShopPayment(momo: true),
    ),
    items: [ShopItem(id: 'v1', name: 'Milk 1L', price: 1000, stock: 2)],
  );

  @override
  Future<ShopOrderView> order(String slug, String id, String token) async =>
      ShopOrderView.fromJson({
        'id': id,
        'orderNumber': 12,
        'status': 'new',
        'paymentStatus': paymentStatus,
        'paymentMethod': 'momo',
        'total': 5000,
        'amountDue': 4997,
        'currency': 'RWF',
        'items': [],
        'pay': {'momoNumber': '0788111111', 'ussd': '*182*8*1*12345*4997#'},
      });
}

Future<void> _pump(WidgetTester tester, Widget page, ShopApi api) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [shopApiProvider.overrideWithValue(api)],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
        supportedLocales: FlipperAppLocalizations.supportedLocales,
        home: page,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('catalog: add to cart up to the stock shown', (tester) async {
    await _pump(tester, const ShopCatalogPage(slug: 'kigali'), _FakeApi());
    expect(find.text('Kigali Mart'), findsOneWidget);
    expect(find.text('2 left'), findsOneWidget);
    expect(find.byKey(const Key('shop_view_cart')), findsNothing);

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('View cart · 2 · 2,000 RWF'), findsOneWidget);
    // At the stock cap the plus button is disabled.
    final plus = tester.widget<IconButton>(
      find.ancestor(
        of: find.byIcon(Icons.add),
        matching: find.byType(IconButton),
      ),
    );
    expect(plus.onPressed, isNull);
  });

  testWidgets('order: dial code, exact amount and alternatives', (
    tester,
  ) async {
    await _pump(
      tester,
      ShopOrderPage(
        slug: 'kigali',
        orderId: 'o1',
        token: 't',
        now: () => DateTime.utc(2026, 10, 25, 9),
      ),
      _FakeApi(),
    );
    expect(find.text('*182*8*1*12345*4997#'), findsOneWidget);
    expect(find.text('Pay exactly 4,997 RWF'), findsOneWidget);
    expect(find.text('MoMo: 0788111111'), findsOneWidget);
    expect(find.byKey(const Key('shop_claim')), findsNothing);
    expect(find.byKey(const Key('shop_whatsapp')), findsOneWidget);
    // Stop the 15 s poll so the test ends cleanly.
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('order: needs_review shows the transaction id field', (
    tester,
  ) async {
    await _pump(
      tester,
      const ShopOrderPage(slug: 'kigali', orderId: 'o1', token: 't'),
      _FakeApi(paymentStatus: 'needs_review'),
    );
    expect(find.byKey(const Key('shop_claim')), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('checkout: validates, then places the order once', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'shop_cart_kigali': '{"v1": 1}'});
    final api = _FakeApi();
    final router = GoRouter(
      initialLocation: '/shop/kigali/checkout',
      routes: [
        GoRoute(
          path: '/shop/kigali/checkout',
          builder: (_, __) => const ShopCheckoutPage(slug: 'kigali'),
        ),
        GoRoute(
          path: '/shop/kigali/order/o1',
          builder: (_, s) => Text('order ${s.uri.queryParameters['t']}'),
        ),
      ],
    );
    tester.view.physicalSize = const Size(1080, 3600);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
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
    expect(find.byKey(const Key('shop_checkout_total')), findsOneWidget);
    expect(find.text('1,000 RWF'), findsWidgets);

    await tester.tap(find.byKey(const Key('shop_place_order')));
    await tester.pumpAndSettle();
    expect(find.text('Enter your name'), findsOneWidget);
    expect(find.text('Choose pick up or delivery'), findsOneWidget);
    expect(api.placed, isNull);

    await tester.enterText(find.byKey(const Key('shop_name')), 'Aline');
    await tester.enterText(find.byKey(const Key('shop_phone')), '0788123456');
    await tester.tap(find.text('Pick up'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('shop_place_order')));
    await tester.pumpAndSettle();

    expect(api.placed!.customerName, 'Aline');
    expect(api.placed!.payerPhone, '0788123456');
    expect(api.placed!.items.single.variantId, 'v1');
    expect(find.text('order tok'), findsOneWidget);
  });
}
