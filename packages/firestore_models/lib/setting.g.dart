// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingImpl _$$SettingImplFromJson(Map<String, dynamic> json) =>
    _$SettingImpl(
      id: (json['id'] as num?)?.toInt(),
      email: json['email'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      businessId: (json['businessId'] as num?)?.toInt(),
      businessPhoneNumber: json['businessPhoneNumber'] as String?,
      token: json['token'] as String?,
      deviceToken: json['deviceToken'] as String?,
      openReceiptFileOSaleComplete:
          json['openReceiptFileOSaleComplete'] as bool? ?? false,
      autoPrint: json['autoPrint'] as bool? ?? false,
      sendDailyReport: json['sendDailyReport'] as bool? ?? false,
      defaultLanguage: json['defaultLanguage'] as String?,
      attendnaceDocCreated: json['attendnaceDocCreated'] as bool? ?? false,
      isAttendanceEnabled: json['isAttendanceEnabled'] as bool? ?? false,
      type: json['type'] as String?,
      enrolledInBot: json['enrolledInBot'] as bool? ?? false,
      autoRespond: json['autoRespond'] as bool? ?? false,
      hasPin: json['hasPin'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

const _$$SettingImplFieldMap = <String, String>{
  'id': 'id',
  'email': 'email',
  'userId': 'userId',
  'businessId': 'businessId',
  'businessPhoneNumber': 'businessPhoneNumber',
  'token': 'token',
  'deviceToken': 'deviceToken',
  'openReceiptFileOSaleComplete': 'openReceiptFileOSaleComplete',
  'autoPrint': 'autoPrint',
  'sendDailyReport': 'sendDailyReport',
  'defaultLanguage': 'defaultLanguage',
  'attendnaceDocCreated': 'attendnaceDocCreated',
  'isAttendanceEnabled': 'isAttendanceEnabled',
  'type': 'type',
  'enrolledInBot': 'enrolledInBot',
  'autoRespond': 'autoRespond',
  'hasPin': 'hasPin',
  'createdAt': 'createdAt',
  'lastTouched': 'lastTouched',
  'deletedAt': 'deletedAt',
};

// ignore: unused_element
abstract class _$$SettingImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? email(String? instance) => instance;
  // ignore: unused_element
  static Object? userId(int? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? businessPhoneNumber(String? instance) => instance;
  // ignore: unused_element
  static Object? token(String? instance) => instance;
  // ignore: unused_element
  static Object? deviceToken(String? instance) => instance;
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
  static Object? autoRespond(bool? instance) => instance;
  // ignore: unused_element
  static Object? hasPin(bool instance) => instance;
  // ignore: unused_element
  static Object? createdAt(String? instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
}

Map<String, dynamic> _$$SettingImplToJson(_$SettingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'userId': instance.userId,
      'businessId': instance.businessId,
      'businessPhoneNumber': instance.businessPhoneNumber,
      'token': instance.token,
      'deviceToken': instance.deviceToken,
      'openReceiptFileOSaleComplete': instance.openReceiptFileOSaleComplete,
      'autoPrint': instance.autoPrint,
      'sendDailyReport': instance.sendDailyReport,
      'defaultLanguage': instance.defaultLanguage,
      'attendnaceDocCreated': instance.attendnaceDocCreated,
      'isAttendanceEnabled': instance.isAttendanceEnabled,
      'type': instance.type,
      'enrolledInBot': instance.enrolledInBot,
      'autoRespond': instance.autoRespond,
      'hasPin': instance.hasPin,
      'createdAt': instance.createdAt,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
