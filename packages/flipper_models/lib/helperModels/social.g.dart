// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Social _$SocialFromJson(Map<String, dynamic> json) => Social(
      id: (json['id'] as num?)?.toInt(),
      isAccountSet: json['isAccountSet'] as bool,
      socialType: json['socialType'] as String,
      branchId: (json['branchId'] as num).toInt(),
      message: json['message'] as String?,
      socialUrl: json['socialUrl'] as String,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    )..action = json['action'] as String;

const _$SocialFieldMap = <String, String>{
  'action': 'action',
  'id': 'id',
  'isAccountSet': 'isAccountSet',
  'socialType': 'socialType',
  'socialUrl': 'socialUrl',
  'branchId': 'branchId',
  'lastTouched': 'lastTouched',
  'message': 'message',
  'deletedAt': 'deletedAt',
};

// ignore: unused_element
abstract class _$SocialPerFieldToJson {
  // ignore: unused_element
  static Object? action(String instance) => instance;
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? isAccountSet(bool instance) => instance;
  // ignore: unused_element
  static Object? socialType(String instance) => instance;
  // ignore: unused_element
  static Object? socialUrl(String instance) => instance;
  // ignore: unused_element
  static Object? branchId(int instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? message(String? instance) => instance;
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
}

Map<String, dynamic> _$SocialToJson(Social instance) => <String, dynamic>{
      'action': instance.action,
      'id': instance.id,
      'isAccountSet': instance.isAccountSet,
      'socialType': instance.socialType,
      'socialUrl': instance.socialUrl,
      'branchId': instance.branchId,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'message': instance.message,
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
