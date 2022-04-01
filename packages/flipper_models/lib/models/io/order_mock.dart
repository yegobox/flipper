import 'order.dart';
// import 'OrderF_item.dart';

OrderF? OrderFMock = OrderF(
  id: DateTime.now().millisecondsSinceEpoch,
  reference: 'caa5cbf1-b3c3-11',
  orderNumber: 'caa5cbf1-b3c3-',
  fbranchId: 11,
  status: 'pending',
  orderType: 'local',
  active: true,
  draft: true,
  subTotal: 300,
  cashReceived: 300,
  customerChangeDue: 0.0,
  table: 'OrderFs',
  channels: ['300'],
  createdAt: DateTime.now().toIso8601String(),
  paymentType: 'Cash',
);
