// To parse this JSON data, do
//
//     final variation = variationFromJson(jsonString);
library flipper_models;

import 'dart:convert';

import 'package:flipper_models/models/html/stock_sync.dart';

VariantSync svariationFromJson(String str) =>
    VariantSync.fromJson(json.decode(str));

String svariationToJson(VariantSync data) => json.encode(data.toJson());

List<VariantSync> variationFromJson(String str) => List<VariantSync>.from(
    json.decode(str).map((x) => VariantSync.fromJson(x)));

String variationToJson(List<VariantSync> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VariantSync {
  VariantSync({
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

  int id;
  String name;
  String sku;
  int fproductId;
  String unit;
  String table;
  List<String>? channels;
  String productName;
  int fbranchId;
  String? taxName;
  double? taxPercentage;
  double supplyPrice;
  double retailPrice;
  bool? synced;
  StockSync? stock;

  factory VariantSync.fromJson(Map<dynamic, dynamic> json) => VariantSync(
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
        stock: StockSync.fromJson(json["stock"]),
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
