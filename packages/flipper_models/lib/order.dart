// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

Order sorderFromJson(String str) => Order.fromJson(json.decode(str));

String sorderToJson(Order data) => json.encode(data.toJson());

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
    required this.paymentType,
    required this.cashReceived,
    required this.customerChangeDue,
    required this.createdAt,
    this.updatedAt,
    required this.orderItems,
    required this.table,
    required this.channels,
  });

  String id;
  String reference;
  String orderNumber;
  String branchId;
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
  List<OrderItem> orderItems;
  String table;
  List<String> channels;

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
        "id": id,
        "reference": reference,
        "orderNumber": orderNumber,
        "branchId": branchId,
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
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "table": table,
        "channels": List<dynamic>.from(channels.map((x) => x)),
      };
}

class OrderItem {
  OrderItem({
    required this.id,
    required this.name,
    required this.variantId,
    required this.count,
    required this.price,
    required this.orderId,
  });

  String id;
  String name;
  String variantId;
  double count;
  double price;
  String orderId;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        name: json["name"],
        variantId: json["variantId"],
        count: json["count"],
        price: json["price"].toDouble(),
        orderId: json["orderId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "variantId": variantId,
        "count": count,
        "price": price,
        "orderId": orderId,
      };
}
