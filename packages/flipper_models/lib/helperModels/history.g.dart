// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

History _$HistoryFromJson(Map<String, dynamic> json) => History(
      id: (json['id'] as num?)?.toInt(),
      modelId: (json['modelId'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      action: json['action'] as String,
    )
      ..deletedAt = json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String)
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String);

Map<String, dynamic> _$HistoryToJson(History instance) => <String, dynamic>{
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'id': instance.id,
      'modelId': instance.modelId,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'action': instance.action,
      'createdAt': instance.createdAt.toIso8601String(),
    };
