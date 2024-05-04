// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) => Device(
      id: json['id'] as int?,
      action: json['action'] as String,
      linkingCode: json['linkingCode'] as String,
      deviceName: json['deviceName'] as String,
      deviceVersion: json['deviceVersion'] as String,
      pubNubPublished: json['pubNubPublished'] as bool,
      phone: json['phone'] as String,
      branchId: json['branchId'] as int,
      businessId: json['businessId'] as int,
      userId: json['userId'] as int,
      defaultApp: json['defaultApp'] as String,
      deletedAt: Device._dateTimeFromJson(json['deletedAt'] as String?),
    )..lastTouched = Device._dateTimeFromJson(json['lastTouched'] as String?);

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
