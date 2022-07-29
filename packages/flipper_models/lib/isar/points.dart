library flipper_models;

import 'package:isar/isar.dart';
part 'points.g.dart';

@Collection()
class IPoint {
  IPoint({this.id = 0, required this.value, required this.userId});

  Id id = Isar.autoIncrement;
  int value;
  @Index()
  short userId;

  factory IPoint.fromJson(Map<String, dynamic> json) => IPoint(
        id: json["id"],
        value: json["value"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "value": value.toString(),
      };
}
