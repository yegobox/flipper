// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'universal_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UniversalProductImpl _$$UniversalProductImplFromJson(
        Map<String, dynamic> json) =>
    _$UniversalProductImpl(
      id: (json['id'] as num?)?.toInt(),
      itemClsCd: json['itemClsCd'] as String?,
      itemClsNm: json['itemClsNm'] as String?,
      itemClsLvl: (json['itemClsLvl'] as num?)?.toInt(),
      taxTyCd: json['taxTyCd'] as String?,
      mjrTgYn: json['mjrTgYn'] as String?,
      useYn: json['useYn'] as String?,
      businessId: (json['businessId'] as num?)?.toInt(),
      branchId: (json['branchId'] as num?)?.toInt(),
    );

const _$$UniversalProductImplFieldMap = <String, String>{
  'id': 'id',
  'itemClsCd': 'itemClsCd',
  'itemClsNm': 'itemClsNm',
  'itemClsLvl': 'itemClsLvl',
  'taxTyCd': 'taxTyCd',
  'mjrTgYn': 'mjrTgYn',
  'useYn': 'useYn',
  'businessId': 'businessId',
  'branchId': 'branchId',
};

// ignore: unused_element
abstract class _$$UniversalProductImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? itemClsCd(String? instance) => instance;
  // ignore: unused_element
  static Object? itemClsNm(String? instance) => instance;
  // ignore: unused_element
  static Object? itemClsLvl(int? instance) => instance;
  // ignore: unused_element
  static Object? taxTyCd(String? instance) => instance;
  // ignore: unused_element
  static Object? mjrTgYn(String? instance) => instance;
  // ignore: unused_element
  static Object? useYn(String? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
}

Map<String, dynamic> _$$UniversalProductImplToJson(
        _$UniversalProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemClsCd': instance.itemClsCd,
      'itemClsNm': instance.itemClsNm,
      'itemClsLvl': instance.itemClsLvl,
      'taxTyCd': instance.taxTyCd,
      'mjrTgYn': instance.mjrTgYn,
      'useYn': instance.useYn,
      'businessId': instance.businessId,
      'branchId': instance.branchId,
    };
