library flipper_models;

import 'package:isar/isar.dart';
part 'points.g.dart';

@Collection()
class Points {
  Points({this.id = 0, required this.value, required this.userId});

  late int id = Isar.autoIncrement;
  int value;
  int userId;

  factory Points.fromJson(Map<String, dynamic> json) => Points(
        id: json["id"],
        value: json["value"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "value": value.toString(),
      };
}
