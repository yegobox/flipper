// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssetsImpl _$$AssetsImplFromJson(Map<String, dynamic> json) => _$AssetsImpl(
      id: (json['id'] as num?)?.toInt(),
      branchId: (json['branchId'] as num?)?.toInt(),
      businessId: (json['businessId'] as num?)?.toInt(),
      assetName: json['assetName'] as String?,
      productId: (json['productId'] as num?)?.toInt(),
    );

const _$$AssetsImplFieldMap = <String, String>{
  'id': 'id',
  'branchId': 'branchId',
  'businessId': 'businessId',
  'assetName': 'assetName',
  'productId': 'productId',
};

// ignore: unused_element
abstract class _$$AssetsImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? assetName(String? instance) => instance;
  // ignore: unused_element
  static Object? productId(int? instance) => instance;
}

Map<String, dynamic> _$$AssetsImplToJson(_$AssetsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branchId': instance.branchId,
      'businessId': instance.businessId,
      'assetName': instance.assetName,
      'productId': instance.productId,
    };
