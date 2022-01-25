// To parse this JSON data, do
//
//     final order = orderFromJsonSync(jsonString);
import 'package:flipper_models/models/models.dart';
import 'dart:convert';

OrderFSync orderFromJsonSync(String str) =>
    OrderFSync.fromJson(json.decode(str));

String orderToJsonSync(OrderFSync data) => json.encode(data.toJson());

List<OrderFSync> ordersFromJsonSync(String str) =>
    List<OrderFSync>.from(json.decode(str).map((x) => OrderFSync.fromJson(x)));

String orderToJson(List<OrderFSync> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderFSync {
  OrderFSync(
      {this.id = 0,
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
      // required this.orderItems,
      required this.table,
      this.channels,
      this.note,
      this.customerId,
      required this.orderItems});
  int id;
  String reference;
  String orderNumber;
  int fbranchId;
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
  bool? reported;

  String table;

  List<String>? channels;

  // now add a customer to an order
  int? customerId;

  String? note;
  List<OrderItemSync> orderItems;

  factory OrderFSync.fromJson(Map<String, dynamic> json) => OrderFSync(
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
        orderItems: List<OrderItemSync>.from(
            json["orderItems"].map((x) => OrderItemSync.fromJson(x))),
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
