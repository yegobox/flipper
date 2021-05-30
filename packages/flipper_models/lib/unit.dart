// To parse this JSON data, do
//
//     final unit = unitFromJson(jsonString);

library flipper_models;

import 'package:objectbox/objectbox.dart';
import 'dart:convert';

Unit sunitFromJson(String str) => Unit.fromJson(json.decode(str));
String sunitToJson(Unit data) => json.encode(data.toJson());

List<Unit> unitFromJson(String str) =>
    List<Unit>.from(json.decode(str).map((x) => Unit.fromJson(x)));

String unitToJson(List<Unit> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity()
class Unit {
  Unit(
      {this.id = 0,
      required this.branchId,
      required this.name,
      this.value,
      required this.table,
      required this.active,
      this.channels,
      this.units});
  @Id(assignable: true)
  int id;
  int branchId;
  String name;
  String? value;
  String table;
  bool active;
  List<dynamic>? channels;
  List<Map<String, dynamic>>? units;

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: int.parse(json["id"]),
        value: json["value"],
        branchId: int.parse(json["branchId"]),
        name: json["name"],
        table: json["table"],
        active: json["active"],
        channels: List<String>.from(json["channels"].map((x) => x)),
        units: json["units"] == null
            ? []
            : List<Map<String, dynamic>>.from(json["units"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "branchId": int.parse(branchId.toString()),
        "name": name,
        "table": table,
        "active": active,
        "channels": List<dynamic>.from(channels!.map((x) => x)),
        "units": units == null ? [] : List<dynamic>.from(units!.map((x) => x)),
      };
}
