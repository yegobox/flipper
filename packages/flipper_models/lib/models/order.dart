// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

List<Order> orderFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  Order({
    required this.id,
    required this.reference,
    required this.orderNumber,
    required this.branchId,
    required this.status,
    required this.orderType,
    required this.active,
    required this.draft,
    required this.subTotal,
    required this.cashReceived,
    required this.customerChangeDue,
    this.createdAt,
    this.updatedAt,
    this.orderItems,
    required this.table,
    required this.channels,
    required this.amount,
  });

  String id;
  String reference;
  String orderNumber;
  String branchId;
  String status;
  String orderType;
  bool active;
  bool draft;
  int subTotal;
  int cashReceived;
  int customerChangeDue;
  String? createdAt;
  String? updatedAt;
  dynamic orderItems;
  String table;
  List<String> channels;
  int amount;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        reference: json["reference"],
        orderNumber: json["orderNumber"],
        branchId: json["branchId"],
        status: json["status"],
        orderType: json["orderType"],
        active: json["active"],
        draft: json["draft"],
        subTotal: json["subTotal"],
        cashReceived: json["cashReceived"],
        customerChangeDue: json["customerChangeDue"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        orderItems: json["orderItems"],
        table: json["table"],
        channels: List<String>.from(json["channels"].map((x) => x)),
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reference": reference,
        "orderNumber": orderNumber,
        "branchId": branchId,
        "status": status,
        "orderType": orderType,
        "active": active,
        "draft": draft,
        "subTotal": subTotal,
        "cashReceived": cashReceived,
        "customerChangeDue": customerChangeDue,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "orderItems": orderItems,
        "table": table,
        "channels": List<dynamic>.from(channels.map((x) => x)),
        "amount": amount,
      };
}
