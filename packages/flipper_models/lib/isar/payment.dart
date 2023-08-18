// To parse this JSON data, do
//
//     final payment = paymentFromMap(jsonString);

import 'dart:convert';

import 'package:isar/isar.dart';
part 'payment.g.dart';

Payment paymentFromMap(String str) => Payment.fromMap(json.decode(str));

String paymentToMap(Payment data) => json.encode(data.toMap());

@Collection()
class Payment {
  Payment({
    required this.id,
    required this.amount,
    required this.interval,
    required this.userId,
    required this.createdAt,
    required this.paymentType,
    required this.requestGuid,
    required this.note,
    required this.itemName,
    required this.phoneNumber,
  });

  late String id;
  late int amount;
  late int interval;
  late int userId;
  late int createdAt;
  late String paymentType;
  late String requestGuid;
  late String note;
  late String itemName;
  late String phoneNumber;

  factory Payment.fromMap(Map<String, dynamic> json) => Payment(
        id: json["id"],
        amount: json["amount"],
        interval: json["interval"],
        userId: json["userId"],
        createdAt: json["createdAt"],
        paymentType: json["paymentType"],
        requestGuid: json["RequestGuid"],
        note: json["note"],
        itemName: json["itemName"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "amount": amount,
        "interval": interval,
        "userId": userId,
        "createdAt": createdAt,
        "paymentType": paymentType,
        "RequestGuid": requestGuid,
        "note": note,
        "itemName": itemName,
        "phoneNumber": phoneNumber,
      };
}
