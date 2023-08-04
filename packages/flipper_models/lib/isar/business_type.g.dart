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
      ..remoteID = json['remoteID'] as String?
      ..action = json['action'] as String
      ..localId = json['localId'] as int?
      ..lastTouched = json['lastTouched'] as String?;

Map<String, dynamic> _$BusinessTypeToJson(BusinessType instance) =>
    <String, dynamic>{
      'remoteID': instance.remoteID,
      'action': instance.action,
      'localId': instance.localId,
      'id': instance.id,
      'typeName': instance.typeName,
      'lastTouched': instance.lastTouched,
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
