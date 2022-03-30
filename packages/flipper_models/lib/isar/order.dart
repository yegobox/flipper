import 'package:isar/isar.dart';

import 'order_item.dart';

part 'order.g.dart';

@Collection()
class OrderFSync {
  late int id = Isar.autoIncrement;
  late String reference;
  late String orderNumber;
  late int branchId;
  late String status;
  late String orderType;
  late bool active;
  late bool draft;
  late double subTotal;
  late String paymentType;
  late double cashReceived;
  late double customerChangeDue;
  late String createdAt;
  String? updatedAt;
  bool? reported;

  int? customerId;

  String? note;
  final orderItems = IsarLinks<OrderItemSync>();
}
