// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockImpl _$$StockImplFromJson(Map<String, dynamic> json) => _$StockImpl(
      id: (json['id'] as num?)?.toInt(),
      tin: (json['tin'] as num?)?.toInt(),
      bhfId: json['bhfId'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
      variantId: (json['variantId'] as num?)?.toInt(),
      currentStock: (json['currentStock'] as num?)?.toDouble() ?? 0.0,
      lowStock: (json['lowStock'] as num?)?.toDouble() ?? 0.0,
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
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      ebmSynced: json['ebmSynced'] as bool? ?? false,
      cloudSynced: json['cloudSynced'] as bool? ?? true,
      variant: json['variant'] == null
          ? null
          : Variant.fromJson(json['variant'] as Map<String, dynamic>),
      initialStock: (json['initialStock'] as num?)?.toDouble(),
    );

const _$$StockImplFieldMap = <String, String>{
  'id': 'id',
  'tin': 'tin',
  'bhfId': 'bhfId',
  'branchId': 'branchId',
  'variantId': 'variantId',
  'currentStock': 'currentStock',
  'lowStock': 'lowStock',
  'canTrackingStock': 'canTrackingStock',
  'showLowStockAlert': 'showLowStockAlert',
  'productId': 'productId',
  'active': 'active',
  'value': 'value',
  'rsdQty': 'rsdQty',
  'supplyPrice': 'supplyPrice',
  'retailPrice': 'retailPrice',
  'lastTouched': 'lastTouched',
  'deletedAt': 'deletedAt',
  'ebmSynced': 'ebmSynced',
  'cloudSynced': 'cloudSynced',
  'variant': 'variant',
  'initialStock': 'initialStock',
};

// ignore: unused_element
abstract class _$$StockImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? tin(int? instance) => instance;
  // ignore: unused_element
  static Object? bhfId(String? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? variantId(int? instance) => instance;
  // ignore: unused_element
  static Object? currentStock(double instance) => instance;
  // ignore: unused_element
  static Object? lowStock(double instance) => instance;
  // ignore: unused_element
  static Object? canTrackingStock(bool? instance) => instance;
  // ignore: unused_element
  static Object? showLowStockAlert(bool? instance) => instance;
  // ignore: unused_element
  static Object? productId(int? instance) => instance;
  // ignore: unused_element
  static Object? active(bool? instance) => instance;
  // ignore: unused_element
  static Object? value(double instance) => instance;
  // ignore: unused_element
  static Object? rsdQty(double instance) => instance;
  // ignore: unused_element
  static Object? supplyPrice(double instance) => instance;
  // ignore: unused_element
  static Object? retailPrice(double instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? ebmSynced(bool instance) => instance;
  // ignore: unused_element
  static Object? cloudSynced(bool instance) => instance;
  // ignore: unused_element
  static Object? variant(Variant? instance) => instance;
  // ignore: unused_element
  static Object? initialStock(double? instance) => instance;
}

Map<String, dynamic> _$$StockImplToJson(_$StockImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tin': instance.tin,
      'bhfId': instance.bhfId,
      'branchId': instance.branchId,
      'variantId': instance.variantId,
      'currentStock': instance.currentStock,
      'lowStock': instance.lowStock,
      'canTrackingStock': instance.canTrackingStock,
      'showLowStockAlert': instance.showLowStockAlert,
      'productId': instance.productId,
      'active': instance.active,
      'value': instance.value,
      'rsdQty': instance.rsdQty,
      'supplyPrice': instance.supplyPrice,
      'retailPrice': instance.retailPrice,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'ebmSynced': instance.ebmSynced,
      'cloudSynced': instance.cloudSynced,
      'variant': instance.variant,
      'initialStock': instance.initialStock,
    };