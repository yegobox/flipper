// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ITenant _$ITenantFromJson(Map<String, dynamic> json) => ITenant(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => IPermission.fromJson(e as Map<String, dynamic>))
          .toList(),
      branches: (json['branches'] as List<dynamic>)
          .map((e) => IBranch.fromJson(e as Map<String, dynamic>))
          .toList(),
      businesses: (json['businesses'] as List<dynamic>)
          .map((e) => IBusiness.fromJson(e as Map<String, dynamic>))
          .toList(),
      businessId: (json['businessId'] as num).toInt(),
      nfcEnabled: json['nfcEnabled'] as bool,
      userId: (json['userId'] as num).toInt(),
      isDefault: json['isDefault'] as bool,
      isLongPressed: json['isLongPressed'] as bool? ?? false,
      pin: (json['pin'] as num?)?.toInt(),
    );

const _$ITenantFieldMap = <String, String>{
  'id': 'id',
  'name': 'name',
  'phoneNumber': 'phoneNumber',
  'email': 'email',
  'permissions': 'permissions',
  'branches': 'branches',
  'businesses': 'businesses',
  'businessId': 'businessId',
  'nfcEnabled': 'nfcEnabled',
  'userId': 'userId',
  'pin': 'pin',
  'isDefault': 'isDefault',
  'isLongPressed': 'isLongPressed',
};

// ignore: unused_element
abstract class _$ITenantPerFieldToJson {
  // ignore: unused_element
  static Object? id(int instance) => instance;
  // ignore: unused_element
  static Object? name(String instance) => instance;
  // ignore: unused_element
  static Object? phoneNumber(String instance) => instance;
  // ignore: unused_element
  static Object? email(String? instance) => instance;
  // ignore: unused_element
  static Object? permissions(List<IPermission> instance) => instance;
  // ignore: unused_element
  static Object? branches(List<IBranch> instance) => instance;
  // ignore: unused_element
  static Object? businesses(List<IBusiness> instance) => instance;
  // ignore: unused_element
  static Object? businessId(int instance) => instance;
  // ignore: unused_element
  static Object? nfcEnabled(bool instance) => instance;
  // ignore: unused_element
  static Object? userId(int instance) => instance;
  // ignore: unused_element
  static Object? pin(int? instance) => instance;
  // ignore: unused_element
  static Object? isDefault(bool instance) => instance;
  // ignore: unused_element
  static Object? isLongPressed(bool instance) => instance;
}

Map<String, dynamic> _$ITenantToJson(ITenant instance) => <String, dynamic>{
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
      'pin': instance.pin,
      'isDefault': instance.isDefault,
      'isLongPressed': instance.isLongPressed,
    };
