library flipper_models;

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'history.g.dart';

/// this model serves to track changes that is happening inside
/// app, for example if we update,delete,create a model
/// we should keep this model updated as well
/// N.B for delete event, we only update the model only
/// when the model will no longer be accessible or recovered,
/// it is like delete forever in all node connected
@JsonSerializable()
@Collection()
class History extends IJsonSerializable {
  Id? id;
  late int modelId;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  String action;

  late DateTime createdAt;

  History(
      {required this.id,
      required this.modelId,
      required this.createdAt,
      required this.action});

  factory History.fromRecord(RecordModel record) =>
      History.fromJson(record.toJson());
  factory History.fromJson(Map<String, dynamic> json) {
    return _$HistoryFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$HistoryToJson(this);
    if (id != null) {}
    return data;
  }
}
