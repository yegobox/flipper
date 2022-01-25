library flipper_models;

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
