// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PColor _$PColorFromJson(Map<String, dynamic> json) => PColor(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      colors:
          (json['colors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      branchId: (json['branchId'] as num?)?.toInt(),
      active: json['active'] as bool,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      action: json['action'] as String,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

const _$PColorFieldMap = <String, String>{
  'id': 'id',
  'name': 'name',
  'colors': 'colors',
  'branchId': 'branchId',
  'active': 'active',
  'lastTouched': 'lastTouched',
  'action': 'action',
  'deletedAt': 'deletedAt',
};

// ignore: unused_element
abstract class _$PColorPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? name(String? instance) => instance;
  // ignore: unused_element
  static Object? colors(List<String>? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? active(bool instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? action(String instance) => instance;
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
}

Map<String, dynamic> _$PColorToJson(PColor instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'colors': instance.colors,
      'branchId': instance.branchId,
      'active': instance.active,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'action': instance.action,
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
