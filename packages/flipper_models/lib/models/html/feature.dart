class Feature {
  Feature({this.id = 0, required this.name});

  int id;
  String name;

  factory Feature.fromMap(Map<String, dynamic> json) => Feature(
        id: json["id"],
        name: json["name"],
      );
  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "name": name,
      };
}
