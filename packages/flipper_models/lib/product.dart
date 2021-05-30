// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);
library flipper_models;

import 'dart:convert';
import 'package:flipper_models/variation.dart';
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
      this.channels,
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
      this.draft,
      this.imageLocal,
      this.currentUpdate,
      this.imageUrl});
  @Id(assignable: true)
  int id;
  String name;
  String? description;
  List<dynamic>? channels;
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
  @Backlink()
  final variants = ToMany<Variant>();
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
        businessId: int.parse(json["businessId"].toString()),
        branchId: int.parse(json["branchId"].toString()),
        supplierId: json["supplierId"],
        categoryId: json["categoryId"],
        createdAt: json["createdAt"],
        unit: json["unit"],
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
        "channels": List<dynamic>.from(channels!.map((x) => x)),
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
        "variants": variants,
        "draft": draft == null ? false : draft,
        "imageLocal": imageLocal == null ? false : imageLocal,
        "currentUpdate": currentUpdate == null ? false : currentUpdate,
        "imageUrl": imageUrl,
      };
}
