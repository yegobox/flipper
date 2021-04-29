// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category scategoryFromJson(String str) => Category.fromJson(json.decode(str));
String sbusinessToJson(Category data) => json.encode(data.toJson());

List<Category> categoryFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
  Category({
    required this.id,
    required this.active,
    required this.focused,
    required this.name,
    required this.channels,
    required this.branchId,
    required this.table,
  });

  String id;
  bool active;
  bool focused;
  String name;
  List<String> channels;
  String branchId;
  String table;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        active: json["active"],
        focused: json["focused"],
        name: json["name"],
        channels: List<String>.from(json["channels"].map((x) => x)),
        branchId: json["branchId"],
        table: json["table"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "active": active,
        "focused": focused,
        "name": name,
        "channels": List<dynamic>.from(channels.map((x) => x)),
        "branchId": branchId,
        "table": table,
      };
}
