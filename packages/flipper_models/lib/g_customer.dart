library flipper_models;

// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

List<GCustomer> customerFromJson(String str) =>
    List<GCustomer>.from(json.decode(str).map((x) => GCustomer.fromJson(x)));
GCustomer fromMap(String str) => GCustomer.fromSingleCustomer(json.decode(str));
String customerToJson(List<GCustomer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GCustomer {
  GCustomer({
    this.id,
    this.name,
    this.totalPoints,
    this.totalVisits,
    this.firstVisit,
    this.totalSpent,
    this.phoneNumber,
    this.address,
    this.city,
    this.region,
    this.postalCode,
    this.countryCode,
    this.customerCode,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.channels,
  });

  String id;
  String name;
  int totalPoints;
  int totalVisits;
  String firstVisit;
  double totalSpent;
  String phoneNumber;
  String address;
  String city;
  String region;
  String postalCode;
  String countryCode;
  String customerCode;
  String note;
  String createdAt;
  dynamic updatedAt;
  List<String> channels;

  factory GCustomer.fromJson(Map<String, dynamic> json) => GCustomer(
        id: json["id"],
        name: json["name"],
        totalPoints: json["totalPoints"],
        totalVisits: json["totalVisits"],
        firstVisit: json["firstVisit"],
        totalSpent: json["totalSpent"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
        city: json["city"],
        region: json["region"],
        postalCode: json["postalCode"],
        countryCode: json["countryCode"],
        customerCode: json["customerCode"],
        note: json["note"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        channels: List<String>.from(json["channels"].map((x) => x)),
      );

  factory GCustomer.fromSingleCustomer(Map<String, dynamic> json) => GCustomer(
        id: json["id"],
        name: json["name"],
        totalPoints: json["totalPoints"],
        totalVisits: json["totalVisits"],
        firstVisit: json["firstVisit"],
        totalSpent: json["totalSpent"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
        city: json["city"],
        region: json["region"],
        postalCode: json["postalCode"],
        countryCode: json["countryCode"],
        customerCode: json["customerCode"],
        note: json["note"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        channels: List<String>.from(json["channels"].map((x) => x)),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "totalPoints": totalPoints,
        "totalVisits": totalVisits,
        "firstVisit": firstVisit,
        "totalSpent": totalSpent,
        "phoneNumber": phoneNumber,
        "address": address,
        "city": city,
        "region": region,
        "postalCode": postalCode,
        "countryCode": countryCode,
        "customerCode": customerCode,
        "note": note,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "channels": List<dynamic>.from(channels.map((x) => x)),
      };
}
