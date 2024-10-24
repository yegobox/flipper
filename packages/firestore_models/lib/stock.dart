import 'package:freezed_annotation/freezed_annotation.dart';

// Import the Variant class
import 'variant.dart';

part 'stock.freezed.dart';
part 'stock.g.dart';

@freezed
class Stock with _$Stock {
  const factory Stock({
    int? id,
    int? tin,
    String? bhfId,
    int? branchId,
    int? variantId,
    @Default(0.0) double currentStock,
    @Default(0.0) double lowStock,
    @Default(true) bool? canTrackingStock,
    @Default(true) bool? showLowStockAlert,
    int? productId,
    bool? active,
    // the value of stock is currentStock * retailPrice
    @Default(0.0) double value,
    
    // RRA fields
    @Default(0.0) double rsdQty,
    @Default(0.0) double supplyPrice,
    @Default(0.0) double retailPrice,
    
    DateTime? lastTouched,
    DateTime? deletedAt,
    
    /// Sync status fields
    /// because we can call EBM server to notify about new item saved into our stock
    /// and this operation might fail at time of us making the call and our software can work offline
    /// with no disturbing the operation, we added this field to help us know when to try to re-submit the data
    /// to EBM in case of failure
    @Default(false) bool ebmSynced,
    
    /// by default it is set to true because as soon we save in realm we auto-save in sqlite
    /// which means we don't need to re-sync, but when received
    @Default(true) bool cloudSynced,
    
    // Relationships
    Variant? variant,
    double? initialStock,
  }) = _Stock;

  factory Stock.fromJson(Map<String, dynamic> json) => 
      _$StockFromJson(json);
      
  /// Create a custom constructor for easy initialization with computed value
  const Stock._();  // This is needed for custom getters
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