library flipper_models;

import 'package:flipper_services/constants.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:pocketbase/pocketbase.dart';

part 'userActivity.g.dart';

@JsonSerializable()
@Collection()
class UserActivity extends IJsonSerializable {
  DateTime timestamp;
  Id? id;
  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;
  int userId;

  late String action;

  UserActivity(
      {required this.id,
      required this.timestamp,
      required this.userId,
      required this.action,
      this.lastTouched});

  factory UserActivity.fromRecord(RecordModel record) =>
      UserActivity.fromJson(record.toJson());

  factory UserActivity.fromJson(Map<String, dynamic> json) {
    /// assign remoteId to the value of id because this method is used to encode
    /// data from remote server and id from remote server is considered remoteId on local

    json['lastTouched'] =
        json['lastTouched'].toString().isEmpty || json['lastTouched'] == null
            ? DateTime.now().toIso8601String()
            : DateTime.parse(json['lastTouched'] ?? DateTime.now())
                .toIso8601String();

    // this line ony added in both business and UserActivity as they are not part of sync schemd
    json['action'] = AppActions.created;
    return _$UserActivityFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$UserActivityToJson(this);
}
