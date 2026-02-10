library flipper_models;

import 'package:flipper_models/helperModels/iaccess.dart';
import 'package:flipper_services/constants.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/sync_service.dart';
part 'branch.g.dart';

@JsonSerializable()
class IBranch extends IJsonSerializable {
  IBranch({
    this.id,
    this.serverId,
    this.description,
    this.name,
    this.businessId,
    this.longitude,
    this.latitude,
    this.createdAt,
    this.updatedAt,
    this.location,
    this.isDefault,
    this.branchDefault,
    this.accesses,
  });
  IBranch.copy(IBranch other, {bool? active, String? name})
    : isDefault = other.isDefault,
      name = name ?? other.name,
      id = other.id,
      location = other.location,
      branchDefault = other.branchDefault,
      accesses = other.accesses,
      businessId = other.businessId,
      createdAt = other.createdAt,
      description = other.description,
      latitude = other.latitude,
      longitude = other.longitude,
      updatedAt = other.updatedAt;
  String? id;
  int? serverId;
  String? description;
  String? name;
  String? businessId;
  num? longitude;
  num? latitude;
  DateTime? createdAt;
  dynamic updatedAt;
  @JsonKey(fromJson: _parseStringField)
  dynamic location;
  bool? isDefault;
  bool? branchDefault;
  List<IAccess>? accesses;

  factory IBranch.fromJson(Map<String, dynamic> json) {
    /// assign remoteId to the value of id because this method is used to encode
    /// data from remote server and id from remote server is considered remoteId on local

    // Handle both camelCase and snake_case field names for compatibility
    // Map snake_case to camelCase for json_serializable
    if (json.containsKey('server_id') || !json.containsKey('serverId')) {
      json['serverId'] = json['server_id'];
    }
    if (json.containsKey('business_id') || !json.containsKey('businessId')) {
      json['businessId'] = json['business_id'];
    }
    if (json.containsKey('is_default') || !json.containsKey('isDefault')) {
      json['isDefault'] = json['is_default'];
    }
    if (json.containsKey('created_at') || !json.containsKey('createdAt')) {
      json['createdAt'] = json['created_at'];
    }
    if (json.containsKey('updated_at') || !json.containsKey('updatedAt')) {
      json['updatedAt'] = json['updated_at'];
    }

    json['lastTouched'] =
        (json['lastTouched'] == null || json['lastTouched'].toString().isEmpty)
        ? DateTime.now().toIso8601String()
        : (json['lastTouched'] is String
              ? json['lastTouched']
              : DateTime.parse(
                  json['lastTouched'].toString(),
                ).toIso8601String());

    // this line ony added in both business and branch as they are not part of sync schemd
    json['action'] = AppActions.created;

    // Handle latitude/longitude/serverId that might come as strings from API
    if (json['latitude'] is String) {
      json['latitude'] = num.tryParse(json['latitude']);
    }
    if (json['longitude'] is String) {
      json['longitude'] = num.tryParse(json['longitude']);
    }
    if (json['serverId'] is String) {
      json['serverId'] = int.tryParse(json['serverId']);
    }

    return _$IBranchFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$IBranchToJson(this);

  /// Helper method to parse string fields that might be "null"
  static String? _parseStringField(dynamic value) {
    if (value == null) return null;
    if (value == 'null' || value.toString().toLowerCase() == 'null') {
      return null;
    }
    return value.toString();
  }
}
