// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);
library flipper_models;

import 'dart:convert';
import './variant_sync.dart';
import 'package:objectbox/objectbox.dart';

ProductSync sproductFromJson(String str) =>
    ProductSync.fromJson(json.decode(str));

String sproductToJson(ProductSync data) => json.encode(data.toJson());

List<ProductSync> productFromJson(String str) => List<ProductSync>.from(
    json.decode(str).map((x) => ProductSync.fromJson(x)));

String productToJson(List<ProductSync> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
@Sync()
class ProductSync {
  ProductSync(
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
  String? fcategoryId;
  String? createdAt;
  String unit;
  bool? draft;
  bool? imageLocal;
  bool? currentUpdate;
  String? imageUrl;
  String? expiryDate;
  String? barCode;
  bool? synced;

  @Backlink('product')
  final variations = ToMany<VariantSync>();

  factory ProductSync.fromJson(Map<dynamic, dynamic> json) => ProductSync(
        id: json["id"],
        name: json["name"],
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
        // "variations": variations
      };
}
