library flipper_models;

import 'package:isar/isar.dart';
part 'points.g.dart';

@Collection()
class Pointss {
  Pointss({this.id = 0, required this.value, required this.userId});

  Id id = Isar.autoIncrement;
  int value;
  @Index()
  short userId;

  factory Pointss.fromJson(Map<String, dynamic> json) => Pointss(
        id: json["id"],
        value: json["value"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "value": value.toString(),
      };
}
