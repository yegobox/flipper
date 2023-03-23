library flipper_models;

import 'package:flipper_models/sync_service.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ichange.g.dart';

@JsonSerializable()
@Collection()
class IChange implements IJsonSerializable {
  Id? id = null;
  @Index()
  int branchId;
  @Index()
  int businessId;
  @Index()
  String? lastTouched;
  @Index()
  String model;
  bool? remoteChange;
  IChange(
      {required this.branchId,
      required this.model,
      required this.businessId,
      this.id,
      this.remoteChange,
      this.lastTouched});

  factory IChange.fromJson(Map<String, dynamic> json) =>
      _$IChangeFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$IChangeToJson(this);
}
