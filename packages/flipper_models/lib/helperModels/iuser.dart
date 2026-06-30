import 'package:flipper_models/helper_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'iuser.g.dart';

@JsonSerializable()
class IUser {
  IUser({
    required this.id,
    this.name,
    this.phoneNumber,
    this.token,
    this.uid,
    this.businesses,
    this.editId,
    this.isExternal,
    this.ownership,
    this.groupId,
    this.external,
    this.createdAt,
    this.updatedAt,
    this.pin,
  });

  String id;
  String? name;
  @JsonKey(name: 'phone_number')
  String? phoneNumber;
  String? token;

  /// enable user to be create from server and for this case uid will not exist.
  String? uid;
  List<IBusiness>? businesses;
  @JsonKey(name: 'edit_id')
  bool? editId;
  @JsonKey(name: 'is_external')
  bool? isExternal;
  String? ownership;
  @JsonKey(name: 'group_id', fromJson: _parseIntField)
  int? groupId;
  bool? external;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;
  int? pin;

  factory IUser.fromJson(Map<String, dynamic> json) {
    // Handle phone_number vs phoneNumber
    if (json.containsKey('phone_number') && !json.containsKey('phoneNumber')) {
      json['phoneNumber'] = json['phone_number'];
    }
    return _$IUserFromJson(json);
  }
  Map<String, dynamic> toJson() => _$IUserToJson(this);
}

/// POST `/v2/api/user` (flipper-turbo) serializes [group_id] as `"0"`.
/// Direct `get_user_with_nested_data` RPC (pin realignment) returns `0` (int).
int? _parseIntField(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
