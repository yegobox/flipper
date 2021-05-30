// To parse this JSON data, do
//
//     final stock = stockFromJson(jsonString);
library flipper_models;

import 'dart:convert';

import 'package:objectbox/objectbox.dart';

Stock sstockFromJson(String str) => Stock.fromJson(json.decode(str));

String sstockToJson(Stock data) => json.encode(data.toJson());

List<Stock> stockFromJson(String str) =>
    List<Stock>.from(json.decode(str).map((x) => Stock.fromJson(x)));

String stockToJson(List<Stock> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class Stock {
  Stock({
    this.id = 0,
    required this.fbranchId,
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
  });
  @Id(assignable: true)
  int id;
  int fbranchId;
  int fvariantId;
  double lowStock;
  double currentStock;
  double supplyPrice;
  double retailPrice;
  bool canTrackingStock;
  bool showLowStockAlert;
  @Transient()
  List<String>? channels;
  String table;
  int fproductId;
  bool? active;
  double value; // the value of stock items ie. count * retailPrice

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
      id: int.parse(json["id"]),
      fbranchId: json["fbranchId"],
      fvariantId: int.parse(json["fvariantId"].toString()),
      lowStock: json["lowStock"],
      currentStock: json["currentStock"],
      supplyPrice: json["supplyPrice"],
      retailPrice: json["retailPrice"],
      canTrackingStock: json["canTrackingStock"],
      showLowStockAlert: json["showLowStockAlert"],
      channels: List<String>.from(json["channels"].map((x) => x)),
      table: json["table"],
      fproductId: int.parse(json["fproductId"].toString()),
      active: json["active"] == null ? false : json["active"],
      value: json["value"]);

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
        "channels": List<dynamic>.from(channels!.map((x) => x)),
        "table": table,
        "fproductId": fproductId,
        "active": active == null ? false : active,
        "value": value
      };
}
