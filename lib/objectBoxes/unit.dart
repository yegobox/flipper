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
      {required this.id,
      required this.branchId,
      required this.name,
      required this.table,
      required this.active,
      required this.channels,
      this.units,
      required this.ids});

  @Id()
  int ids;

  String id;
  String branchId;
  String name;
  String table;
  bool active;
  List<String> channels;
  List<Map<String, dynamic>>? units;

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: json["id"],
        ids: json["ids"],
        branchId: json["branchId"],
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
        "branchId": branchId,
        "name": name,
        "table": table,
        "active": active,
        "channels": List<dynamic>.from(channels.map((x) => x)),
        "units": units == null ? [] : List<dynamic>.from(units!.map((x) => x)),
      };
}
