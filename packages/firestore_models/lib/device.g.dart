// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeviceImpl _$$DeviceImplFromJson(Map<String, dynamic> json) => _$DeviceImpl(
      id: (json['id'] as num?)?.toInt(),
      linkingCode: json['linkingCode'] as String?,
      deviceName: json['deviceName'] as String?,
      deviceVersion: json['deviceVersion'] as String?,
      pubNubPublished: json['pubNubPublished'] as bool?,
      phone: json['phone'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
      businessId: (json['businessId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      defaultApp: json['defaultApp'] as String?,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

const _$$DeviceImplFieldMap = <String, String>{
  'id': 'id',
  'linkingCode': 'linkingCode',
  'deviceName': 'deviceName',
  'deviceVersion': 'deviceVersion',
  'pubNubPublished': 'pubNubPublished',
  'phone': 'phone',
  'branchId': 'branchId',
  'businessId': 'businessId',
  'userId': 'userId',
  'defaultApp': 'defaultApp',
  'lastTouched': 'lastTouched',
  'deletedAt': 'deletedAt',
};

// ignore: unused_element
abstract class _$$DeviceImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? linkingCode(String? instance) => instance;
  // ignore: unused_element
  static Object? deviceName(String? instance) => instance;
  // ignore: unused_element
  static Object? deviceVersion(String? instance) => instance;
  // ignore: unused_element
  static Object? pubNubPublished(bool? instance) => instance;
  // ignore: unused_element
  static Object? phone(String? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? userId(int? instance) => instance;
  // ignore: unused_element
  static Object? defaultApp(String? instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
}

Map<String, dynamic> _$$DeviceImplToJson(_$DeviceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'linkingCode': instance.linkingCode,
      'deviceName': instance.deviceName,
      'deviceVersion': instance.deviceVersion,
      'pubNubPublished': instance.pubNubPublished,
      'phone': instance.phone,
      'branchId': instance.branchId,
      'businessId': instance.businessId,
      'userId': instance.userId,
      'defaultApp': instance.defaultApp,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
