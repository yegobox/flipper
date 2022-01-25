// To parse this JSON data, do
//
//     final variation = variationFromJson(jsonString);
library flipper_models;

import 'dart:convert';

Variant svariationFromJsone(String str) => Variant.fromJson(json.decode(str));

String svariationToJsone(Variant data) => json.encode(data.toJson());

List<Variant> variationFromJsone(String str) =>
    List<Variant>.from(json.decode(str).map((x) => Variant.fromJson(x)));

String variationToJsone(List<Variant> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
    this.migrated = false,
    this.taxName,
    this.taxPercentage,
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
  bool? migrated;

  factory Variant.fromJson(Map<dynamic, dynamic> json) => Variant(
        id: json["id"],
        name: json["name"],
        sku: json["sku"],
        migrated: json["migrated"],
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
      );

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "name": name,
        "sku": sku,
        "productId": int.parse(fproductId.toString()),
        "unit": unit,
        "table": table,
        "migrated": migrated,
        "supplyPrice": supplyPrice,
        "retailPrice": retailPrice,
        "synced": synced == null ? false : synced,
        "productName": productName,
        "fbranchId": int.parse(fbranchId.toString()),
        "taxName": taxName ?? '',
        "taxPercentage": taxPercentage
      };
}
