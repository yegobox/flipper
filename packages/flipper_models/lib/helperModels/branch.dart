library flipper_models;

import 'package:flipper_services/constants.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:pocketbase/pocketbase.dart';
part 'branch.g.dart';

@JsonSerializable()
class IBranch extends IJsonSerializable {
  IBranch({
    required this.isDefault,
    required this.action,
    required this.id,
    this.active,
    this.description,
    this.name,
    this.businessId,
    this.longitude,
    this.latitude,
    this.deletedAt,
    this.location,
  });
  IBranch.copy(IBranch other, {bool? active, String? name})
      : isDefault = other.isDefault,
        action = other.action,
        name = name ?? other.name,
        id = other.id,
        location = other.location,
        active = active ?? other.active;
  int? id;
  bool? active;

  String? description;
  String? name;
  int? businessId;
  String? longitude;
  String? latitude;
  String? location;

  late bool isDefault;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  String action;

  DateTime? deletedAt;
  factory IBranch.fromRecord(RecordModel record) =>
      IBranch.fromJson(record.toJson());

  factory IBranch.fromJson(Map<String, dynamic> json) {
    /// assign remoteId to the value of id because this method is used to encode
    /// data from remote server and id from remote server is considered remoteId on local

    json['lastTouched'] =
        json['lastTouched'].toString().isEmpty || json['lastTouched'] == null
            ? DateTime.now().toIso8601String()
            : DateTime.parse(json['lastTouched'] ?? DateTime.now())
                .toIso8601String();

    // this line ony added in both business and branch as they are not part of sync schemd
    json['action'] = AppActions.created;
    return _$IBranchFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$IBranchToJson(this);
}
