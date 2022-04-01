// To parse this JSON data, do
//
//     final stock = stockFromJson(jsonString);
library flipper_models;

import 'dart:convert';

import 'package:isar/isar.dart';
part 'stock_sync.g.dart';

Stock sstockFromJsonSync(String str) => Stock.fromJson(json.decode(str));

String sstockToJsonSync(Stock data) => json.encode(data.toJson());

List<Stock> stocksFromJsonSync(String str) =>
    List<Stock>.from(json.decode(str).map((x) => Stock.fromJson(x)));

String stockToJsonSync(List<Stock> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Collection()
class Stock {
  Stock({
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
  late int id = Isar.autoIncrement;
  late int? fbranchId;
  late int fvariantId;
  late double lowStock;
  late double currentStock;
  late double supplyPrice;
  late double retailPrice;
  late bool canTrackingStock;
  late bool showLowStockAlert;
  late List<String>? channels;
  late String table;
  late int fproductId;
  late bool? active;
  late double value; // the value of stock items ie. count * retailPrice
  dynamic target;
  factory Stock.fromJson(Map<dynamic, dynamic> json) => Stock(
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
