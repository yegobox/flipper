library flipper_models;

import 'package:isar/isar.dart';

part 'permission.g.dart';

@Collection()
class Permission {
  Permission({
    this.id = 0,
    required this.name,
  });
  Id id = Isar.autoIncrement;
  late String name;

  static fromJson(Map<dynamic, dynamic> json) =>
      Permission(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "name": name,
      };
}
