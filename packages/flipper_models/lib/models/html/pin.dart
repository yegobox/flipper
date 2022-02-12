// To parse this JSON data, do
//
//     final pin = pinFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Pin pinFromMap(String str) => Pin.fromMap(json.decode(str));

String pinToMap(Pin data) => json.encode(data.toMap());

class Pin {
  Pin({
    required this.userId,
    required this.phoneNumber,
    required this.pin,
    required this.branchId,
    required this.businessId,
  });

  String userId;
  String phoneNumber;
  int pin;
  int branchId;
  int businessId;

  factory Pin.fromMap(Map<String, dynamic> json) => Pin(
        userId: json["userId"],
        phoneNumber: json["phoneNumber"],
        pin: json["pin"],
        branchId: json["branchId"],
        businessId: json["businessId"],
      );

  Map<String, dynamic> toMap() => {
        "userId": userId,
        "phoneNumber": phoneNumber,
        "pin": pin,
        "branchId": branchId,
        "businessId": businessId,
      };
}
