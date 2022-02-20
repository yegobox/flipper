// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);
library flipper_models;

import 'dart:convert';

import 'package:isar/isar.dart';

part 'product.g.dart';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

List<Product> productsFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

// String productToJson(List<Product> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Collection()
class Product {
  Product(
      {this.id = 0,
      required this.name,
      required this.description,
      this.channels,
      required this.active,
      this.ftaxId,
      required this.hasPicture,
      required this.table,
      required this.color,
      required this.fbusinessId,
      required this.fbranchId,
      this.fsupplierId,
      this.fcategoryId,
      this.createdAt,
      required this.unit,
      this.draft,
      this.imageLocal,
      this.currentUpdate,
      this.expiryDate,
      this.barCode,
      this.synced = false,
      this.migrated = false,
      this.imageUrl});
  late int id = Isar.autoIncrement;
  late String name;
  late String? description;
  late List<String>? channels;
  late bool active;
  late String? ftaxId;
  late bool hasPicture;
  late String table;
  late String color;
  late int fbusinessId;
  late int fbranchId;
  late String? fsupplierId;
  late String? fcategoryId;
  late String? createdAt;
  late String unit;
  late bool? draft;
  late bool? imageLocal;
  late bool? currentUpdate;
  late String? imageUrl;
  late String? expiryDate;
  late String? barCode;
  late bool? synced;
  late bool? migrated;

  // @Transient()
  // List<Variant> variants;

  factory Product.fromJson(Map<dynamic, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        migrated: json["migrated"] == null ? false : json["migrated"],
        barCode: json["barCode"],
        synced: json["synced"] == null ? false : json["synced"],
        description: json["description"],
        active: json["active"],
        ftaxId: json["ftaxId"],
        hasPicture: json["hasPicture"],
        table: json["table"],
        color: json["color"],
        fbusinessId: int.parse(json["fbusinessId"].toString()),
        fbranchId: int.parse(json["fbranchId"].toString()),
        fsupplierId: json["fsupplierId"],
        fcategoryId: json["fcategoryId"],
        createdAt: json["createdAt"],
        unit: json["unit"],
        expiryDate: json["expiryDate"],
        draft: json["draft"] == null ? false : json["draft"],
        imageLocal: json["imageLocal"] == null ? false : json["imageLocal"],
        currentUpdate:
            json["currentUpdate"] == null ? false : json["currentUpdate"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "barCode": barCode,
        "synced": synced == null ? false : synced,
        "description": description,
        "expiryDate": expiryDate,
        "active": active,
        "ftaxId": ftaxId,
        "hasPicture": hasPicture,
        "table": table,
        "color": color,
        "fbusinessId": int.parse(fbusinessId.toString()),
        "fbranchId": int.parse(fbranchId.toString()),
        "fsupplierId": fsupplierId,
        "fcategoryId": fcategoryId,
        "createdAt": createdAt == null ? '' : createdAt!,
        "unit": unit,
        "draft": draft == null ? false : draft,
        "imageLocal": imageLocal == null ? false : imageLocal,
        "currentUpdate": currentUpdate == null ? false : currentUpdate,
        "imageUrl": imageUrl,
        "migrated": migrated == null ? false : migrated,
        // "variations": variations
      };
}
