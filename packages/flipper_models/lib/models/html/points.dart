library flipper_models;

class Points {
  Points({this.id = 0, required this.value});

  int id;
  int value;

  factory Points.fromJson(Map<String, dynamic> json) => Points(
        id: json["id"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "value": value.toString(),
      };
}
