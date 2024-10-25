// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FavoriteImpl _$$FavoriteImplFromJson(Map<String, dynamic> json) =>
    _$FavoriteImpl(
      id: (json['id'] as num?)?.toInt(),
      favIndex: (json['favIndex'] as num?)?.toInt(),
      productId: (json['productId'] as num?)?.toInt(),
      branchId: (json['branchId'] as num?)?.toInt(),
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    );

const _$$FavoriteImplFieldMap = <String, String>{
  'id': 'id',
  'favIndex': 'favIndex',
  'productId': 'productId',
  'branchId': 'branchId',
  'lastTouched': 'lastTouched',
  'deletedAt': 'deletedAt',
};

// ignore: unused_element
abstract class _$$FavoriteImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? favIndex(int? instance) => instance;
  // ignore: unused_element
  static Object? productId(int? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
}

Map<String, dynamic> _$$FavoriteImplToJson(_$FavoriteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'favIndex': instance.favIndex,
      'productId': instance.productId,
      'branchId': instance.branchId,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
