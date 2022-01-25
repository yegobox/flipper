library flipper_models;

import 'dart:convert';

import 'package:objectbox/objectbox.dart';

Stock stockFromJsonSync(String str) => Stock.fromJson(json.decode(str));

String stockToJsonSync(Stock data) => json.encode(data.toJson());

List<Stock> stocksFromJsonSync(String str) =>
    List<Stock>.from(json.decode(str).map((x) => Stock.fromJson(x)));

String stocksToJsonSync(List<Stock> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
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
    this.migrated = false,
  });
  @Id(assignable: true)
  int id;
  int? fbranchId;
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
  bool? migrated;
  double value; // the value of stock items ie. count * retailPrice

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
        migrated: json["migrated"] == null ? false : json["migrated"],
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
        "value": value,
        "migrated": migrated == null ? false : migrated,
      };
}
