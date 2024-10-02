// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: (json['id'] as num?)?.toInt(),
      active: json['active'] as bool,
      focused: json['focused'] as bool,
      name: json['name'] as String,
      branchId: (json['branchId'] as num).toInt(),
    )
      ..action = json['action'] as String
      ..deletedAt = json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String)
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String);

const _$CategoryFieldMap = <String, String>{
  'action': 'action',
  'id': 'id',
  'active': 'active',
  'focused': 'focused',
  'name': 'name',
  'branchId': 'branchId',
  'deletedAt': 'deletedAt',
  'lastTouched': 'lastTouched',
};

// ignore: unused_element
abstract class _$CategoryPerFieldToJson {
  // ignore: unused_element
  static Object? action(String instance) => instance;
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? active(bool instance) => instance;
  // ignore: unused_element
  static Object? focused(bool instance) => instance;
  // ignore: unused_element
  static Object? name(String instance) => instance;
  // ignore: unused_element
  static Object? branchId(int instance) => instance;
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'action': instance.action,
      'id': instance.id,
      'active': instance.active,
      'focused': instance.focused,
      'name': instance.name,
      'branchId': instance.branchId,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'lastTouched': instance.lastTouched?.toIso8601String(),
    };
