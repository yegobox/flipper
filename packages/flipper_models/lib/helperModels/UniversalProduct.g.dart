// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UniversalProduct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UniversalProduct _$UniversalProductFromJson(Map<String, dynamic> json) =>
    UniversalProduct(
      itemClsCd: json['itemClsCd'] as String?,
      itemClsNm: json['itemClsNm'] as String?,
      itemClsLvl: (json['itemClsLvl'] as num?)?.toInt(),
      mjrTgYn: json['mjrTgYn'] as String?,
      useYn: json['useYn'] as String?,
    )
      ..taxTyCd = json['taxTyCd'] as String?
      ..businessId = (json['businessId'] as num?)?.toInt()
      ..branchId = (json['branchId'] as num?)?.toInt();

const _$UniversalProductFieldMap = <String, String>{
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
abstract class _$UniversalProductPerFieldToJson {
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

Map<String, dynamic> _$UniversalProductToJson(UniversalProduct instance) =>
    <String, dynamic>{
      'itemClsCd': instance.itemClsCd,
      'itemClsNm': instance.itemClsNm,
      'itemClsLvl': instance.itemClsLvl,
      'taxTyCd': instance.taxTyCd,
      'mjrTgYn': instance.mjrTgYn,
      'useYn': instance.useYn,
      'businessId': instance.businessId,
      'branchId': instance.branchId,
    };
