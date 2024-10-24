// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sku.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SKUImpl _$$SKUImplFromJson(Map<String, dynamic> json) => _$SKUImpl(
      id: (json['id'] as num?)?.toInt(),
      sku: (json['sku'] as num?)?.toInt(),
      branchId: (json['branchId'] as num?)?.toInt(),
      businessId: (json['businessId'] as num?)?.toInt(),
      consumed: json['consumed'] as bool?,
    );

const _$$SKUImplFieldMap = <String, String>{
  'id': 'id',
  'sku': 'sku',
  'branchId': 'branchId',
  'businessId': 'businessId',
  'consumed': 'consumed',
};

// ignore: unused_element
abstract class _$$SKUImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? sku(int? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? consumed(bool? instance) => instance;
}

Map<String, dynamic> _$$SKUImplToJson(_$SKUImpl instance) => <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'branchId': instance.branchId,
      'businessId': instance.businessId,
      'consumed': instance.consumed,
    };
