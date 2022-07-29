// To parse this JSON data, do
//
//     final branch = branchFromJson(jsonString);
library flipper_models;

import 'package:isar/isar.dart';
part 'branch.g.dart';

@Collection()
class Branch {
  Branch({
    this.id,
    this.active,
    this.description,
    this.name,
    this.businessId,
    this.longitude,
    this.latitude,
    this.table,
    required this.isDefault,
  });

  Id? id = Isar.autoIncrement;
  bool? active;

  String? description;
  String? name;
  int? businessId;
  String? longitude;
  String? latitude;
  String? table;
  late bool isDefault;

  factory Branch.fromJson(Map<dynamic, dynamic> json) => Branch(
      id: json["id"],
      active: json["active"],
      description: json["description"] ?? '',
      name: json["name"],
      businessId: json["businessId"] ?? 0,
      longitude: json["longitude"] ?? '',
      latitude: json["latitude"] ?? '',
      table: json["table"],
      isDefault: json["isDefault"]);

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "active": active ?? false,
        "description": description ?? '',
        "name": name,
        "businessId": businessId ?? 0,
        "longitude": longitude ?? '0',
        "latitude": latitude ?? '0',
        "table": table,
        "isDefault": isDefault,
      };
}
