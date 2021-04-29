// To parse this JSON data, do
//
//     final unit = unitFromJson(jsonString);
library flipper_models;

import 'dart:convert';

Unit sunitFromJson(String str) => Unit.fromJson(json.decode(str));
String sunitToJson(Unit data) => json.encode(data.toJson());

List<Unit> unitFromJson(String str) =>
    List<Unit>.from(json.decode(str).map((x) => Unit.fromJson(x)));

String unitToJson(List<Unit> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Unit {
  Unit({
    required this.id,
    required this.branchId,
    required this.name,
    required this.table,
    required this.focused,
    required this.channels,
    this.units,
  });

  String id;
  String branchId;
  String name;
  String table;
  bool focused;
  List<String> channels;
  List<Map<String, dynamic>>? units;

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: json["id"],
        branchId: json["branchId"],
        name: json["name"],
        table: json["table"],
        focused: json["focused"],
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
        "focused": focused,
        "channels": List<dynamic>.from(channels.map((x) => x)),
        "units": units == null ? [] : List<dynamic>.from(units!.map((x) => x)),
      };
}
