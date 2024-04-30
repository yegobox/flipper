library flipper_models;

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'SyncRecord.g.dart';

/// this model will help us know the model that was pushed to the server
/// so that we don't try to push them unless they have update
@JsonSerializable()
@Collection()
class SyncRecord extends IJsonSerializable {
  Id? id;
  String modelId;
  DateTime createdAt;
  int branchId;

  SyncRecord(
      {required this.id,
      required this.modelId,
      required this.createdAt,
      required this.branchId});
  factory SyncRecord.fromRecord(RecordModel record) =>
      SyncRecord.fromJson(record.toJson());
  factory SyncRecord.fromJson(Map<String, dynamic> json) =>
      _$SyncRecordFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$SyncRecordToJson(this);
}
