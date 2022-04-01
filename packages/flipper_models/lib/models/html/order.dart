import 'dart:convert';

import 'package:isar/isar.dart';

import 'order_item.dart';

OrderF orderFromJsonSync(String str) => OrderF.fromJson(json.decode(str));

String orderToJsonSync(OrderF data) => json.encode(data.toJson());

List<OrderF> ordersFromJsonSync(String str) =>
    List<OrderF>.from(json.decode(str).map((x) => OrderF.fromJson(x)));

String orderToJson(List<OrderF> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderF {
  OrderF({
    this.id = 0,
    required this.reference,
    required this.orderNumber,
    required this.fbranchId,
    required this.status,
    required this.orderType,
    required this.active,
    required this.draft,
    required this.subTotal,
    required this.paymentType,
    required this.cashReceived,
    required this.customerChangeDue,
    required this.createdAt,
    this.updatedAt,
    this.reported,
    required this.orderItems,
    required this.table,
    this.channels,
    this.note,
    this.customerId,
  });
  late int id = Isar.autoIncrement;
  late String reference;
  late String orderNumber;
  late int fbranchId;
  late String status;
  late String orderType;
  late bool active;
  late bool draft;
  late double subTotal;
  late String paymentType;
  late double cashReceived;
  late double customerChangeDue;
  late String createdAt;
  late String? updatedAt;
  late bool? reported;

  late String table;

  List<String>? channels;

  // now add a customer to an order
  late int? customerId;

  late String? note;
  List<OrderItem> orderItems;

  factory OrderF.fromJson(Map<String, dynamic> json) => OrderF(
        orderItems: [],
        id: int.parse(json["id"]),
        reference: json["reference"],
        orderNumber: json["orderNumber"],
        fbranchId: int.parse(json["fbranchId"]),
        status: json["status"],
        orderType: json["orderType"],
        active: json["active"],
        reported: json["reported"],
        draft: json["draft"],
        subTotal: json["subTotal"],
        paymentType: json["paymentType"],
        cashReceived: json["cashReceived"],
        customerChangeDue: json["customerChangeDue"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        note: json["note"],
        table: json["table"],
        customerId: json["customerId"],
        channels: List<String>.from(json["channels"].map((x) => x)),

        // orderItems: List<OrderItem>.from(
        // json["orderItems"].map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "reference": reference,
        "orderNumber": orderNumber,
        "fbranchId": int.parse(fbranchId.toString()),
        "status": status,
        "reported": reported,
        "orderType": orderType,
        "active": active,
        "draft": draft,
        "subTotal": subTotal,
        "paymentType": paymentType,
        "cashReceived": cashReceived,
        "customerChangeDue": customerChangeDue,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "note": note,
        "orderItems": [],
        "table": table,
        "customerId": customerId,
        "channels": channels,
      };
}
