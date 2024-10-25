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

Map<String, dynamic> _$IPermissionToJson(IPermission instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'userId': instance.userId,
    };
