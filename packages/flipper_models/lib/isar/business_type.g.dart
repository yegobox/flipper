// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessType _$BusinessTypeFromJson(Map<String, dynamic> json) => BusinessType(
      id: json['id'] as int,
      typeName: json['typeName'] as String,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    )
      ..remoteId = json['remoteId'] as String?
      ..action = json['action'] as String
      ..localId = json['localId'] as int?
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String);

Map<String, dynamic> _$BusinessTypeToJson(BusinessType instance) =>
    <String, dynamic>{
      'remoteId': instance.remoteId,
      'action': instance.action,
      'localId': instance.localId,
      'id': instance.id,
      'typeName': instance.typeName,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
