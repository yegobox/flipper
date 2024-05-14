// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userActivity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserActivity _$UserActivityFromJson(Map<String, dynamic> json) => UserActivity(
      id: (json['id'] as num?)?.toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      userId: (json['userId'] as num).toInt(),
      action: json['action'] as String,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
    )..deletedAt = json['deletedAt'] == null
        ? null
        : DateTime.parse(json['deletedAt'] as String);

Map<String, dynamic> _$UserActivityToJson(UserActivity instance) =>
    <String, dynamic>{
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'timestamp': instance.timestamp.toIso8601String(),
      'id': instance.id,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'userId': instance.userId,
      'action': instance.action,
    };
