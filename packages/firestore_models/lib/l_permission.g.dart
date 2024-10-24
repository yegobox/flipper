// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'l_permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LPermissionImpl _$$LPermissionImplFromJson(Map<String, dynamic> json) =>
    _$LPermissionImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
    );

const _$$LPermissionImplFieldMap = <String, String>{
  'id': 'id',
  'name': 'name',
  'userId': 'userId',
};

// ignore: unused_element
abstract class _$$LPermissionImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? name(String? instance) => instance;
  // ignore: unused_element
  static Object? userId(int? instance) => instance;
}

Map<String, dynamic> _$$LPermissionImplToJson(_$LPermissionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'userId': instance.userId,
    };
