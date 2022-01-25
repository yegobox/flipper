import 'dart:convert';

Unit sunitFromJson(String str) => Unit.fromJson(json.decode(str));
String sunitToJson(Unit data) => json.encode(data.toJson());

List<Unit> unitFromJson(String str) =>
    List<Unit>.from(json.decode(str).map((x) => Unit.fromJson(x)));

String unitToJson(List<Unit> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Unit {
  int id;
  int? fbranchId;
  String name;
  String value;
  String table;
  bool active;
  List<String>? channels;

  List<Map<String, dynamic>>? units;

  Unit({
    this.id = 0,
    this.fbranchId,
    required this.name,
    required this.value,
    required this.table,
    required this.active,
    this.channels,
    this.units,
  });
  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: json["id"],
        value: json["value"],
        fbranchId: json["branchId"],
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
        "branchId": fbranchId,
        "name": name,
        "table": table,
        "value": value,
        "active": active,
        "units": units == null ? [] : List<dynamic>.from(units!.map((x) => x)),
      };
}
