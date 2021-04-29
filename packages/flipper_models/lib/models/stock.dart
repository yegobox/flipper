// To parse this JSON data, do
//
//     final stock = stockFromJson(jsonString);

import 'dart:convert';

List<Stock> stockFromJson(String str) =>
    List<Stock>.from(json.decode(str).map((x) => Stock.fromJson(x)));

String stockToJson(List<Stock> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Stock {
  Stock({
    required this.id,
    required this.value,
    required this.branchId,
    required this.variantId,
    required this.lowStock,
    required this.currentStock,
    required this.supplyPrice,
    required this.retailPrice,
    required this.canTrackingStock,
    required this.showLowStockAlert,
    required this.channels,
    required this.table,
    required this.productId,
    required this.active,
  });

  String id;
  double value;
  String branchId;
  String variantId;
  double lowStock;
  double currentStock;
  double supplyPrice;
  double retailPrice;
  bool canTrackingStock;
  bool showLowStockAlert;
  List<String> channels;
  String table;
  dynamic productId;
  bool active;

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
        id: json["id"],
        value: json["value"],
        branchId: json["branchId"],
        variantId: json["variantId"],
        lowStock: json["lowStock"],
        currentStock: json["currentStock"],
        supplyPrice: json["supplyPrice"],
        retailPrice: json["retailPrice"],
        canTrackingStock: json["canTrackingStock"],
        showLowStockAlert: json["showLowStockAlert"],
        channels: List<String>.from(json["channels"].map((x) => x)),
        table: json["table"],
        productId: json["productId"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "branchId": branchId,
        "variantId": variantId,
        "lowStock": lowStock,
        "currentStock": currentStock,
        "supplyPrice": supplyPrice,
        "retailPrice": retailPrice,
        "canTrackingStock": canTrackingStock,
        "showLowStockAlert": showLowStockAlert,
        "channels": List<dynamic>.from(channels.map((x) => x)),
        "table": table,
        "productId": productId,
        "active": active,
      };
}
