// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ITenant _$ITenantFromJson(Map<String, dynamic> json) => ITenant(
      id: json['id'] as String?,
      name: json['name'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'],
      imageUrl: json['imageUrl'],
      permissions: json['permissions'] as List<dynamic>?,
      branches: (json['branches'] as List<dynamic>?)
          ?.map((e) => IBranch.fromJson(e as Map<String, dynamic>))
          .toList(),
      businesses: (json['businesses'] as List<dynamic>?)
          ?.map((e) => IBusiness.fromJson(e as Map<String, dynamic>))
          .toList(),
      businessId: (json['businessId'] as num?)?.toInt(),
      nfcEnabled: json['nfcEnabled'] as bool?,
      userId: (json['userId'] as num?)?.toInt(),
      pin: (json['pin'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ITenantToJson(ITenant instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'imageUrl': instance.imageUrl,
      'permissions': instance.permissions,
      'branches': instance.branches,
      'businesses': instance.businesses,
      'businessId': instance.businessId,
      'nfcEnabled': instance.nfcEnabled,
      'userId': instance.userId,
      'pin': instance.pin,
    };
