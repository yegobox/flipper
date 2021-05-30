// To parse this JSON data, do
//
//     final business = businessFromJson(jsonString);
library flipper_models;

import 'dart:convert';

import 'package:objectbox/objectbox.dart';

Business sbusinessFromJson(String str) => Business.fromJson(json.decode(str));
String sbusinessToJson(Business data) => json.encode(data.toJson());

List<Business> businessFromJson(String str) =>
    List<Business>.from(json.decode(str).map((x) => Business.fromJson(x)));

String businessToJson(List<Business> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class Business {
  Business({
    this.id = 0,
    required this.name,
    this.currency,
    this.categoryId,
    required this.latitude,
    required this.longitude,
    this.userId,
    this.typeId,
    this.timeZone,
    this.channels,
    required this.table,
    required this.country,
    this.businessUrl,
    this.hexColor,
    this.image,
    required this.type,
    this.active = false,
  });
// TODO:add active propety in the API
  @Id(assignable: true)
  int id;
  String name;
  dynamic currency;
  int? categoryId;
  String latitude;
  String longitude;
  dynamic userId;
  dynamic typeId;
  dynamic timeZone;
  List<dynamic>? channels;
  String table;
  String country;
  dynamic businessUrl;
  dynamic hexColor;
  dynamic image;
  String type;
  bool? active;

  factory Business.fromJson(Map<String, dynamic> json) => Business(
        id: int.parse(json["id"]),
        name: json["name"],
        currency: json["currency"],
        categoryId: int.parse(json["categoryId"]),
        latitude: json["latitude"],
        longitude: json["longitude"],
        userId: json["userId"],
        typeId: json["typeId"],
        timeZone: json["timeZone"],
        channels: List<String>.from(json["channels"].map((x) => x)),
        table: json["table"],
        country: json["country"],
        businessUrl: json["businessUrl"],
        hexColor: json["hexColor"],
        image: json["image"],
        type: json["type"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "name": name,
        "currency": currency,
        "categoryId": int.parse(categoryId.toString()),
        "latitude": latitude,
        "longitude": longitude,
        "userId": userId,
        "typeId": typeId,
        "timeZone": timeZone,
        "channels": List<dynamic>.from(channels!.map((x) => x)),
        "table": table,
        "country": country,
        "businessUrl": businessUrl,
        "hexColor": hexColor,
        "image": image,
        "type": type,
        "active": active,
      };
}
