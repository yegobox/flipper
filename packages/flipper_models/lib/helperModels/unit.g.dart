// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IUnit _$IUnitFromJson(Map<String, dynamic> json) => IUnit(
      id: (json['id'] as num?)?.toInt(),
      branchId: (json['branchId'] as num).toInt(),
      name: json['name'] as String,
      value: json['value'] as String,
      active: json['active'] as bool,
      action: json['action'] as String,
      lastTouched: IUnit._dateTimeFromJson(json['lastTouched'] as String?),
    )..deletedAt = json['deletedAt'] == null
        ? null
        : DateTime.parse(json['deletedAt'] as String);

const _$IUnitFieldMap = <String, String>{
  'deletedAt': 'deletedAt',
  'id': 'id',
  'branchId': 'branchId',
  'name': 'name',
  'value': 'value',
  'active': 'active',
  'lastTouched': 'lastTouched',
  'action': 'action',
};

// ignore: unused_element
abstract class _$IUnitPerFieldToJson {
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int instance) => instance;
  // ignore: unused_element
  static Object? name(String instance) => instance;
  // ignore: unused_element
  static Object? value(String instance) => instance;
  // ignore: unused_element
  static Object? active(bool instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) =>
      IUnit._dateTimeToJson(instance);
  // ignore: unused_element
  static Object? action(String instance) => instance;
}

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
