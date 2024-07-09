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
