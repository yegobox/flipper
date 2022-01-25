// To parse this JSON data, do
//
//     final stock = stockFromJson(jsonString);
library flipper_models;

import 'dart:convert';

StockSync sstockFromJsonSync(String str) =>
    StockSync.fromJson(json.decode(str));

String sstockToJsonSync(StockSync data) => json.encode(data.toJson());

List<StockSync> stocksFromJsonSync(String str) =>
    List<StockSync>.from(json.decode(str).map((x) => StockSync.fromJson(x)));

String stockToJsonSync(List<StockSync> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StockSync {
  StockSync({
    this.id = 0,
    this.fbranchId,
    required this.fvariantId,
    required this.lowStock,
    required this.currentStock,
    required this.supplyPrice,
    required this.retailPrice,
    required this.canTrackingStock,
    required this.showLowStockAlert,
    this.channels,
    required this.table,
    required this.fproductId,
    this.active,
    required this.value,
    this.target,
  });
  int id;
  int? fbranchId;
  int fvariantId;
  double lowStock;
  double currentStock;
  double supplyPrice;
  double retailPrice;
  bool canTrackingStock;
  bool showLowStockAlert;
  List<String>? channels;
  String table;
  int fproductId;
  bool? active;
  double value; // the value of stock items ie. count * retailPrice
  dynamic target;
  factory StockSync.fromJson(Map<dynamic, dynamic> json) => StockSync(
        id: json["id"],
        fbranchId: json["fbranchId"],
        fvariantId: json["fvariantId"],
        lowStock: json["lowStock"] != null ? json["lowStock"].toDouble() : 0.0,
        currentStock: json["currentStock"] != null
            ? json["currentStock"].toDouble()
            : 0.0,
        supplyPrice:
            json["supplyPrice"] != null ? json["supplyPrice"].toDouble() : 0.0,
        retailPrice:
            json["retailPrice"] != null ? json["retailPrice"].toDouble() : 0.0,
        canTrackingStock: json["canTrackingStock"],
        showLowStockAlert: json["showLowStockAlert"],
        table: json["table"],
        fproductId: json["fproductId"],
        active: json["active"] == null ? false : json["active"],
        value: json["value"],
        target: json["target"],
      );

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "fbranchId": fbranchId,
        "fvariantId": int.parse(fvariantId.toString()),
        "lowStock": lowStock,
        "currentStock": currentStock,
        "supplyPrice": supplyPrice,
        "retailPrice": retailPrice,
        "canTrackingStock": canTrackingStock,
        "showLowStockAlert": showLowStockAlert,
        "table": table,
        "fproductId": fproductId,
        "active": active == null ? false : active,
        "value": value
      };
}
