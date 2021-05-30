import 'order.dart';

final orderMock = new OrderF(
  id: DateTime.now().millisecondsSinceEpoch,
  reference: 'caa5cbf1-b3c3-11',
  orderNumber: 'caa5cbf1-b3c3-',
  branchId: 11,
  status: 'pending',
  orderType: 'local',
  active: true,
  draft: true,
  subTotal: 300,
  cashReceived: 300,
  customerChangeDue: 0.0,
  table: 'orders',
  channels: ['300'],
  createdAt: DateTime.now().toIso8601String(),
  orderItems: [
    OrderItem(
      count: 1,
      name: 'regular',
      orderId: 10,
      id: 11,
      price: 300,
      variantId: 1,
    )
  ],
  paymentType: 'Cash',
);
