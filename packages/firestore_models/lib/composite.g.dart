// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'composite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompositeImpl _$$CompositeImplFromJson(Map<String, dynamic> json) =>
    _$CompositeImpl(
      id: (json['id'] as num?)?.toInt(),
      productId: (json['productId'] as num?)?.toInt(),
      variantId: (json['variantId'] as num?)?.toInt(),
      qty: (json['qty'] as num?)?.toDouble(),
      branchId: (json['branchId'] as num?)?.toInt(),
      businessId: (json['businessId'] as num?)?.toInt(),
      actualPrice: (json['actualPrice'] as num?)?.toDouble(),
    );

const _$$CompositeImplFieldMap = <String, String>{
  'id': 'id',
  'productId': 'productId',
  'variantId': 'variantId',
  'qty': 'qty',
  'branchId': 'branchId',
  'businessId': 'businessId',
  'actualPrice': 'actualPrice',
};

// ignore: unused_element
abstract class _$$CompositeImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? productId(int? instance) => instance;
  // ignore: unused_element
  static Object? variantId(int? instance) => instance;
  // ignore: unused_element
  static Object? qty(double? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? actualPrice(double? instance) => instance;
}

Map<String, dynamic> _$$CompositeImplToJson(_$CompositeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'variantId': instance.variantId,
      'qty': instance.qty,
      'branchId': instance.branchId,
      'businessId': instance.businessId,
      'actualPrice': instance.actualPrice,
    };
