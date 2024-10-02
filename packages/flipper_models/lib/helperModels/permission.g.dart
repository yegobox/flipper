// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IPermission _$IPermissionFromJson(Map<String, dynamic> json) => IPermission(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      userId: (json['userId'] as num).toInt(),
    );

const _$IPermissionFieldMap = <String, String>{
  'id': 'id',
  'name': 'name',
  'userId': 'userId',
};

// ignore: unused_element
abstract class _$IPermissionPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? name(String instance) => instance;
  // ignore: unused_element
  static Object? userId(int instance) => instance;
}

Map<String, dynamic> _$IPermissionToJson(IPermission instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'userId': instance.userId,
    };
