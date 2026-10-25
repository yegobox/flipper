import 'package:flipper_dashboard/features/incoming_orders/widgets/online_orders_view.dart';
import 'package:flipper_dashboard/features/online_shop/online_shop_providers.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/online_shop/online_order.dart';
import 'package:flipper_models/online_shop/online_orders_provider.dart';
import 'package:flipper_models/online_shop/online_shop_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Records each PATCH and fails it with [error] when set.
class _FakeClient extends OnlineShopClient {
  _FakeClient() : super(baseUrl: () async => 'https://unused.test/');

  Object? error;
  final calls = <(OnlineOrderAction, String?)>[];

  @override
  Future<OnlineOrder> updateOrder({
    required String branchId,
    required String orderId,
    required OnlineOrderAction action,
    String? ticketTransactionId,
    String? smsId,
  }) async {
    calls.add((action, smsId));
    if (error != null) throw error!;
    return OnlineOrder.fromDitto({'id': orderId});
  }
}

OnlineOrder _order({
  String status = 'ready',
  String paymentStatus = 'needs_review',
  String? ticket = 't1',
}) => OnlineOrder.fromDitto({
  'id': 'o1',
  'branchId': 'br1',
  'orderNumber': 12,
  'customerName': 'Aline',
  'customerPhone': '0788123456',
  'fulfilment': 'pickup',
  'items': [
    {'variantId': 'v1', 'name': 'Milk 1L', 'qty': 1, 'unitPrice': 5000},
  ],
  'total': 5000,
  'amountDue': 4997,
  'status': status,
  'paymentStatus': paymentStatus,
  'suggestedPayment': {'smsId': 'sms1', 'amount': 4997},
  'ticketTransactionId': ticket,
});

OnlineShopException _conflict(String message) =>
    OnlineShopException(message, statusCode: 409, code: message);

Future<void> _pump(
  WidgetTester tester,
  _FakeClient client, {
  required OnlineOrder order,
  Set<String> sold = const {},
}) async {
  tester.view.physicalSize = const Size(1200, 2400);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        onlineShopClientProvider.overrideWithValue(client),
        onlineShopBranchIdProvider.overrideWithValue('br1'),
        newOnlineOrdersCountProvider.overrideWithValue(0),
        onlineOrdersProvider(
          'br1',
        ).overrideWith((ref) => Stream.value([order])),
        soldOnlineOrderTicketsProvider(
          'br1',
        ).overrideWith((ref) => Stream.value(sold)),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
        supportedLocales: FlipperAppLocalizations.supportedLocales,
        home: const Scaffold(body: OnlineOrdersView(padding: EdgeInsets.zero)),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('dismissing a suggestion sends its smsId', (tester) async {
    final client = _FakeClient();
    await _pump(tester, client, order: _order());
    await _tap(tester, 'online_order_dismiss_suggestion');
    expect(client.calls, [(OnlineOrderAction.dismissSuggestion, 'sms1')]);
  });

  testWidgets('a replaced suggestion says to check the order', (tester) async {
    final client = _FakeClient()
      ..error = _conflict('that payment is no longer the one suggested');
    await _pump(tester, client, order: _order());
    await _tap(tester, 'online_order_dismiss_suggestion');
    expect(
      find.text(
        'The suggested payment changed. Check the order and try again.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('an SMS a till already used is explained', (tester) async {
    final client = _FakeClient()
      ..error = _conflict(
        'that SMS was already recorded in the Cash Book or paid another order',
      );
    await _pump(tester, client, order: _order());
    await _tap(tester, 'online_order_confirm_payment');
    expect(client.calls, [(OnlineOrderAction.confirmPayment, 'sms1')]);
    expect(
      find.text(
        'That SMS was already recorded at a till or paid another order. '
        'Check the Cash Book.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Complete waits for the linked ticket to be sold', (
    tester,
  ) async {
    await _pump(tester, _FakeClient(), order: _order(paymentStatus: 'paid'));
    expect(find.byKey(const Key('online_order_complete')), findsNothing);
    expect(find.byKey(const Key('online_order_sell_at_till')), findsOneWidget);
  });

  testWidgets('a sale the server has not seen yet says to sell it first', (
    tester,
  ) async {
    final client = _FakeClient()
      ..error = _conflict(
        "the order's ticket is not a completed sale yet; sell it at the till first",
      );
    await _pump(
      tester,
      client,
      order: _order(paymentStatus: 'paid'),
      sold: {'t1'},
    );
    await _tap(tester, 'online_order_complete');
    expect(client.calls, [(OnlineOrderAction.complete, null)]);
    expect(
      find.text(
        "This order's ticket is not sold yet. Sell it at the till first, "
        'then complete the order.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('another till moving the order first is explained', (
    tester,
  ) async {
    final client = _FakeClient()..error = _conflict('the order changed');
    await _pump(tester, client, order: _order(status: 'new'));
    await _tap(tester, 'online_order_mark_paid');
    // Mark paid asks first.
    await tester.tap(find.widgetWithText(FilledButton, 'Confirm').last);
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Another till updated this order first. Check it and try again.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('other failures show the error', (tester) async {
    final client = _FakeClient()
      ..error = const OnlineShopException('boom', statusCode: 500);
    await _pump(tester, client, order: _order(status: 'new'));
    await _tap(tester, 'online_order_reject');
    await tester.tap(find.widgetWithText(FilledButton, 'Confirm').last);
    await tester.pumpAndSettle();
    expect(find.text('Could not update the order: boom'), findsOneWidget);
  });
}
