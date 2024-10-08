// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IBranch _$IBranchFromJson(Map<String, dynamic> json) => IBranch(
      isDefault: json['isDefault'] as bool,
      action: json['action'] as String,
      id: json['id'] as int?,
      active: json['active'] as bool?,
      description: json['description'] as String?,
      name: json['name'] as String?,
      businessId: json['businessId'] as int?,
      longitude: json['longitude'] as String?,
      latitude: json['latitude'] as String?,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      location: json['location'] as String?,
    )..lastTouched = json['lastTouched'] == null
        ? null
        : DateTime.parse(json['lastTouched'] as String);

Map<String, dynamic> _$IBranchToJson(IBranch instance) => <String, dynamic>{
      'id': instance.id,
      'active': instance.active,
      'description': instance.description,
      'name': instance.name,
      'businessId': instance.businessId,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'location': instance.location,
      'isDefault': instance.isDefault,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'action': instance.action,
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
