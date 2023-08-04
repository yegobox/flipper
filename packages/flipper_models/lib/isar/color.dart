library flipper_models;

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'color.g.dart';

@JsonSerializable()
@Collection()
class PColor extends IJsonSerializable {
  Id? id;
  late String? name;
  List<String>? colors;
  late int? branchId;
  late bool active;
  @Index()
  String? lastTouched;
  @Index()
  String? remoteID;
  String action;
  int? localId;
  @Index()
  DateTime? deletedAt;
  PColor({
    this.id,
    required this.name,
    this.colors,
    required this.branchId,
    required this.active,
    this.lastTouched,
    this.remoteID,
    required this.action,
    this.localId,
    this.deletedAt,
  });
  factory PColor.fromRecord(RecordModel record) =>
      PColor.fromJson(record.toJson());
  factory PColor.fromJson(Map<String, dynamic> json) {
    json.remove('id');
    return _$PColorFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$PColorToJson(this);
    if (id != null) {
      data['localId'] = id;
    }
    return data;
  }
}
