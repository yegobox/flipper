// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IBranch _$IBranchFromJson(Map<String, dynamic> json) => IBranch(
      id: json['id'] as String?,
      serverId: (json['server_id'] as num?)?.toInt(),
      active: json['active'] as bool?,
      description: json['description'] as String?,
      name: json['name'] as String?,
      businessId: (json['business_id'] as num?)?.toInt(),
      longitude: IBranch._parseStringField(json['longitude']),
      latitude: IBranch._parseStringField(json['latitude']),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'],
      location: IBranch._parseStringField(json['location']),
      isDefault: json['is_default'] as bool?,
      branchDefault: json['branchDefault'] as bool?,
    )
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String)
      ..deletedAt = json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String)
      ..action = json['action'] as String;

Map<String, dynamic> _$IBranchToJson(IBranch instance) => <String, dynamic>{
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'action': instance.action,
      'id': instance.id,
      'server_id': instance.serverId,
      'active': instance.active,
      'description': instance.description,
      'name': instance.name,
      'business_id': instance.businessId,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt,
      'location': instance.location,
      'is_default': instance.isDefault,
      'branchDefault': instance.branchDefault,
    };
