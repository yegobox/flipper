// To parse this JSON data, do
//
//     final OrderF = OrderFFromJson(jsonString);

import 'dart:convert';

import 'package:objectbox/objectbox.dart';

import 'order_item.dart';

OrderF sOrderFFromJson(String str) => OrderF.fromJson(json.decode(str));

String sOrderFToJson(OrderF data) => json.encode(data.toJson());

List<OrderF> orderFFromJson(String str) =>
    List<OrderF>.from(json.decode(str).map((x) => OrderF.fromJson(x)));

String orderFToJson(List<OrderF> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// because this model is not named same was as in isar it might cause
/// issue when we want to use both database at the same time. to I have to watch it.
@Entity()
@Sync()
class OrderF {
  OrderF(
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
      // required this.OrderFItems,
      required this.table,
      this.channels,
      this.note,
      this.customerId});

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
  @Transient()
  List<String>? channels;

  // now add a customer to an OrderF
  int? customerId;

  String? note;

  @Backlink()
  final orderItems = ToMany<OrderItem>();

  factory OrderF.fromJson(Map<String, dynamic> json) => OrderF(
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
        "table": table,
        "customerId": customerId,
        "channels": channels,
      };
}
