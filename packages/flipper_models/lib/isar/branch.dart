library flipper_models;

import 'package:flipper_services/constants.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:pocketbase/pocketbase.dart';
part 'branch.g.dart';

@JsonSerializable()
@Collection()
class Branch extends IJsonSerializable {
  Branch({
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
  });
  Branch.copy(Branch other, {bool? active, String? name})
      : isDefault = other.isDefault,
        action = other.action,
        name = name ?? other.name,
        id = other.id,
        active = active ?? other.active;
  Id? id;
  bool? active;

  String? description;
  String? name;
  int? businessId;
  String? longitude;
  String? latitude;

  late bool isDefault;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  String action;

  @Index()
  DateTime? deletedAt;
  factory Branch.fromRecord(RecordModel record) =>
      Branch.fromJson(record.toJson());

  factory Branch.fromJson(Map<String, dynamic> json) {
    /// assign remoteId to the value of id because this method is used to encode
    /// data from remote server and id from remote server is considered remoteId on local

    json['lastTouched'] =
        json['lastTouched'].toString().isEmpty || json['lastTouched'] == null
            ? DateTime.now().toIso8601String()
            : DateTime.parse(json['lastTouched'] ?? DateTime.now())
                .toIso8601String();

    // this line ony added in both business and branch as they are not part of sync schemd
    json['action'] = AppActions.created;
    return _$BranchFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$BranchToJson(this);
}
