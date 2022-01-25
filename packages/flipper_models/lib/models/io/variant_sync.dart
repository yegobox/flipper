// To parse this JSON data, do
//
//     final variation = variationFromJson(jsonString);
library flipper_models;

import 'dart:convert';

import './product_sync.dart';
import './stock_sync.dart';
import 'package:objectbox/objectbox.dart';

VariantSync svariationFromJsonSync(String str) =>
    VariantSync.fromJson(json.decode(str));

String svariationToJsonSync(VariantSync data) => json.encode(data.toJson());

List<VariantSync> variationFromJsonSync(String str) => List<VariantSync>.from(
    json.decode(str).map((x) => VariantSync.fromJson(x)));

String variationToJsonSync(List<VariantSync> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
@Sync()
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
  });

  @Id(assignable: true)
  int id;
  String name;
  String sku;
  int fproductId;
  String unit;
  String table;
  @Transient()
  List<String>? channels;
  String productName;
  int fbranchId;
  String? taxName;
  double? taxPercentage;
  double supplyPrice;
  double retailPrice;
  bool? synced;
  final product = ToOne<ProductSync>();

  final stock = ToOne<StockSync>();

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
