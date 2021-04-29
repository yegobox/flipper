// To parse this JSON data, do
//
//     final variation = variationFromJson(jsonString);

import 'dart:convert';

List<Variation> variationFromJson(String str) =>
    List<Variation>.from(json.decode(str).map((x) => Variation.fromJson(x)));

String variationToJson(List<Variation> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Variation {
  Variation({
    required this.id,
    required this.name,
    required this.sku,
    required this.productId,
    required this.unit,
    required this.table,
    required this.channels,
    required this.productName,
    required this.currentStock,
    required this.supplyPrice,
    required this.retailPrice,
    required this.canTrackingStock,
    required this.stockId,
    required this.branchId,
    this.lowStock,
  });

  String id;
  String name;
  String sku;
  String productId;
  String unit;
  String table;
  List<String> channels;
  String productName;
  double currentStock;
  double supplyPrice;
  double retailPrice;
  bool canTrackingStock;
  String stockId;
  String branchId;
  double? lowStock;

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
      id: json["id"],
      name: json["name"],
      sku: json["sku"],
      productId: json["productId"],
      unit: json["unit"],
      table: json["table"],
      channels: List<String>.from(json["channels"].map((x) => x)),
      productName: json["productName"],
      currentStock: json["currentStock"],
      supplyPrice: json["supplyPrice"],
      retailPrice: json["retailPrice"],
      canTrackingStock: json["canTrackingStock"],
      stockId: json["stockId"],
      branchId: json["branchId"],
      lowStock: json["branchId"] == null ? 0.0 : json["lowStock"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sku": sku,
        "productId": productId,
        "unit": unit,
        "table": table,
        "channels": List<dynamic>.from(channels.map((x) => x)),
        "productName": productName,
        "currentStock": currentStock,
        "supplyPrice": supplyPrice,
        "retailPrice": retailPrice,
        "canTrackingStock": canTrackingStock,
        "stockId": stockId,
        "branchId": branchId,
        "lowStock": lowStock == null ? 0.0 : lowStock
      };
}
