import 'package:flipper_models/helperModels/DateTimeConverter.dart';
import 'package:flipper_models/sync_service.dart';

import 'package:json_annotation/json_annotation.dart';

part 'unit.g.dart';

@JsonSerializable()
class IUnit extends IJsonSerializable {
  int? id;

  late int branchId;
  late String name;
  late String value;
  late bool active;

  @JsonKey(
      includeIfNull: true, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? lastTouched;

  late String action;

  static DateTime? _dateTimeFromJson(String? json) {
    const dateTimeConverter = DateTimeConverter();
    return dateTimeConverter.fromJson(json);
  }

  static String? _dateTimeToJson(DateTime? dateTime) {
    const dateTimeConverter = DateTimeConverter();
    return dateTimeConverter.toJson(dateTime);
  }

  // contructor
  IUnit(
      {required this.id,
      required this.branchId,
      required this.name,
      required this.value,
      required this.active,
      required this.action,
      this.lastTouched});
  // toString()
  @override
  String toString() {
    return 'IUnit{id: $id, branchId: $branchId, name: $name, value: $value, active: $active}';
  }

  factory IUnit.fromJson(Map<String, dynamic> json) => _$IUnitFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$IUnitToJson(this);
}
