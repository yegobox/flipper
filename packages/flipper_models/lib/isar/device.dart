library flipper_models;

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'device.g.dart';

@JsonSerializable()
@Collection()
class Device extends IJsonSerializable {
  Id? id = Isar.autoIncrement;
  String linkingCode;
  String deviceName;
  String deviceVersion;
  int busienssId;
  bool pubNubPublished;
  String phone;
  int branchId;
  int businessId;
  int userId;
  int defaultApp;

  Device(
      {required this.linkingCode,
      required this.deviceName,
      required this.deviceVersion,
      required this.pubNubPublished,
      required this.phone,
      required this.branchId,
      required this.businessId,
      required this.userId,
      required this.defaultApp,
      required this.busienssId});
  factory Device.fromRecord(RecordModel record) =>
      Device.fromJson(record.toJson());

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}
