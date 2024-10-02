// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Feature _$FeatureFromJson(Map<String, dynamic> json) => Feature(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
    );

const _$FeatureFieldMap = <String, String>{
  'id': 'id',
  'name': 'name',
};

// ignore: unused_element
abstract class _$FeaturePerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? name(String instance) => instance;
}

Map<String, dynamic> _$FeatureToJson(Feature instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
