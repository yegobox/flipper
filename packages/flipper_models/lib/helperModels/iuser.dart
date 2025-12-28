import 'package:flipper_models/helper_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'iuser.g.dart';

@JsonSerializable()
class IUser {
  IUser(
      {required this.id,
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
      this.pin});

  String id;
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
  @JsonKey(name: 'group_id')
  String? groupId;
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
