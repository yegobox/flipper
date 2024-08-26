// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Favorite _$FavoriteFromJson(Map<String, dynamic> json) => Favorite(
      favIndex: json['favIndex'] as int?,
      productId: json['productId'] as int?,
      branchId: json['branchId'] as int?,
      action: json['action'] as String,
    )
      ..id = json['id'] as int?
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String)
      ..deletedAt = json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String);

Map<String, dynamic> _$FavoriteToJson(Favorite instance) => <String, dynamic>{
      'id': instance.id,
      'favIndex': instance.favIndex,
      'productId': instance.productId,
      'branchId': instance.branchId,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'action': instance.action,
      'deletedAt': instance.deletedAt?.toIso8601String(),
    };
