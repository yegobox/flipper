// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tenant _$TenantFromJson(Map<String, dynamic> json) => Tenant(
      id: json['id'] as int,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => Permission.fromJson(e as Map<String, dynamic>))
          .toList(),
      branches: (json['branches'] as List<dynamic>)
          .map((e) => Branch.fromJson(e as Map<String, dynamic>))
          .toList(),
      businesses: (json['businesses'] as List<dynamic>)
          .map((e) => Business.fromJson(e as Map<String, dynamic>))
          .toList(),
      businessId: json['businessId'] as int,
      nfcEnabled: json['nfcEnabled'] as bool,
      userId: json['userId'] as int,
    );

Map<String, dynamic> _$TenantToJson(Tenant instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'permissions': instance.permissions,
      'branches': instance.branches,
      'businesses': instance.businesses,
      'businessId': instance.businessId,
      'nfcEnabled': instance.nfcEnabled,
      'userId': instance.userId,
    };
