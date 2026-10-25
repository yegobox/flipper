import 'package:flipper_models/online_shop/online_order.dart';
import 'package:flipper_models/online_shop/online_order_ticket.dart';
import 'package:flipper_models/online_shop/online_orders_provider.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> orderDoc({
  String status = 'new',
  String paymentStatus = 'unpaid',
  Object? suggestedPayment,
  String? ticketTransactionId,
  String createdAt = '2026-10-25T09:00:00Z',
  String id = 'o1',
}) => {
  '_id': id,
  'id': id,
  'branchId': 'br1',
  'businessId': 'bz1',
  'shopId': 's1',
  'orderNumber': 12,
  'customerName': 'Aline',
  'customerPhone': '0788123456',
  'fulfilment': 'delivery',
  'deliveryAddress': 'KG 11 Ave',
  'note': 'Ring twice',
  'items': [
    {
      'variantId': 'v1',
      'name': 'Milk 1L',
      'qty': 2,
      'unitPrice': 1000,
      'lineTotal': 2000,
    },
    {'variantId': 'v2', 'name': 'Bread', 'qty': 1, 'unitPrice': 3000},
  ],
  'total': 5000,
  'amountDue': 4997,
  'currency': 'RWF',
  'paymentMethod': 'momo',
  'payerPhone': '0788999999',
  'status': status,
  'paymentStatus': paymentStatus,
  'suggestedPayment': suggestedPayment,
  'payBy': '2026-10-25T10:00:00Z',
  'ticketTransactionId': ticketTransactionId,
  'createdAt': createdAt,
  'updatedAt': createdAt,
};

void main() {
  group('OnlineOrder.fromDitto', () {
    test('reads every field of the server doc', () {
      final o = OnlineOrder.fromDitto(
        orderDoc(
          suggestedPayment: {
            'smsId': 'sms1',
            'amount': 4997,
            'counterpartyName': 'ALINE U',
            'counterpartyTail': '456',
            'observedAt': '2026-10-25T09:05:00Z',
          },
        ),
      );
      expect(o.id, 'o1');
      expect(o.orderNumber, 12);
      expect(o.isDelivery, isTrue);
      expect(o.items, hasLength(2));
      expect(o.items[0].lineTotal, 2000);
      // lineTotal missing: qty × unitPrice.
      expect(o.items[1].lineTotal, 3000);
      expect(o.total, 5000);
      expect(o.amountDue, 4997);
      expect(o.status, OnlineOrderStatus.newOrder);
      expect(o.paymentStatus, OnlineOrderPaymentStatus.unpaid);
      expect(o.suggestedPayment!.smsId, 'sms1');
      expect(o.suggestedPayment!.counterpartyTail, '456');
      expect(o.payBy, DateTime.utc(2026, 10, 25, 10));
      expect(o.ticketName, 'Online #12 – Aline');
    });

    test('tolerates junk and unknown values', () {
      final o = OnlineOrder.fromDitto({
        '_id': 'x',
        'status': 'teleported',
        'paymentStatus': 42,
        'items': 'nope',
        'suggestedPayment': {'amount': 3},
        'total': '1500',
      });
      expect(o.id, 'x');
      expect(o.status, OnlineOrderStatus.unknown);
      expect(o.paymentStatus, OnlineOrderPaymentStatus.unpaid);
      expect(o.items, isEmpty);
      expect(o.suggestedPayment, isNull);
      expect(o.total, 1500);
      expect(o.amountDue, 1500);
      expect(o.availableActions(), isEmpty);
    });

    test('parseOnlineOrders drops id-less docs and sorts newest first', () {
      final list = parseOnlineOrders([
        orderDoc(id: 'old', createdAt: '2026-10-24T09:00:00Z'),
        {'status': 'new'},
        orderDoc(id: 'new', createdAt: '2026-10-25T09:00:00Z'),
      ]);
      expect(list.map((o) => o.id), ['new', 'old']);
    });
  });

  group('availableActions', () {
    List<OnlineOrderAction> actions(
      Map<String, dynamic> doc, {
      bool ticketSold = false,
    }) => OnlineOrder.fromDitto(doc).availableActions(ticketSold: ticketSold);

    test('new: accept, reject, mark paid', () {
      expect(actions(orderDoc()), [
        OnlineOrderAction.accept,
        OnlineOrderAction.reject,
        OnlineOrderAction.markPaid,
      ]);
    });

    test('accepted: ready, reject; paid orders cannot be marked paid', () {
      expect(actions(orderDoc(status: 'accepted', paymentStatus: 'paid')), [
        OnlineOrderAction.ready,
        OnlineOrderAction.reject,
      ]);
    });

    test('ready: complete only once the linked ticket is sold', () {
      final ready = orderDoc(
        status: 'ready',
        paymentStatus: 'paid',
        ticketTransactionId: 't1',
      );
      expect(actions(ready), isEmpty);
      expect(actions(ready, ticketSold: true), [OnlineOrderAction.complete]);
      // Without a ticket there is no sale to wait for: Create ticket first.
      expect(
        actions(
          orderDoc(status: 'ready', paymentStatus: 'paid'),
          ticketSold: true,
        ),
        isEmpty,
      );
    });

    test('accepted with a sold ticket: complete, nothing else', () {
      final sold = orderDoc(status: 'accepted', ticketTransactionId: 't1');
      expect(actions(sold, ticketSold: true), [OnlineOrderAction.complete]);
      expect(actions(sold), [
        OnlineOrderAction.ready,
        OnlineOrderAction.reject,
        OnlineOrderAction.markPaid,
      ]);
    });

    test('awaitingSale while the linked ticket is not sold', () {
      OnlineOrder order(String status, {String? ticket}) =>
          OnlineOrder.fromDitto(
            orderDoc(status: status, ticketTransactionId: ticket),
          );
      expect(order('accepted', ticket: 't1').awaitingSale(), isTrue);
      expect(order('ready', ticket: 't1').awaitingSale(), isTrue);
      expect(
        order('ready', ticket: 't1').awaitingSale(ticketSold: true),
        isFalse,
      );
      expect(order('accepted').awaitingSale(), isFalse);
      expect(order('new', ticket: 't1').awaitingSale(), isFalse);
      expect(order('completed', ticket: 't1').awaitingSale(), isFalse);
    });

    test('confirm and dismiss name the suggested SMS', () {
      final order = OnlineOrder.fromDitto(
        orderDoc(
          paymentStatus: 'needs_review',
          suggestedPayment: {'smsId': 'sms1', 'amount': 4997},
        ),
      );
      expect(order.smsIdFor(OnlineOrderAction.confirmPayment), 'sms1');
      expect(order.smsIdFor(OnlineOrderAction.dismissSuggestion), 'sms1');
      expect(order.smsIdFor(OnlineOrderAction.markPaid), isNull);
      expect(
        OnlineOrder.fromDitto(
          orderDoc(),
        ).smsIdFor(OnlineOrderAction.dismissSuggestion),
        isNull,
      );
    });

    test('a suggested payment offers confirm and dismiss', () {
      expect(
        actions(
          orderDoc(
            paymentStatus: 'needs_review',
            suggestedPayment: {'smsId': 's', 'amount': 4997},
          ),
        ),
        [
          OnlineOrderAction.accept,
          OnlineOrderAction.reject,
          OnlineOrderAction.confirmPayment,
          OnlineOrderAction.dismissSuggestion,
          OnlineOrderAction.markPaid,
        ],
      );
    });

    test('finished orders offer nothing', () {
      for (final s in ['completed', 'rejected', 'cancelled', 'expired']) {
        expect(actions(orderDoc(status: s)), isEmpty, reason: s);
      }
    });

    test('needsTicket only for accepted/ready orders without a ticket', () {
      expect(OnlineOrder.fromDitto(orderDoc()).needsTicket, isFalse);
      expect(
        OnlineOrder.fromDitto(orderDoc(status: 'accepted')).needsTicket,
        isTrue,
      );
      expect(
        OnlineOrder.fromDitto(
          orderDoc(status: 'accepted', ticketTransactionId: 't1'),
        ).needsTicket,
        isFalse,
      );
    });
  });

  group('sold tickets', () {
    test('openOrderTicketIds takes open orders with a ticket, sorted', () {
      final orders = [
        orderDoc(id: 'a', status: 'ready', ticketTransactionId: 't2'),
        orderDoc(id: 'b', status: 'accepted', ticketTransactionId: 't1'),
        orderDoc(id: 'c', status: 'accepted'),
        orderDoc(id: 'd', status: 'completed', ticketTransactionId: 't3'),
      ].map(OnlineOrder.fromDitto);
      expect(openOrderTicketIds(orders), ['t1', 't2']);
    });

    test('soldTicketIds keeps completed sales at the branch', () {
      expect(
        soldTicketIds([
          {'_id': 't1', 'status': 'completed', 'branchId': 'br1'},
          {'_id': 't2', 'status': 'parked', 'branchId': 'br1'},
          {'_id': 't3', 'status': 'completed', 'branchId': 'br2'},
          {'status': 'completed', 'branchId': 'br1'},
        ], branchId: 'br1'),
        {'t1'},
      );
    });
  });

  test('ticket note leads with the paid note only when paid', () {
    final unpaid = OnlineOrder.fromDitto(orderDoc());
    final paid = OnlineOrder.fromDitto(orderDoc(paymentStatus: 'paid'));
    expect(
      onlineOrderTicketNote(unpaid, paidNote: 'PAID'),
      '0788123456 · KG 11 Ave · Ring twice',
    );
    expect(
      onlineOrderTicketNote(paid, paidNote: 'PAID'),
      'PAID · 0788123456 · KG 11 Ave · Ring twice',
    );
  });
}
