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
    this.fcategoryId = 1,
    required this.latitude,
    required this.longitude,
    this.userId,
    this.typeId,
    this.timeZone,
    this.channels,
    this.table = "businesses",
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
  String? currency;
  int? fcategoryId;
  String latitude;
  String longitude;
  String? userId;
  String? typeId;
  String? timeZone;

  @Transient()
  List<String>? channels;
  String? table;
  String country;
  String? businessUrl;
  String? hexColor;
  String? image;
  String type;
  bool? active;

  factory Business.fromJson(Map<String, dynamic> json) => Business(
        id: json["id"],
        name: json["name"],
        currency: json["currency"],
        fcategoryId: json["fcategoryId"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        userId: json["userId"],
        typeId: json["typeId"],
        timeZone: json["timeZone"],
        // channels: List<String>.from(json["channels"].map((x) => x)),
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
        "fcategoryId": fcategoryId.toString(),
        "latitude": latitude,
        "longitude": longitude,
        "userId": userId,
        "typeId": typeId,
        "timeZone": timeZone,
        // "channels": List<dynamic>.from(channels!.map((x) => x)),
        "table": table,
        "country": country,
        "businessUrl": businessUrl,
        "hexColor": hexColor,
        "image": image,
        "type": type,
        "active": active,
      };
}
