// To parse this JSON data, do
//
//     final variation = variationFromJson(jsonString);
library flipper_models;

import 'dart:convert';

import 'package:objectbox/objectbox.dart';

Variation svariationFromJson(String str) =>
    Variation.fromJson(json.decode(str));

String svariationToJson(Variation data) => json.encode(data.toJson());

List<Variation> variationFromJson(String str) =>
    List<Variation>.from(json.decode(str).map((x) => Variation.fromJson(x)));

String variationToJson(List<Variation> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class Variation {
  Variation(
      {this.id = 0,
      required this.name,
      required this.sku,
      required this.productId,
      required this.unit,
      required this.table,
      this.channels,
      required this.productName,
      required this.branchId,
      this.taxName,
      this.taxPercentage});

  @Id(assignable: true)
  int id;
  String name;
  String sku;
  int productId;
  String unit;
  String table;
  List<dynamic>? channels;
  String productName;
  int branchId;
  String? taxName;
  double? taxPercentage;

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
      id: int.parse(json["id"]),
      name: json["name"],
      sku: json["sku"],
      productId: int.parse(json["productId"]),
      unit: json["unit"],
      table: json["table"],
      channels: List<String>.from(json["channels"].map((x) => x)),
      productName: json["productName"],
      branchId: int.parse(json["branchId"]),
      taxName: json["taxName"] ?? '',
      taxPercentage: json["taxPercentage"] ?? 0);

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "name": name,
        "sku": sku,
        "productId": int.parse(productId.toString()),
        "unit": unit,
        "table": table,
        "channels": List<dynamic>.from(channels!.map((x) => x)),
        "productName": productName,
        "branchId": int.parse(branchId.toString()),
        "taxName": taxName ?? '',
        "taxPercentage": taxPercentage ?? 0
      };
}
