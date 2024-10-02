// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) => Device(
      id: (json['id'] as num?)?.toInt(),
      action: json['action'] as String,
      linkingCode: json['linkingCode'] as String,
      deviceName: json['deviceName'] as String,
      deviceVersion: json['deviceVersion'] as String,
      pubNubPublished: json['pubNubPublished'] as bool,
      phone: json['phone'] as String,
      branchId: (json['branchId'] as num).toInt(),
      businessId: (json['businessId'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      defaultApp: json['defaultApp'] as String,
      deletedAt: Device._dateTimeFromJson(json['deletedAt'] as String?),
    )..lastTouched = Device._dateTimeFromJson(json['lastTouched'] as String?);

const _$DeviceFieldMap = <String, String>{
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
  'action': 'action',
  'deletedAt': 'deletedAt',
};

// ignore: unused_element
abstract class _$DevicePerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? linkingCode(String instance) => instance;
  // ignore: unused_element
  static Object? deviceName(String instance) => instance;
  // ignore: unused_element
  static Object? deviceVersion(String instance) => instance;
  // ignore: unused_element
  static Object? pubNubPublished(bool instance) => instance;
  // ignore: unused_element
  static Object? phone(String instance) => instance;
  // ignore: unused_element
  static Object? branchId(int instance) => instance;
  // ignore: unused_element
  static Object? businessId(int instance) => instance;
  // ignore: unused_element
  static Object? userId(int instance) => instance;
  // ignore: unused_element
  static Object? defaultApp(String instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) =>
      Device._dateTimeToJson(instance);
  // ignore: unused_element
  static Object? action(String instance) => instance;
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) =>
      Device._dateTimeToJson(instance);
}

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
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
      'lastTouched': Device._dateTimeToJson(instance.lastTouched),
      'action': instance.action,
      'deletedAt': Device._dateTimeToJson(instance.deletedAt),
    };
