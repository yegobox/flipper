// To parse this JSON data, do
//
//     final variation = variationFromJson(jsonString);
library flipper_models;

import 'dart:convert';

import 'package:flipper_models/models/html/stock_sync.dart';
import 'package:isar/isar.dart';
part 'variant_sync.g.dart';

Variant svariationFromJson(String str) => Variant.fromJson(json.decode(str));

String svariationToJson(Variant data) => json.encode(data.toJson());

List<Variant> variationFromJson(String str) =>
    List<Variant>.from(json.decode(str).map((x) => Variant.fromJson(x)));

String variationToJson(List<Variant> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Collection()
class Variant {
  Variant({
    this.id = 0,
    required this.name,
    required this.sku,
    required this.fproductId,
    required this.unit,
    required this.table,
    this.channels,
    required this.supplyPrice,
    required this.retailPrice,
    required this.productName,
    required this.fbranchId,
    this.synced = false,
    this.taxName,
    this.taxPercentage,
    this.stock,
  });

  late int id = Isar.autoIncrement;
  late String name;
  late String sku;
  late int fproductId;
  late String unit;
  late String table;
  late List<String>? channels;
  late String productName;
  late int fbranchId;
  late String? taxName;
  late double? taxPercentage;
  late double supplyPrice;
  late double retailPrice;
  late bool? synced;
  late Stock? stock;

  factory Variant.fromJson(Map<dynamic, dynamic> json) => Variant(
        id: json["id"],
        name: json["name"],
        sku: json["sku"],
        fproductId: json["productId"],
        unit: json["unit"],
        supplyPrice: json["supplyPrice"],
        retailPrice: json["retailPrice"],
        synced: json["synced"] == null ? false : json["synced"],
        table: json["table"],
        productName: json["productName"],
        fbranchId: json["fbranchId"],
        taxName: json["taxName"] ?? '',
        taxPercentage: json["taxPercentage"] != null
            ? json["taxPercentage"].toDouble()
            : 0.0,
        stock: Stock.fromJson(json["stock"]),
      );

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "name": name,
        "sku": sku,
        "productId": int.parse(fproductId.toString()),
        "unit": unit,
        "table": table,
        "supplyPrice": supplyPrice,
        "retailPrice": retailPrice,
        "synced": synced == null ? false : synced,
        "productName": productName,
        "fbranchId": int.parse(fbranchId.toString()),
        "taxName": taxName ?? '',
        "taxPercentage": taxPercentage
      };
}
