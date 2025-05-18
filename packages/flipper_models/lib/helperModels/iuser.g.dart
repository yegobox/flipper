// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iuser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IUser _$IUserFromJson(Map<String, dynamic> json) => IUser(
      id: (json['id'] as num?)?.toInt(),
      phoneNumber: json['phoneNumber'] as String,
      token: json['token'] as String,
      uid: json['uid'] as String?,
      tenants: (json['tenants'] as List<dynamic>)
          .map((e) => ITenant.fromJson(e as Map<String, dynamic>))
          .toList(),
      pin: (json['pin'] as num?)?.toInt(),
    );

Map<String, dynamic> _$IUserToJson(IUser instance) => <String, dynamic>{
      'id': instance.id,
      'phoneNumber': instance.phoneNumber,
      'token': instance.token,
      'uid': instance.uid,
      'tenants': instance.tenants,
      'pin': instance.pin,
    };
