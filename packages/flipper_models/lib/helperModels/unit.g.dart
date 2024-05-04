// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IUnit _$IUnitFromJson(Map<String, dynamic> json) => IUnit(
      id: json['id'] as int?,
      branchId: json['branchId'] as int,
      name: json['name'] as String,
      value: json['value'] as String,
      active: json['active'] as bool,
      action: json['action'] as String,
      lastTouched: IUnit._dateTimeFromJson(json['lastTouched'] as String?),
    )..deletedAt = json['deletedAt'] == null
        ? null
        : DateTime.parse(json['deletedAt'] as String);

Map<String, dynamic> _$IUnitToJson(IUnit instance) => <String, dynamic>{
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'id': instance.id,
      'branchId': instance.branchId,
      'name': instance.name,
      'value': instance.value,
      'active': instance.active,
      'lastTouched': IUnit._dateTimeToJson(instance.lastTouched),
      'action': instance.action,
    };
