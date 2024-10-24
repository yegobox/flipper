// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configurations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConfigurationsImpl _$$ConfigurationsImplFromJson(Map<String, dynamic> json) =>
    _$ConfigurationsImpl(
      id: (json['id'] as num?)?.toInt(),
      taxType: json['taxType'] as String?,
      taxPercentage: (json['taxPercentage'] as num?)?.toDouble(),
      businessId: (json['businessId'] as num?)?.toInt(),
      branchId: (json['branchId'] as num?)?.toInt(),
    );

const _$$ConfigurationsImplFieldMap = <String, String>{
  'id': 'id',
  'taxType': 'taxType',
  'taxPercentage': 'taxPercentage',
  'businessId': 'businessId',
  'branchId': 'branchId',
};

// ignore: unused_element
abstract class _$$ConfigurationsImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? taxType(String? instance) => instance;
  // ignore: unused_element
  static Object? taxPercentage(double? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
}

Map<String, dynamic> _$$ConfigurationsImplToJson(
        _$ConfigurationsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taxType': instance.taxType,
      'taxPercentage': instance.taxPercentage,
      'businessId': instance.businessId,
      'branchId': instance.branchId,
    };
