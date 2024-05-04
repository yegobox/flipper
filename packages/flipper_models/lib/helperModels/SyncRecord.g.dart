// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SyncRecord.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncRecord _$SyncRecordFromJson(Map<String, dynamic> json) => SyncRecord(
      id: json['id'] as int?,
      modelId: json['modelId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      branchId: json['branchId'] as int,
    )
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String)
      ..deletedAt = json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String)
      ..action = json['action'] as String;

Map<String, dynamic> _$SyncRecordToJson(SyncRecord instance) =>
    <String, dynamic>{
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'action': instance.action,
      'id': instance.id,
      'modelId': instance.modelId,
      'createdAt': instance.createdAt.toIso8601String(),
      'branchId': instance.branchId,
    };
