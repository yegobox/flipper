// To parse this JSON data, do
//
//     final branch = branchFromJson(jsonString);
library flipper_models;

import 'dart:convert';

import './subscription.dart';
import './tenant.dart';
import 'package:objectbox/objectbox.dart';

BranchSync sbranchFromJson(String str) => BranchSync.fromJson(json.decode(str));
String sbranchToJson(BranchSync data) => json.encode(data.toJson());

List<BranchSync> branchFromJson(String str) =>
    List<BranchSync>.from(json.decode(str).map((x) => BranchSync.fromJson(x)));

String branchToJson(List<BranchSync> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
@Sync()
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

  @Id(assignable: true)
  int id;
  bool? active;
  @Transient()
  List<String>? channels;
  String? description;
  String name;
  int? fbusinessId;
  String? longitude;
  String? latitude;
  String table;

  final product = ToOne<TenantSync>();

  final subscription = ToOne<Subscription>();

  factory BranchSync.fromJson(Map<String, dynamic> json) => BranchSync(
        id: json["id"],
        active: json["active"] == null ? false : json["active"],
        description: json["description"] == null ? '' : json["description"],
        name: json["name"],
        fbusinessId:
            json["fbusinessId"] == null ? 0 : int.parse(json["fbusinessId"]),
        longitude: json["longitude"] == null ? '' : json["longitude"],
        latitude: json["latitude"],
        table: json["table"],
      );

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "active": active == null ? false : active,
        "description": description == null ? '' : description,
        "name": name,
        "fbusinessId":
            fbusinessId == null ? 0 : int.parse(fbusinessId.toString()),
        "longitude": longitude == null ? '0' : longitude,
        "latitude": latitude == null ? '0' : latitude,
        "table": table,
      };
}
