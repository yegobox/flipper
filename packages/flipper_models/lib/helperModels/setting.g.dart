// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Setting _$SettingFromJson(Map<String, dynamic> json) => Setting(
      id: json['id'] as int?,
      email: json['email'] as String?,
      hasPin: json['hasPin'] as String?,
      userId: json['userId'] as int?,
      type: json['type'] as String?,
      autoPrint: json['autoPrint'] as bool?,
      openReceiptFileOSaleComplete:
          json['openReceiptFileOSaleComplete'] as bool?,
      sendDailyReport: json['sendDailyReport'] as bool?,
      defaultLanguage: json['defaultLanguage'] as String?,
      attendnaceDocCreated: json['attendnaceDocCreated'] as bool?,
      isAttendanceEnabled: json['isAttendanceEnabled'] as bool?,
      enrolledInBot: json['enrolledInBot'] as bool?,
      deviceToken: json['deviceToken'] as String?,
      businessPhoneNumber: json['businessPhoneNumber'] as String?,
      autoRespond: json['autoRespond'] as bool?,
      businessId: json['businessId'] as int?,
      createdAt: json['createdAt'] as String?,
      token: json['token'] as String?,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    )
      ..action = json['action'] as String
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String);

Map<String, dynamic> _$SettingToJson(Setting instance) => <String, dynamic>{
      'action': instance.action,
      'id': instance.id,
      'email': instance.email,
      'hasPin': instance.hasPin,
      'userId': instance.userId,
      'openReceiptFileOSaleComplete': instance.openReceiptFileOSaleComplete,
      'autoPrint': instance.autoPrint,
      'sendDailyReport': instance.sendDailyReport,
      'defaultLanguage': instance.defaultLanguage,
      'attendnaceDocCreated': instance.attendnaceDocCreated,
      'isAttendanceEnabled': instance.isAttendanceEnabled,
      'type': instance.type,
      'enrolledInBot': instance.enrolledInBot,
      'deviceToken': instance.deviceToken,
      'businessPhoneNumber': instance.businessPhoneNumber,
      'autoRespond': instance.autoRespond,
      'token': instance.token,
      'businessId': instance.businessId,
      'createdAt': instance.createdAt,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
