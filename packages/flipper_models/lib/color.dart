// To parse this JSON data, do
//
//     final pColor = pColorFromJson(jsonString);
library flipper_models;

import 'dart:convert';

import 'package:objectbox/objectbox.dart';

PColor spColorFromJson(String str) => PColor.fromJson(json.decode(str));
String spColorToJson(PColor data) => json.encode(data.toJson());

List<PColor> pColorFromJson(String str) =>
    List<PColor>.from(json.decode(str).map((x) => PColor.fromJson(x)));

String pColorToJson(List<PColor> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class PColor {
  PColor({
    this.id = 0,
    this.name,
    this.channels,
    this.colors,
    required this.table,
    required this.fbranchId,
    required this.active,
  });

  @Id(assignable: true)
  int id;
  String? name;
  @Transient()
  List<String>? channels;
  @Transient()
  List<String>? colors;
  String table;
  int fbranchId;
  bool active;

  factory PColor.fromJson(Map<String, dynamic> json) => PColor(
        id: int.parse(json["id"]),
        name: json["name"] == null ? '#ee5253' : json["name"],
        channels: List<String>.from(json["channels"].map((x) => x)),
        colors: json["colors"] == null
            ? []
            : List<String>.from(json["colors"].map((x) => x)),
        table: json["table"],
        fbranchId: int.parse(json["fbranchId"]),
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "name": name == null ? '#ee5253' : name,
        "channels": List<dynamic>.from(channels!.map((x) => x)),
        "colors":
            colors == null ? [] : List<dynamic>.from(colors!.map((x) => x)),
        "table": table,
        "fbranchId": int.parse(fbranchId.toString()),
        "active": active,
      };
}
