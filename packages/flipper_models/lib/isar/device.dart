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
  Id? id = null;
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
  @Index()
  String? lastTouched;
  @Index()
  String? remoteID;
  String? action;
  // only for accor when fetching from remove
  int? localId;

  Device(
      {required this.linkingCode,
      required this.deviceName,
      required this.deviceVersion,
      required this.pubNubPublished,
      required this.phone,
      required this.branchId,
      required this.businessId,
      required this.userId,
      required this.defaultApp});
  factory Device.fromRecord(RecordModel record) =>
      Device.fromJson(record.toJson());

  factory Device.fromJson(Map<String, dynamic> json) {
    json.remove('id');
    return _$DeviceFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$DeviceToJson(this);
    if (id != null) {
      data['localId'] = id;
    }
    return data;
  }

  void assignIdFromSync() {
    id = syncIdInt();
  }
}
