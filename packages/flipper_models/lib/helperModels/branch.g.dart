// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IBranch _$IBranchFromJson(Map<String, dynamic> json) => IBranch(
      id: json['id'] as String?,
      serverId: (json['serverId'] as num?)?.toInt(),
      active: json['active'] as bool?,
      description: json['description'] as String?,
      name: json['name'] as String?,
      businessId: (json['businessId'] as num?)?.toInt(),
      longitude: json['longitude'] as String?,
      latitude: json['latitude'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'],
      location: json['location'],
      isDefault: json['isDefault'] as bool?,
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
      'serverId': instance.serverId,
      'active': instance.active,
      'description': instance.description,
      'name': instance.name,
      'businessId': instance.businessId,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt,
      'location': instance.location,
      'isDefault': instance.isDefault,
      'branchDefault': instance.branchDefault,
    };
