// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pointss _$PointssFromJson(Map<String, dynamic> json) => Pointss(
      id: (json['id'] as num?)?.toInt(),
      value: (json['value'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
    );

const _$PointssFieldMap = <String, String>{
  'id': 'id',
  'value': 'value',
  'userId': 'userId',
};

// ignore: unused_element
abstract class _$PointssPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? value(int instance) => instance;
  // ignore: unused_element
  static Object? userId(int instance) => instance;
}

Map<String, dynamic> _$PointssToJson(Pointss instance) => <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'userId': instance.userId,
    };
