library flipper_models;

import 'package:isar/isar.dart';

// part 'permission.dart';

// @Collection()
class Permissionsync {
  Permissionsync({
    this.id = 0,
    required this.name,
  });
  int id;
  String name;

  factory Permissionsync.fromJson(Map<String, dynamic> json) =>
      Permissionsync(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "name": name,
      };
}
