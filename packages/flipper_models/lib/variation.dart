// To parse this JSON data, do
//
//     final variation = variationFromJson(jsonString);
library flipper_models;

import 'dart:convert';

import 'package:flipper_models/product.dart';
import 'package:objectbox/objectbox.dart';

Variant svariationFromJson(String str) => Variant.fromJson(json.decode(str));

String svariationToJson(Variant data) => json.encode(data.toJson());

List<Variant> variationFromJson(String str) =>
    List<Variant>.from(json.decode(str).map((x) => Variant.fromJson(x)));

String variationToJson(List<Variant> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity(uid: 1)
class Variant {
  Variant(
      {this.id = 0,
      required this.name,
      required this.sku,
      required this.fproductId,
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
  int fproductId;
  String unit;
  String table;
  List<dynamic>? channels;
  String productName;
  int branchId;
  String? taxName;
  double? taxPercentage;

  final product = ToOne<Product>();

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
      id: int.parse(json["id"]),
      name: json["name"],
      sku: json["sku"],
      fproductId: int.parse(json["productId"].toString()),
      unit: json["unit"],
      table: json["table"],
      channels: List<String>.from(json["channels"].map((x) => x)),
      productName: json["productName"],
      branchId: int.parse(json["branchId"].toString()),
      taxName: json["taxName"] ?? '',
      taxPercentage: json["taxPercentage"] ?? 0);

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "name": name,
        "sku": sku,
        "productId": int.parse(fproductId.toString()),
        "unit": unit,
        "table": table,
        "channels": List<dynamic>.from(channels!.map((x) => x)),
        "productName": productName,
        "branchId": int.parse(branchId.toString()),
        "taxName": taxName ?? '',
        "taxPercentage": taxPercentage ?? 0
      };
}
