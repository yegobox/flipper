// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);
library flipper_models;

import 'dart:convert';
import 'package:flipper_models/variants.dart';
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
      this.ftaxId,
      required this.hasPicture,
      required this.table,
      required this.color,
      required this.fbusinessId,
      required this.fbranchId,
      this.fsupplierId,
      required this.fcategoryId,
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
  @Transient()
  List<String>? channels;
  bool active;
  String? ftaxId;
  bool hasPicture;
  String table;
  String color;
  int fbusinessId;
  int fbranchId;
  String? fsupplierId;
  String fcategoryId;
  String? createdAt;
  String unit;
  bool? draft;
  bool? imageLocal;
  bool? currentUpdate;
  String? imageUrl;

  @Backlink()
  final variations = ToMany<Variant>();

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: int.parse(json["id"]),
        name: json["name"],
        description: json["description"],
        channels: List<String>.from(json["channels"].map((x) => x)),
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
        // "variants": variants,
        "draft": draft == null ? false : draft,
        "imageLocal": imageLocal == null ? false : imageLocal,
        "currentUpdate": currentUpdate == null ? false : currentUpdate,
        "imageUrl": imageUrl,
      };
}
