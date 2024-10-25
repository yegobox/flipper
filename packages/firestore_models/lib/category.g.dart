// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: (json['id'] as num?)?.toInt(),
      active: json['active'] as bool?,
      focused: json['focused'] as bool? ?? false,
      name: json['name'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
    );

const _$$CategoryImplFieldMap = <String, String>{
  'id': 'id',
  'active': 'active',
  'focused': 'focused',
  'name': 'name',
  'branchId': 'branchId',
  'deletedAt': 'deletedAt',
  'lastTouched': 'lastTouched',
};

// ignore: unused_element
abstract class _$$CategoryImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? active(bool? instance) => instance;
  // ignore: unused_element
  static Object? focused(bool instance) => instance;
  // ignore: unused_element
  static Object? name(String? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
}

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'active': instance.active,
      'focused': instance.focused,
      'name': instance.name,
      'branchId': instance.branchId,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'lastTouched': instance.lastTouched?.toIso8601String(),
    };
