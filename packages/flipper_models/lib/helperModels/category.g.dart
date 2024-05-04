// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: json['id'] as int?,
      active: json['active'] as bool,
      focused: json['focused'] as bool,
      name: json['name'] as String,
      branchId: json['branchId'] as int,
    )
      ..action = json['action'] as String
      ..deletedAt = json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String)
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'action': instance.action,
      'id': instance.id,
      'active': instance.active,
      'focused': instance.focused,
      'name': instance.name,
      'branchId': instance.branchId,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'lastTouched': instance.lastTouched?.toIso8601String(),
    };
