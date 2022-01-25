library flipper_models;

import 'package:objectbox/objectbox.dart';

@Entity()
@Sync()
class Points {
  Points({
    this.id = 0,
    required this.value,
    required this.userId,
  });

  @Id(assignable: true)
  int id;
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
        "userId": userId.toString()
      };
}
