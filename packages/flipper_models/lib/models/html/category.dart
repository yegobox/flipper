// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);
library flipper_models;

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));
String scategoryToJson(Category data) => json.encode(data.toJson());

List<Category> categoriesFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
  Category({
    this.id = 0,
    required this.active,
    required this.focused,
    required this.name,
    this.channels,
    required this.fbranchId,
    required this.table,
  });
  int id;
  bool active;
  bool focused;
  String name;
  List<String>? channels;
  int fbranchId;
  String table;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: int.parse(json["id"]),
        active: json["active"],
        focused: json["focused"],
        name: json["name"],
        fbranchId: int.parse(json["fbranchId"]),
        table: json["table"],
      );

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "active": active,
        "focused": focused,
        "name": name,
        "fbranchId": int.parse(fbranchId.toString()),
        "table": table,
      };
}
