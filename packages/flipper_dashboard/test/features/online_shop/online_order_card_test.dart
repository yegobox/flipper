import 'package:flipper_dashboard/features/incoming_orders/widgets/online_order_card.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/online_shop/online_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

OnlineOrder _order({
  String status = 'new',
  String paymentStatus = 'unpaid',
  String paymentMethod = 'momo',
  Map<String, dynamic>? suggestion,
  String? ticket,
}) => OnlineOrder.fromDitto({
  'id': 'o1',
  'branchId': 'br1',
  'orderNumber': 12,
  'customerName': 'Aline',
  'customerPhone': '0788123456',
  'fulfilment': 'delivery',
  'deliveryAddress': 'KG 11 Ave',
  'items': [
    {
      'variantId': 'v1',
      'name': 'Milk 1L',
      'qty': 2,
      'unitPrice': 1000,
      'lineTotal': 2000,
    },
  ],
  'total': 5000,
  'amountDue': 4997,
  'currency': 'RWF',
  'paymentMethod': paymentMethod,
  'status': status,
  'paymentStatus': paymentStatus,
  'suggestedPayment': suggestion,
  'ticketTransactionId': ticket,
});

Future<List<OnlineOrderAction>> _pump(
  WidgetTester tester,
  OnlineOrder order, {
  VoidCallback? onCreateTicket,
  bool ticketSold = false,
}) async {
  tester.view.physicalSize = const Size(1200, 2400);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  final taps = <OnlineOrderAction>[];
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
      supportedLocales: FlipperAppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: OnlineOrderCard(
            order: order,
            onAction: taps.add,
            onCreateTicket: onCreateTicket,
            ticketSold: ticketSold,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return taps;
}

void main() {
  testWidgets('a new unpaid order shows totals and accept/reject', (
    tester,
  ) async {
    final taps = await _pump(tester, _order());
    expect(find.text('Order #12'), findsOneWidget);
    expect(find.textContaining('Aline'), findsOneWidget);
    expect(find.textContaining('KG 11 Ave'), findsOneWidget);
    expect(find.text('2 × Milk 1L'), findsOneWidget);
    expect(find.text('Total 5,000 RWF'), findsOneWidget);
    expect(find.text('Customer sends 4,997 RWF'), findsOneWidget);
    expect(find.byKey(const Key('online_order_pay_unpaid')), findsOneWidget);
    expect(find.byKey(const Key('online_order_suggestion')), findsNothing);

    await tester.tap(find.byKey(const Key('online_order_accept')));
    await tester.tap(find.byKey(const Key('online_order_reject')));
    await tester.tap(find.byKey(const Key('online_order_mark_paid')));
    expect(taps, [
      OnlineOrderAction.accept,
      OnlineOrderAction.reject,
      OnlineOrderAction.markPaid,
    ]);
  });

  testWidgets('a suggested payment shows the payer and confirm/dismiss', (
    tester,
  ) async {
    final taps = await _pump(
      tester,
      _order(
        paymentStatus: 'needs_review',
        suggestion: {
          'smsId': 'sms1',
          'amount': 4997,
          'counterpartyName': 'ALINE U',
          'counterpartyTail': '456',
        },
      ),
    );
    expect(find.byKey(const Key('online_order_pay_review')), findsOneWidget);
    expect(
      find.text('Possible payment: 4,997 RWF from ALINE U …456'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('online_order_confirm_payment')));
    await tester.tap(find.byKey(const Key('online_order_dismiss_suggestion')));
    expect(taps, [
      OnlineOrderAction.confirmPayment,
      OnlineOrderAction.dismissSuggestion,
    ]);
  });

  testWidgets('a paid accepted order offers Ready but not Mark paid', (
    tester,
  ) async {
    await _pump(
      tester,
      _order(status: 'accepted', paymentStatus: 'paid', ticket: 't1'),
    );
    expect(find.byKey(const Key('online_order_pay_paid')), findsOneWidget);
    expect(find.byKey(const Key('online_order_ready')), findsOneWidget);
    expect(find.byKey(const Key('online_order_mark_paid')), findsNothing);
    expect(find.byKey(const Key('online_order_create_ticket')), findsNothing);
  });

  testWidgets('a ready order waits for its ticket to be sold at the till', (
    tester,
  ) async {
    await _pump(
      tester,
      _order(status: 'ready', paymentStatus: 'paid', ticket: 't1'),
    );
    expect(
      find.text(
        'Sell Online #12 – Aline at the till, then complete the order.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('online_order_complete')), findsNothing);
  });

  testWidgets('a sold ticket offers Complete', (tester) async {
    final taps = await _pump(
      tester,
      _order(status: 'ready', paymentStatus: 'paid', ticket: 't1'),
      ticketSold: true,
    );
    expect(find.byKey(const Key('online_order_sell_at_till')), findsNothing);
    await tester.tap(find.byKey(const Key('online_order_complete')));
    expect(taps, [OnlineOrderAction.complete]);
  });

  testWidgets('an accepted order without a ticket offers Create ticket', (
    tester,
  ) async {
    var created = 0;
    await _pump(
      tester,
      _order(status: 'accepted'),
      onCreateTicket: () => created++,
    );
    await tester.tap(find.byKey(const Key('online_order_create_ticket')));
    expect(created, 1);
  });

  testWidgets('pay-on-delivery orders hide the MoMo amount', (tester) async {
    await _pump(tester, _order(paymentMethod: 'on_delivery'));
    expect(find.text('Pay on delivery'), findsOneWidget);
    expect(find.byKey(const Key('online_order_amount_due')), findsNothing);
  });

  testWidgets('a completed order has no actions', (tester) async {
    await _pump(tester, _order(status: 'completed', paymentStatus: 'paid'));
    expect(find.byType(FilledButton), findsNothing);
    expect(find.byType(OutlinedButton), findsNothing);
  });
}
