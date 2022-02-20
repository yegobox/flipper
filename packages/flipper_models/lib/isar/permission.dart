library flipper_models;

import 'package:isar/isar.dart';

part 'permission.g.dart';

@Collection()
class Permissionsync {
  Permissionsync({
    this.id = 0,
    required this.name,
  });
  late int id = Isar.autoIncrement;
  late String name;

  static fromJson(Map<String, dynamic> json) =>
      Permissionsync(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "name": name,
      };
}
