// To parse this JSON data, do
//
//     final variantStock = variantStockFromJson(jsonString);
library flipper_models;

import 'dart:convert';

VariantStock svariantStockFromJson(String str) =>
    VariantStock.fromJson(json.decode(str));
String svariantStockToJson(VariantStock data) => json.encode(data.toJson());

List<VariantStock> variantStockFromJson(String str) => List<VariantStock>.from(
    json.decode(str).map((x) => VariantStock.fromJson(x)));

String variantStockToJson(List<VariantStock> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VariantStock {
  VariantStock({
    this.id = 0,
    required this.canTrackingStock,
    required this.retailPrice,
    required this.productName,
    required this.variantName,
    required this.unit,
    required this.sku,
    required this.fbranchId,
    required this.lowStock,
    required this.currentStock,
    required this.fvariantId,
    this.taxName,
    this.taxPercentage,
    required this.value,
  });

  int id;
  bool canTrackingStock;
  double retailPrice;
  String productName;
  String variantName;
  String unit;
  String sku;
  String fbranchId;
  double? lowStock;
  double currentStock;
  String fvariantId;
  String? taxName;
  double? taxPercentage;
  double value;

  factory VariantStock.fromJson(Map<String, dynamic> json) => VariantStock(
        id: int.parse(json["id"]),
        canTrackingStock: json["canTrackingStock"],
        retailPrice: json["retailPrice"],
        productName: json["productName"],
        variantName: json["variantName"],
        unit: json["unit"],
        sku: json["sku"],
        fbranchId: json["fbranchId"],
        lowStock: json["lowStock"],
        currentStock: json["currentStock"],
        fvariantId: json["fvariantId"],
        taxName: json["taxName"],
        taxPercentage: json["taxPercentage"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "canTrackingStock": canTrackingStock,
        "retailPrice": retailPrice,
        "productName": productName,
        "variantName": variantName,
        "unit": unit,
        "sku": sku,
        "fbranchId": fbranchId,
        "lowStock": lowStock,
        "currentStock": currentStock,
        "fvariantId": fvariantId,
        "taxName": taxName,
        "taxPercentage": taxPercentage,
        "value": value,
      };
}
