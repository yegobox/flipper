import 'package:json_annotation/json_annotation.dart';

import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:supabase_models/brick/models/all_models.dart' as;
import 'variant.dart';

part 'stock.g.dart';

@JsonSerializable()
@Collection<Stock>('stocks')
class Stock {
  final int? id;
  final int? tin;
  final String? bhfId;
  final int? branchId;
  final int? variantId;

  @JsonKey(defaultValue: 0.0)
  final double currentStock;

  @JsonKey(defaultValue: 0.0)
  final double lowStock;

  @JsonKey(defaultValue: true)
  final bool? canTrackingStock;

  @JsonKey(defaultValue: true)
  final bool? showLowStockAlert;

  final int? productId;
  final bool? active;

  // the value of stock is currentStock * retailPrice
  @JsonKey(defaultValue: 0.0)
  final double value;

  // RRA fields
  @JsonKey(defaultValue: 0.0)
  final double rsdQty;

  @JsonKey(defaultValue: 0.0)
  final double supplyPrice;

  @JsonKey(defaultValue: 0.0)
  final double retailPrice;

  final DateTime? lastTouched;
  final DateTime? deletedAt;

  /// Sync status fields
  /// because we can call EBM server to notify about new item saved into our stock
  /// and this operation might fail at time of us making the call and our software can work offline
  /// with no disturbing the operation, we added this field to help us know when to try to re-submit the data
  /// to EBM in case of failure
  @JsonKey(defaultValue: false)
  final bool ebmSynced;

  /// by default it is set to true because as soon we save in realm we auto-save in sqlite
  /// which means we don't need to re-sync, but when received
  @JsonKey(defaultValue: true)
  final bool cloudSynced;

  // Relationships
  final Variant? variant;
  final double? initialStock;

  const Stock({
    this.id,
    this.tin,
    this.bhfId,
    this.branchId,
    this.variantId,
    this.currentStock = 0.0,
    this.lowStock = 0.0,
    this.canTrackingStock = true,
    this.showLowStockAlert = true,
    this.productId,
    this.active,
    this.value = 0.0,
    this.rsdQty = 0.0,
    this.supplyPrice = 0.0,
    this.retailPrice = 0.0,
    this.lastTouched,
    this.deletedAt,
    this.ebmSynced = false,
    this.cloudSynced = true,
    this.variant,
    this.initialStock,
  });

  // Factory constructor to create a Stock from JSON
  factory Stock.fromJson(Map<String, dynamic> json) => _$StockFromJson(json);

  // Method to convert Stock to JSON
  Map<String, dynamic> toJson() => _$StockToJson(this);

  // Implement copyWith method for immutability
  Stock copyWith({
    int? id,
    int? tin,
    String? bhfId,
    int? branchId,
    int? variantId,
    double? currentStock,
    double? lowStock,
    bool? canTrackingStock,
    bool? showLowStockAlert,
    int? productId,
    bool? active,
    double? value,
    double? rsdQty,
    double? supplyPrice,
    double? retailPrice,
    DateTime? lastTouched,
    DateTime? deletedAt,
    bool? ebmSynced,
    bool? cloudSynced,
    Variant? variant,
    double? initialStock,
  }) {
    return Stock(
      id: id ?? this.id,
      tin: tin ?? this.tin,
      bhfId: bhfId ?? this.bhfId,
      branchId: branchId ?? this.branchId,
      variantId: variantId ?? this.variantId,
      currentStock: currentStock ?? this.currentStock,
      lowStock: lowStock ?? this.lowStock,
      canTrackingStock: canTrackingStock ?? this.canTrackingStock,
      showLowStockAlert: showLowStockAlert ?? this.showLowStockAlert,
      productId: productId ?? this.productId,
      active: active ?? this.active,
      value: value ?? this.value,
      rsdQty: rsdQty ?? this.rsdQty,
      supplyPrice: supplyPrice ?? this.supplyPrice,
      retailPrice: retailPrice ?? this.retailPrice,
      lastTouched: lastTouched ?? this.lastTouched,
      deletedAt: deletedAt ?? this.deletedAt,
      ebmSynced: ebmSynced ?? this.ebmSynced,
      cloudSynced: cloudSynced ?? this.cloudSynced,
      variant: variant ?? this.variant,
      initialStock: initialStock ?? this.initialStock,
    );
  }
}

/// Extension methods for Stock calculations and helpers
extension StockHelpers on Stock {
  /// Calculates the current value of stock based on currentStock and retailPrice
  double get calculateValue => currentStock * (retailPrice);

  /// Checks if stock is low
  bool get isLowStock => currentStock <= (lowStock);

  /// Checks if stock tracking is enabled
  bool get isStockTrackingEnabled => canTrackingStock ?? true;

  /// Checks if the stock has valid quantities
  bool get hasValidQuantities => currentStock >= 0 && lowStock >= 0;
}

final stocksRef = StockCollectionReference();
