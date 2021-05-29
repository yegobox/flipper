// To parse this JSON data, do
//
//     final variation = variationFromJson(jsonString);
library flipper_models;

import 'dart:convert';

import 'package:flipper/objectbox.g.dart';

Variation svariationFromJson(String str) =>
    Variation.fromJson(json.decode(str));

String svariationToJson(Variation data) => json.encode(data.toJson());

List<Variation> variationFromJson(String str) =>
    List<Variation>.from(json.decode(str).map((x) => Variation.fromJson(x)));

String variationToJson(List<Variation> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Variation {
  Variation(
      {required this.id,
      required this.name,
      required this.sku,
      required this.productId,
      required this.unit,
      required this.table,
      required this.channels,
      required this.productName,
      required this.branchId,
      this.taxName,
      this.taxPercentage});

  @Id()
  int? tracker;
  String id;
  String name;
  String sku;
  String productId;
  String unit;
  String table;
  List<String> channels;
  String productName;
  String branchId;
  String? taxName;
  double? taxPercentage;

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
      id: json["id"],
      name: json["name"],
      sku: json["sku"],
      productId: json["productId"],
      unit: json["unit"],
      table: json["table"],
      channels: List<String>.from(json["channels"].map((x) => x)),
      productName: json["productName"],
      branchId: json["branchId"],
      taxName: json["taxName"] ?? '',
      taxPercentage: json["taxPercentage"] ?? 0);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sku": sku,
        "productId": productId,
        "unit": unit,
        "table": table,
        "channels": List<dynamic>.from(channels.map((x) => x)),
        "productName": productName,
        "branchId": branchId,
        "taxName": taxName ?? '',
        "taxPercentage": taxPercentage ?? 0
      };
}
