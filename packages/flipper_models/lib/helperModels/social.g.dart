// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Social _$SocialFromJson(Map<String, dynamic> json) => Social(
      id: json['id'] as int?,
      isAccountSet: json['isAccountSet'] as bool,
      socialType: json['socialType'] as String,
      branchId: json['branchId'] as int,
      message: json['message'] as String?,
      socialUrl: json['socialUrl'] as String,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    )..action = json['action'] as String;

Map<String, dynamic> _$SocialToJson(Social instance) => <String, dynamic>{
      'action': instance.action,
      'id': instance.id,
      'isAccountSet': instance.isAccountSet,
      'socialType': instance.socialType,
      'socialUrl': instance.socialUrl,
      'branchId': instance.branchId,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'message': instance.message,
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
