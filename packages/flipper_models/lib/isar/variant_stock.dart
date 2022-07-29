// To parse this JSON data, do
//
//     final variantStock = variantStockFromJson(jsonString);
library flipper_models;

import 'dart:convert';

import 'package:isar/isar.dart';
part 'variant_stock.g.dart';

VariantStock svariantStockFromJson(String str) =>
    VariantStock.fromJson(json.decode(str));
String svariantStockToJson(VariantStock data) => json.encode(data.toJson());

List<VariantStock> variantStockFromJson(String str) => List<VariantStock>.from(
    json.decode(str).map((x) => VariantStock.fromJson(x)));

String variantStockToJson(List<VariantStock> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Collection()
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

  Id id = Isar.autoIncrement;
  late bool canTrackingStock;
  late double retailPrice;
  late String productName;
  late String variantName;
  late String unit;
  late String sku;
  late String fbranchId;
  late double? lowStock;
  late double currentStock;
  late String fvariantId;
  late String? taxName;
  late double? taxPercentage;
  late double value;

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
