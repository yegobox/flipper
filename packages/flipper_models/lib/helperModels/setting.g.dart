// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Setting _$SettingFromJson(Map<String, dynamic> json) => Setting(
      id: (json['id'] as num?)?.toInt(),
      email: json['email'] as String?,
      hasPin: json['hasPin'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
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
      businessId: (json['businessId'] as num?)?.toInt(),
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

const _$SettingFieldMap = <String, String>{
  'action': 'action',
  'id': 'id',
  'email': 'email',
  'hasPin': 'hasPin',
  'userId': 'userId',
  'openReceiptFileOSaleComplete': 'openReceiptFileOSaleComplete',
  'autoPrint': 'autoPrint',
  'sendDailyReport': 'sendDailyReport',
  'defaultLanguage': 'defaultLanguage',
  'attendnaceDocCreated': 'attendnaceDocCreated',
  'isAttendanceEnabled': 'isAttendanceEnabled',
  'type': 'type',
  'enrolledInBot': 'enrolledInBot',
  'deviceToken': 'deviceToken',
  'businessPhoneNumber': 'businessPhoneNumber',
  'autoRespond': 'autoRespond',
  'token': 'token',
  'businessId': 'businessId',
  'createdAt': 'createdAt',
  'lastTouched': 'lastTouched',
  'deletedAt': 'deletedAt',
};

// ignore: unused_element
abstract class _$SettingPerFieldToJson {
  // ignore: unused_element
  static Object? action(String instance) => instance;
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? email(String? instance) => instance;
  // ignore: unused_element
  static Object? hasPin(String? instance) => instance;
  // ignore: unused_element
  static Object? userId(int? instance) => instance;
  // ignore: unused_element
  static Object? openReceiptFileOSaleComplete(bool? instance) => instance;
  // ignore: unused_element
  static Object? autoPrint(bool? instance) => instance;
  // ignore: unused_element
  static Object? sendDailyReport(bool? instance) => instance;
  // ignore: unused_element
  static Object? defaultLanguage(String? instance) => instance;
  // ignore: unused_element
  static Object? attendnaceDocCreated(bool? instance) => instance;
  // ignore: unused_element
  static Object? isAttendanceEnabled(bool? instance) => instance;
  // ignore: unused_element
  static Object? type(String? instance) => instance;
  // ignore: unused_element
  static Object? enrolledInBot(bool? instance) => instance;
  // ignore: unused_element
  static Object? deviceToken(String? instance) => instance;
  // ignore: unused_element
  static Object? businessPhoneNumber(String? instance) => instance;
  // ignore: unused_element
  static Object? autoRespond(bool? instance) => instance;
  // ignore: unused_element
  static Object? token(String? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? createdAt(String? instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
}

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
