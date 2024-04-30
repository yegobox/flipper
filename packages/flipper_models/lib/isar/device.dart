library flipper_models;

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'DateTimeConverter.dart';
part 'device.g.dart';

@JsonSerializable()
@Collection()
class Device extends IJsonSerializable {
  Id? id;
  String linkingCode;
  String deviceName;
  String deviceVersion;
  bool pubNubPublished;
  String phone;
  int branchId;
  int businessId;
  int userId;
  String defaultApp;

  /// for sync

  @JsonKey(
      includeIfNull: true, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? lastTouched;

  String action;
  // only for accor when fetching from remove
  static DateTime? _dateTimeFromJson(String? json) {
    const dateTimeConverter = DateTimeConverter();
    return dateTimeConverter.fromJson(json);
  }

  static String? _dateTimeToJson(DateTime? dateTime) {
    const dateTimeConverter = DateTimeConverter();
    return dateTimeConverter.toJson(dateTime);
  }

  @Index()
  @JsonKey(
    includeIfNull: true,
    fromJson: _dateTimeFromJson,
    toJson: _dateTimeToJson,
  )
  DateTime? deletedAt;
  Device({
    required this.id,
    required this.action,
    required this.linkingCode,
    required this.deviceName,
    required this.deviceVersion,
    required this.pubNubPublished,
    required this.phone,
    required this.branchId,
    required this.businessId,
    required this.userId,
    required this.defaultApp,
    this.deletedAt,
  });
  factory Device.fromRecord(RecordModel record) =>
      Device.fromJson(record.toJson());

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}
