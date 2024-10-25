// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityImpl _$$ActivityImplFromJson(Map<String, dynamic> json) =>
    _$ActivityImpl(
      id: (json['id'] as num?)?.toInt(),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      userId: (json['userId'] as num?)?.toInt(),
      event: json['event'] as String?,
      details: json['details'] as Map<String, dynamic>,
    );

const _$$ActivityImplFieldMap = <String, String>{
  'id': 'id',
  'timestamp': 'timestamp',
  'lastTouched': 'lastTouched',
  'userId': 'userId',
  'event': 'event',
  'details': 'details',
};

// ignore: unused_element
abstract class _$$ActivityImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? timestamp(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? userId(int? instance) => instance;
  // ignore: unused_element
  static Object? event(String? instance) => instance;
  // ignore: unused_element
  static Object? details(Map<String, dynamic> instance) => instance;
}

Map<String, dynamic> _$$ActivityImplToJson(_$ActivityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp?.toIso8601String(),
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'userId': instance.userId,
      'event': instance.event,
      'details': instance.details,
    };
