// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);
library flipper_models;

import 'dart:convert';
import 'package:objectbox/objectbox.dart';

Product sproductFromJson(String str) => Product.fromJson(json.decode(str));

String sproductToJson(Product data) => json.encode(data.toJson());

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class Product {
  Product(
      {this.id = 0,
      required this.name,
      required this.description,
      required this.channels,
      required this.active,
      this.taxId,
      required this.hasPicture,
      required this.table,
      required this.color,
      required this.businessId,
      required this.branchId,
      this.supplierId,
      required this.categoryId,
      this.createdAt,
      required this.unit,
      this.allVariants,
      this.variants,
      this.draft,
      this.imageLocal,
      this.currentUpdate,
      this.imageUrl});
  @Id(assignable: true)
  int id;
  String name;
  String? description;
  List<String> channels;
  bool active;
  dynamic taxId;
  bool hasPicture;
  String table;
  String color;
  int businessId;
  int branchId;
  dynamic supplierId;
  String categoryId;
  String? createdAt;
  String unit;
  List<AllVariant>? allVariants;
  List<AllVariant>? variants;
  bool? draft;
  bool? imageLocal;
  bool? currentUpdate;
  String? imageUrl;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: int.parse(json["id"]),
        name: json["name"],
        description: json["description"],
        channels: List<String>.from(json["channels"].map((x) => x)),
        active: json["active"],
        taxId: json["taxId"],
        hasPicture: json["hasPicture"],
        table: json["table"],
        color: json["color"],
        businessId: int.parse(json["businessId"]),
        branchId: int.parse(json["branchId"]),
        supplierId: json["supplierId"],
        categoryId: json["categoryId"],
        createdAt: json["createdAt"],
        unit: json["unit"],
        allVariants: json["allVariants"] == null
            ? []
            : List<AllVariant>.from(
                json["allVariants"].map((x) => AllVariant.fromJson(x))),
        variants: json["variants"] == null
            ? []
            : List<AllVariant>.from(
                json["variants"].map((x) => AllVariant.fromJson(x))),
        draft: json["draft"] == null ? false : json["draft"],
        imageLocal: json["imageLocal"] == null ? false : json["imageLocal"],
        currentUpdate:
            json["currentUpdate"] == null ? false : json["currentUpdate"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "name": name,
        "description": description,
        "channels": List<dynamic>.from(channels.map((x) => x)),
        "active": active,
        "taxId": taxId,
        "hasPicture": hasPicture,
        "table": table,
        "color": color,
        "businessId": int.parse(businessId.toString()),
        "branchId": int.parse(branchId.toString()),
        "supplierId": supplierId,
        "categoryId": categoryId,
        "createdAt": createdAt == null ? '' : createdAt!,
        "unit": unit,
        "allVariants": allVariants == null
            ? []
            : List<dynamic>.from(allVariants!.map((x) => x.toJson())),
        "variants": variants == null
            ? []
            : List<dynamic>.from(variants!.map((x) => x.toJson())),
        "draft": draft == null ? false : draft,
        "imageLocal": imageLocal == null ? false : imageLocal,
        "currentUpdate": currentUpdate == null ? false : currentUpdate,
        "imageUrl": imageUrl,
      };
}

class AllVariant {
  AllVariant(
      {this.id,
      required this.name,
      required this.sku,
      this.productId,
      required this.unit,
      required this.table,
      required this.channels,
      this.productName,
      required this.currentStock,
      required this.supplyPrice,
      required this.retailPrice,
      required this.canTrackingStock,
      this.stockId,
      this.branchId});
  int? branchId;
  String? id;
  String name;
  String sku;
  String? productId;
  String unit;
  String table;
  List<String> channels;
  String? productName;
  dynamic currentStock;
  dynamic supplyPrice;
  dynamic retailPrice;
  dynamic canTrackingStock;
  String? stockId;

  factory AllVariant.fromJson(Map<String, dynamic> json) => AllVariant(
        id: json["id"] == null ? '' : json["id"],
        name: json["name"],
        sku: json["sku"],
        productId: json["productId"] == null ? 0 : json["productId"],
        unit: json["unit"],
        table: json["table"],
        channels: List<String>.from(json["channels"].map((x) => x)),
        productName: json["productName"] == null ? '' : json["productName"],
        currentStock: json["currentStock"],
        supplyPrice: json["supplyPrice"],
        retailPrice: json["retailPrice"],
        canTrackingStock: json["canTrackingStock"],
        stockId: json["stockId"] == null ? '' : json["stockId"],
        branchId: json["branchId"] == null ? 0 : int.parse(json["branchId"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? '' : id,
        "name": name,
        "sku": sku,
        "productId": productId == null ? 0 : int.parse(productId.toString()),
        "unit": unit,
        "table": table,
        "channels": List<dynamic>.from(channels.map((x) => x)),
        "productName": productName == null ? '' : productName,
        "currentStock": currentStock,
        "supplyPrice": supplyPrice,
        "retailPrice": retailPrice,
        "canTrackingStock": canTrackingStock,
        "stockId": stockId == null ? '' : stockId,
        "branchId": branchId == null ? 0 : int.parse(branchId.toString())
      };
}
