library flipper_models;

import 'package:isar/isar.dart';
part 'color.g.dart';

@Collection()
class PColor {
  PColor({
    this.id = 0,
    this.name,
    this.channels,
    this.colors,
    required this.table,
    this.fbranchId,
    required this.active,
  });
  late int id = Isar.autoIncrement;
  late String? name;
  List<String>? channels;

  List<String>? colors;
  late String table;
  late int? fbranchId;
  late bool active;

  factory PColor.fromJson(Map<String, dynamic> json) => PColor(
        id: int.parse(json["id"]),
        name: json["name"] ?? '#ee5253',
        colors: json["colors"] == null
            ? []
            : List<String>.from(json["colors"].map((x) => x)),
        table: json["table"],
        fbranchId: int.parse(json["fbranchId"]),
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": int.parse(id.toString()),
        "name": name ?? '#ee5253',
        "colors":
            colors == null ? [] : List<dynamic>.from(colors!.map((x) => x)),
        "table": table,
        "fbranchId": int.parse(fbranchId.toString()),
        "active": active,
      };
}
