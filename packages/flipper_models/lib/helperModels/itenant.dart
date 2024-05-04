library flipper_models;

import 'package:flipper_models/sync_service.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'itenant.g.dart';

@JsonSerializable()
class IITenant extends IJsonSerializable {
  int? id;
  String name;
  String phoneNumber;
  String? email;
  bool nfcEnabled;
  int businessId;
  int userId;
  String? imageUrl;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  DateTime? deletedAt;

  int? pin;

  /// [sessionActive] is not comming from server, this is to check which
  /// tenant is currently have active session but the main session will be still active
  bool? sessionActive;

  bool isDefault;

  ///helper property, these are property that are not peristed
  ///but used in ui to achieve some functionality

  bool isLongPressed;

  IITenant(
      {required this.id,
      required this.name,
      required this.phoneNumber,
      required this.email,
      required this.nfcEnabled,
      required this.businessId,
      required this.userId,
      required this.isDefault,
      this.deletedAt,
      this.sessionActive,
      this.isLongPressed = false,
      this.pin});
  factory IITenant.fromRecord(RecordModel record) =>
      IITenant.fromJson(record.toJson());

  factory IITenant.fromJson(Map<String, dynamic> json) =>
      _$IITenantFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$IITenantToJson(this);
}
