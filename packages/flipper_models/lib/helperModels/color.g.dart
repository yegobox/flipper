// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PColor _$PColorFromJson(Map<String, dynamic> json) => PColor(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      colors:
          (json['colors'] as List<dynamic>?)?.map((e) => e as String).toList(),
      branchId: (json['branchId'] as num?)?.toInt(),
      active: json['active'] as bool,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      action: json['action'] as String,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

Map<String, dynamic> _$PColorToJson(PColor instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'colors': instance.colors,
      'branchId': instance.branchId,
      'active': instance.active,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'action': instance.action,
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
