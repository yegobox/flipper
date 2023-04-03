// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncF _$SyncFFromJson(Map<String, dynamic> json) => SyncF(
      id: json['id'] as int,
      phoneNumber: json['phoneNumber'] as String,
      token: json['token'] as String,
      tenants: (json['tenants'] as List<dynamic>)
          .map((e) => Tenant.fromJson(e as Map<String, dynamic>))
          .toList(),
      businesses: (json['businesses'] as List<dynamic>)
          .map((e) => Business.fromJson(e as Map<String, dynamic>))
          .toList(),
      channels:
          (json['channels'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SyncFToJson(SyncF instance) => <String, dynamic>{
      'id': instance.id,
      'phoneNumber': instance.phoneNumber,
      'token': instance.token,
      'tenants': instance.tenants,
      'businesses': instance.businesses,
      'channels': instance.channels,
    };
