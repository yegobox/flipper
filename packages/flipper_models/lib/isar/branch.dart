// To parse this JSON data, do
//
//     final branch = branchFromJson(jsonString);
library flipper_models;

import 'dart:convert';

import 'package:isar/isar.dart';
part 'branch.g.dart';

Branch branchFromJson(String str) => Branch.fromJson(json.decode(str));
String sbranchToJson(Branch data) => json.encode(data.toJson());

List<Branch> branchsFromJson(String str) =>
    List<Branch>.from(json.decode(str).map((x) => Branch.fromJson(x)));

String branchToJson(List<Branch> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Collection()
class Branch {
  Branch({
    this.id,
    this.active,
    this.description,
    this.name,
    this.fbusinessId,
    this.longitude,
    this.latitude,
    this.table,
  });

  int? id;
  bool? active;

  String? description;
  String? name;
  int? fbusinessId;
  String? longitude;
  String? latitude;
  String? table;

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json["id"],
        active: json["active"],
        description: json["description"] ?? '',
        name: json["name"],
        fbusinessId:
            json["fbusinessId"] == null ? 0 : int.parse(json["fbusinessId"]),
        longitude: json["longitude"] ?? '',
        latitude: json["latitude"],
        table: json["table"],
      );

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "active": active ?? false,
        "description": description ?? '',
        "name": name,
        "fbusinessId":
            fbusinessId == null ? 0 : int.parse(fbusinessId.toString()),
        "longitude": longitude ?? '0',
        "latitude": latitude ?? '0',
        "table": table,
      };
}
