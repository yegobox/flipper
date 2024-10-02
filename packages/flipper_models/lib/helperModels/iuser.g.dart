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
      channels:
          (json['channels'] as List<dynamic>).map((e) => e as String).toList(),
      pin: (json['pin'] as num?)?.toInt(),
    );

const _$IUserFieldMap = <String, String>{
  'id': 'id',
  'phoneNumber': 'phoneNumber',
  'token': 'token',
  'uid': 'uid',
  'tenants': 'tenants',
  'channels': 'channels',
  'pin': 'pin',
};

// ignore: unused_element
abstract class _$IUserPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? phoneNumber(String instance) => instance;
  // ignore: unused_element
  static Object? token(String instance) => instance;
  // ignore: unused_element
  static Object? uid(String? instance) => instance;
  // ignore: unused_element
  static Object? tenants(List<ITenant> instance) => instance;
  // ignore: unused_element
  static Object? channels(List<String> instance) => instance;
  // ignore: unused_element
  static Object? pin(int? instance) => instance;
}

Map<String, dynamic> _$IUserToJson(IUser instance) => <String, dynamic>{
      'id': instance.id,
      'phoneNumber': instance.phoneNumber,
      'token': instance.token,
      'uid': instance.uid,
      'tenants': instance.tenants,
      'channels': instance.channels,
      'pin': instance.pin,
    };
