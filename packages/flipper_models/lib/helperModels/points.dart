library flipper_models;

import 'package:json_annotation/json_annotation.dart';
part 'points.g.dart';

@JsonSerializable()
class Pointss {
  Pointss({required this.id, required this.value, required this.userId});

  int? id;
  int value;

  int userId;
}
