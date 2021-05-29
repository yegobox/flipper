import 'order.dart';

final orderMock = new OrderF(
  id: 'caa5cbf1-b3c3-11eb-85f9-4df3cd820e94',
  reference: 'caa5cbf1-b3c3-11',
  orderNumber: 'caa5cbf1-b3c3-',
  branchId: 'caa5cbf1-b3c3-',
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
      orderId: 'caa5cbf1-b3c3-11eb-85f9-4df3cd820e94',
      id: 'id',
      price: 300,
      variantId: 'vid',
    )
  ],
  paymentType: 'Cash',
);
