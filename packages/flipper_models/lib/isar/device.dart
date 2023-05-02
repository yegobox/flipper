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

  Device(
      {required this.linkingCode,
      required this.deviceName,
      required this.deviceVersion});
  factory Device.fromRecord(RecordModel record) =>
      Device.fromJson(record.toJson());

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}
