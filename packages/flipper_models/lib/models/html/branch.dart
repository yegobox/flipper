// To parse this JSON data, do
//
//     final branch = branchFromJson(jsonString);
library flipper_models;

import 'dart:convert';

import 'package:isar/isar.dart';
part 'branch.g.dart';

BranchSync branchFromJson(String str) => BranchSync.fromJson(json.decode(str));
String sbranchToJson(BranchSync data) => json.encode(data.toJson());

List<BranchSync> branchsFromJson(String str) =>
    List<BranchSync>.from(json.decode(str).map((x) => BranchSync.fromJson(x)));

String branchToJson(List<BranchSync> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Collection()
class BranchSync {
  BranchSync({
    this.id = 0,
    required this.active,
    this.channels,
    required this.description,
    required this.name,
    required this.fbusinessId,
    required this.longitude,
    required this.latitude,
    required this.table,
  });

  late int id = Isar.autoIncrement;
  late bool? active;

  late List<String>? channels;
  late String? description;
  late String name;
  late int? fbusinessId;
  late String? longitude;
  late String? latitude;
  late String table;

  factory BranchSync.fromJson(Map<String, dynamic> json) => BranchSync(
        id: json["id"],
        active: json["active"] ?? false,
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
