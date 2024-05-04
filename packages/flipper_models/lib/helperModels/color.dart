library flipper_models;

import 'package:flipper_models/sync_service.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'color.g.dart';

@JsonSerializable()
class PColor extends IJsonSerializable {
  int? id;
  late String? name;
  List<String>? colors;
  late int? branchId;
  late bool active;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  String action;

  DateTime? deletedAt;
  PColor({
    required this.id,
    required this.name,
    this.colors,
    required this.branchId,
    required this.active,
    required this.lastTouched,
    required this.action,
    this.deletedAt,
  });
  factory PColor.fromRecord(RecordModel record) =>
      PColor.fromJson(record.toJson());
  factory PColor.fromJson(Map<String, dynamic> json) {
    return _$PColorFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$PColorToJson(this);
}
