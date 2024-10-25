// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IStock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IStock _$IStockFromJson(Map<String, dynamic> json) => IStock(
      id: (json['id'] as num?)?.toInt(),
      tin: (json['tin'] as num?)?.toInt(),
      bhfId: json['bhfId'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
      variantId: (json['variantId'] as num?)?.toInt(),
      lowStock: (json['lowStock'] as num?)?.toDouble() ?? 0,
      currentStock: (json['currentStock'] as num?)?.toDouble() ?? 0.0,
      canTrackingStock: json['canTrackingStock'] as bool? ?? true,
      showLowStockAlert: json['showLowStockAlert'] as bool? ?? true,
      productId: (json['productId'] as num?)?.toInt(),
      active: json['active'] as bool?,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      rsdQty: (json['rsdQty'] as num?)?.toDouble() ?? 0.0,
      supplyPrice: (json['supplyPrice'] as num?)?.toDouble() ?? 0.0,
      retailPrice: (json['retailPrice'] as num?)?.toDouble() ?? 0.0,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      action: json['action'] as String?,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      ebmSynced: json['ebmSynced'] as bool? ?? false,
    );

Map<String, dynamic> _$IStockToJson(IStock instance) => <String, dynamic>{
      'id': instance.id,
      'tin': instance.tin,
      'bhfId': instance.bhfId,
      'branchId': instance.branchId,
      'variantId': instance.variantId,
      'lowStock': instance.lowStock,
      'currentStock': instance.currentStock,
      'canTrackingStock': instance.canTrackingStock,
      'showLowStockAlert': instance.showLowStockAlert,
      'productId': instance.productId,
      'active': instance.active,
      'value': instance.value,
      'rsdQty': instance.rsdQty,
      'supplyPrice': instance.supplyPrice,
      'retailPrice': instance.retailPrice,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'action': instance.action,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'ebmSynced': instance.ebmSynced,
    };
