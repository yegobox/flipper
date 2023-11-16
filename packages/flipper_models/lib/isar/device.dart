library flipper_models;

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'device.g.dart';

@JsonSerializable()
@Collection()
class Device extends IJsonSerializable {
  late String id;
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

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  String action;
  // only for accor when fetching from remove

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

  // Custom converter for DateTime field
  static DateTime? _dateTimeFromJson(dynamic value) {
    if (value == null || value is DateTime) {
      return value;
    } else if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        // Handle parsing error, return null or handle accordingly
      }
    }
    return null;
  }

  static dynamic _dateTimeToJson(DateTime? value) {
    return value?.toIso8601String();
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    json['lastTouched'] =
        json['lastTouched'].toString().isEmpty || json['lastTouched'] == null
            ? DateTime.now().toIso8601String()
            : DateTime.parse(json['lastTouched'] ?? DateTime.now())
                .toIso8601String();

    return _$DeviceFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}
