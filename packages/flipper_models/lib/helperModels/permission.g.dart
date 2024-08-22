// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IPermission _$IPermissionFromJson(Map<String, dynamic> json) => IPermission(
      id: json['id'] as int?,
      name: json['name'] as String,
      userId: json['userId'] as int,
    );

Map<String, dynamic> _$IPermissionToJson(IPermission instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'userId': instance.userId,
    };
