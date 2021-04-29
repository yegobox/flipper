// To parse this JSON data, do
//
//     final branch = branchFromJson(jsonString);

import 'dart:convert';

Branch sbranchFromJson(String str) => Branch.fromJson(json.decode(str));
String sbranchToJson(Branch data) => json.encode(data.toJson());

List<Branch> branchFromJson(String str) =>
    List<Branch>.from(json.decode(str).map((x) => Branch.fromJson(x)));

String branchToJson(List<Branch> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Branch {
  Branch({
    required this.id,
    required this.active,
    required this.channels,
    required this.description,
    required this.name,
    required this.businessId,
    required this.longitude,
    required this.latitude,
    required this.table,
  });

  String id;
  bool? active;
  List<String> channels;
  String? description;
  String name;
  String? businessId;
  String? longitude;
  String? latitude;
  String table;

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json["id"],
        active: json["active"] == null ? false : json["active"],
        channels: List<String>.from(json["channels"].map((x) => x)),
        description: json["description"] == null ? '' : json["description"],
        name: json["name"],
        businessId: json["businessId"] == null ? '' : json["businessId"],
        longitude: json["longitude"] == null ? '' : json["longitude"],
        latitude: json["latitude"],
        table: json["table"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "active": active == null ? false : active,
        "channels": List<dynamic>.from(channels.map((x) => x)),
        "description": description == null ? '' : description,
        "name": name,
        "businessId": businessId == null ? '' : businessId,
        "longitude": longitude == null ? '0' : longitude,
        "latitude": latitude == null ? '0' : latitude,
        "table": table,
      };
}
