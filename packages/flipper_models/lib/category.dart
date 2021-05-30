// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);
library flipper_models;

import 'dart:convert';
import 'package:objectbox/objectbox.dart';

Category scategoryFromJson(String str) => Category.fromJson(json.decode(str));
String sbusinessToJson(Category data) => json.encode(data.toJson());

List<Category> categoryFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class Category {
  Category({
    this.id = 0,
    required this.active,
    required this.focused,
    required this.name,
    required this.channels,
    required this.branchId,
    required this.table,
  });
  @Id(assignable: true)
  int id;
  bool active;
  bool focused;
  String name;
  List<String> channels;
  int branchId;
  String table;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: int.parse(json["id"]),
        active: json["active"],
        focused: json["focused"],
        name: json["name"],
        channels: List<String>.from(json["channels"].map((x) => x)),
        branchId: int.parse(json["branchId"]),
        table: json["table"],
      );

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "active": active,
        "focused": focused,
        "name": name,
        "channels": List<dynamic>.from(channels.map((x) => x)),
        "branchId": int.parse(branchId.toString()),
        "table": table,
      };
}
