library flipper_models;

import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'permission.g.dart';

@JsonSerializable()
@Collection()
class Permission {
  Permission({
    required this.id,
    required this.name,
  });
  late int id;
  late String name;

  factory Permission.fromRecord(RecordModel record) =>
      Permission.fromJson(record.toJson());

  factory Permission.fromJson(Map<String, dynamic> json) =>
      _$PermissionFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionToJson(this);
}
