// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

import 'package:objectbox/objectbox.dart';

OrderF sorderFromJson(String str) => OrderF.fromJson(json.decode(str));

String sorderToJson(OrderF data) => json.encode(data.toJson());

List<OrderF> orderFromJson(String str) =>
    List<OrderF>.from(json.decode(str).map((x) => OrderF.fromJson(x)));

String orderToJson(List<OrderF> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class OrderF {
  OrderF({
    this.id = 0,
    required this.reference,
    required this.orderNumber,
    required this.branchId,
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
    this.orderItems,
    required this.table,
    required this.channels,
  });
  @Id(assignable: true)
  int id;
  String reference;
  String orderNumber;
  int branchId;
  String status;
  String orderType;
  bool active;
  bool draft;
  double subTotal;
  String paymentType;
  double cashReceived;
  double customerChangeDue;
  String createdAt;
  String? updatedAt;
  List<OrderItem>? orderItems;
  String table;
  List<String> channels;

  factory OrderF.fromJson(Map<String, dynamic> json) => OrderF(
        id: int.parse(json["id"]),
        reference: json["reference"],
        orderNumber: json["orderNumber"],
        branchId: int.parse(json["branchId"]),
        status: json["status"],
        orderType: json["orderType"],
        active: json["active"],
        draft: json["draft"],
        subTotal: json["subTotal"],
        paymentType: json["paymentType"],
        cashReceived: json["cashReceived"],
        customerChangeDue: json["customerChangeDue"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        orderItems: List<OrderItem>.from(
            json["orderItems"].map((x) => OrderItem.fromJson(x))),
        table: json["table"],
        channels: List<String>.from(json["channels"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "reference": reference,
        "orderNumber": orderNumber,
        "branchId": int.parse(branchId.toString()),
        "status": status,
        "orderType": orderType,
        "active": active,
        "draft": draft,
        "subTotal": subTotal,
        "paymentType": paymentType,
        "cashReceived": cashReceived,
        "customerChangeDue": customerChangeDue,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "orderItems": List<dynamic>.from(orderItems!.map((x) => x.toJson())),
        "table": table,
        "channels": List<dynamic>.from(channels.map((x) => x)),
      };
}

class OrderItem {
  OrderItem({
    this.id = 0,
    required this.name,
    required this.variantId,
    required this.count,
    required this.price,
    required this.orderId,
  });
  @Id(assignable: true)
  int id;
  String name;
  int variantId;
  double count;
  double price;
  int orderId;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: int.parse(json["id"]),
        name: json["name"],
        variantId: int.parse(json["variantId"]),
        count: json["count"],
        price: json["price"].toDouble(),
        orderId: int.parse(json["orderId"]),
      );

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "name": name,
        "variantId": int.parse(variantId.toString()),
        "count": count,
        "price": price,
        "orderId": int.parse(orderId.toString()),
      };
}
