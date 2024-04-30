library flipper_models;

import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
part 'points.g.dart';

@JsonSerializable()
@Collection()
class Pointss {
  Pointss({required this.id, required this.value, required this.userId});

  Id? id;
  int value;
  @Index()
  short userId;
}
