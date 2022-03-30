import 'order.dart';

// ignore: unnecessary_new
OrderFSync? orderMock = OrderFSync()
  ..id = DateTime.now().millisecondsSinceEpoch
  ..reference = 'caa5cbf1-b3c3-11'
  ..orderNumber = 'caa5cbf1-b3c3-'
  ..branchId = 11
  ..status = 'pending'
  ..orderType = 'local'
  ..active = true
  ..draft = true
  ..subTotal = 300
  ..cashReceived = 300
  ..customerChangeDue = 0.0
  ..createdAt = DateTime.now().toIso8601String()
  ..paymentType = 'Cash';
