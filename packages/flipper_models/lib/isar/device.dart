library flipper_models;

import 'package:flipper_models/isar/random.dart';
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
  int defaultApp;

  /// for sync

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;

  String action;
  // only for accor when fetching from remove

  @Index()
  DateTime? deletedAt;
  Device({
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

  factory Device.fromJson(Map<String, dynamic> json) {
    json['lastTouched'] =
        json['lastTouched'].toString().isEmpty || json['lastTouched'] == null
            ? DateTime.now().toIso8601String()
            : DateTime.parse(json['lastTouched'] ?? DateTime.now())
                .toIso8601String();

    return _$DeviceFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$DeviceToJson(this);
    if (id != null) {}
    return data;
  }
}
