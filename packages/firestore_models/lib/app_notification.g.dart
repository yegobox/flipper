// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppNotificationImpl _$$AppNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$AppNotificationImpl(
      id: (json['id'] as num?)?.toInt(),
      completed: json['completed'] as bool,
      type: json['type'] as String?,
      message: json['message'] as String?,
      identifier: (json['identifier'] as num?)?.toInt(),
    );

const _$$AppNotificationImplFieldMap = <String, String>{
  'id': 'id',
  'completed': 'completed',
  'type': 'type',
  'message': 'message',
  'identifier': 'identifier',
};

// ignore: unused_element
abstract class _$$AppNotificationImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? completed(bool instance) => instance;
  // ignore: unused_element
  static Object? type(String? instance) => instance;
  // ignore: unused_element
  static Object? message(String? instance) => instance;
  // ignore: unused_element
  static Object? identifier(int? instance) => instance;
}

Map<String, dynamic> _$$AppNotificationImplToJson(
        _$AppNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'completed': instance.completed,
      'type': instance.type,
      'message': instance.message,
      'identifier': instance.identifier,
    };
