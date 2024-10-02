// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessType _$BusinessTypeFromJson(Map<String, dynamic> json) => BusinessType(
      id: json['id'] as String,
      typeName: json['typeName'] as String,
    );

const _$BusinessTypeFieldMap = <String, String>{
  'id': 'id',
  'typeName': 'typeName',
};

// ignore: unused_element
abstract class _$BusinessTypePerFieldToJson {
  // ignore: unused_element
  static Object? id(String instance) => instance;
  // ignore: unused_element
  static Object? typeName(String instance) => instance;
}

Map<String, dynamic> _$BusinessTypeToJson(BusinessType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'typeName': instance.typeName,
    };
