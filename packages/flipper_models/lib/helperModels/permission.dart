library flipper_models;

import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'permission.g.dart';

@JsonSerializable()
class IPermission {
  IPermission({
    required this.id,
    required this.name,
    required this.userId,
  });
  int? id;
  late String name;
  late int userId;

  factory IPermission.fromRecord(RecordModel record) =>
      IPermission.fromJson(record.toJson());

  factory IPermission.fromJson(Map<String, dynamic> json) =>
      _$IPermissionFromJson(json);

  Map<String, dynamic> toJson() => _$IPermissionToJson(this);
}
