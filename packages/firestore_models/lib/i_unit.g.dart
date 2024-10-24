// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'i_unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IUnitImpl _$$IUnitImplFromJson(Map<String, dynamic> json) => _$IUnitImpl(
      id: (json['id'] as num?)?.toInt(),
      branchId: (json['branchId'] as num?)?.toInt(),
      name: json['name'] as String?,
      value: json['value'] as String?,
      active: json['active'] as bool?,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      createdAt: json['createdAt'] as String?,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

const _$$IUnitImplFieldMap = <String, String>{
  'id': 'id',
  'branchId': 'branchId',
  'name': 'name',
  'value': 'value',
  'active': 'active',
  'lastTouched': 'lastTouched',
  'createdAt': 'createdAt',
  'deletedAt': 'deletedAt',
};

// ignore: unused_element
abstract class _$$IUnitImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? name(String? instance) => instance;
  // ignore: unused_element
  static Object? value(String? instance) => instance;
  // ignore: unused_element
  static Object? active(bool? instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? createdAt(String? instance) => instance;
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
}

Map<String, dynamic> _$$IUnitImplToJson(_$IUnitImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branchId': instance.branchId,
      'name': instance.name,
      'value': instance.value,
      'active': instance.active,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'createdAt': instance.createdAt,
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
