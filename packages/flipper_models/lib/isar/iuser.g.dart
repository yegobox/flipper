// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iuser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IUser _$IUserFromJson(Map<String, dynamic> json) => IUser(
      id: json['id'] as int,
      phoneNumber: json['phoneNumber'] as String,
      token: json['token'] as String,
      tenants: (json['tenants'] as List<dynamic>)
          .map((e) => Tenant.fromJson(e as Map<String, dynamic>))
          .toList(),
      channels:
          (json['channels'] as List<dynamic>).map((e) => e as String).toList(),
      pin: json['pin'] as int?,
    );

Map<String, dynamic> _$IUserToJson(IUser instance) => <String, dynamic>{
      'id': instance.id,
      'phoneNumber': instance.phoneNumber,
      'token': instance.token,
      'tenants': instance.tenants,
      'channels': instance.channels,
      'pin': instance.pin,
    };

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
