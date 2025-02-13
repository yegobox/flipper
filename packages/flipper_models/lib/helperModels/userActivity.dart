library flipper_models;

import 'package:flipper_services/constants.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/sync_service.dart';

part 'userActivity.g.dart';

@JsonSerializable()
class Activity extends IJsonSerializable {
  DateTime timestamp;
  int? id;
  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;
  int userId;

  late String action;

  Activity(
      {required this.id,
      required this.timestamp,
      required this.userId,
      required this.action,
      this.lastTouched});

  factory Activity.fromJson(Map<String, dynamic> json) {
    /// assign remoteId to the value of id because this method is used to encode
    /// data from remote server and id from remote server is considered remoteId on local

    json['lastTouched'] =
        json['lastTouched'].toString().isEmpty || json['lastTouched'] == null
            ? DateTime.now()
            : DateTime.parse(json['lastTouched'] ?? DateTime.now())
                .toIso8601String();

    // this line ony added in both business and Log as they are not part of sync schemd
    json['action'] = AppActions.created;
    return _$ActivityFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}
