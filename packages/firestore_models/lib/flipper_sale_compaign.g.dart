// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flipper_sale_compaign.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FlipperSaleCompaignImpl _$$FlipperSaleCompaignImplFromJson(
        Map<String, dynamic> json) =>
    _$FlipperSaleCompaignImpl(
      id: (json['id'] as num?)?.toInt(),
      compaignId: (json['compaignId'] as num?)?.toInt(),
      discountRate: (json['discountRate'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      couponCode: json['couponCode'] as String?,
    );

const _$$FlipperSaleCompaignImplFieldMap = <String, String>{
  'id': 'id',
  'compaignId': 'compaignId',
  'discountRate': 'discountRate',
  'createdAt': 'createdAt',
  'couponCode': 'couponCode',
};

// ignore: unused_element
abstract class _$$FlipperSaleCompaignImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? compaignId(int? instance) => instance;
  // ignore: unused_element
  static Object? discountRate(int? instance) => instance;
  // ignore: unused_element
  static Object? createdAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? couponCode(String? instance) => instance;
}

Map<String, dynamic> _$$FlipperSaleCompaignImplToJson(
        _$FlipperSaleCompaignImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'compaignId': instance.compaignId,
      'discountRate': instance.discountRate,
      'createdAt': instance.createdAt?.toIso8601String(),
      'couponCode': instance.couponCode,
    };
