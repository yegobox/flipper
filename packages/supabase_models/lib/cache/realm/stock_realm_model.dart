import 'package:realm/realm.dart';

part 'stock_realm_model.realm.dart';

/// Realm model for Stock objects
/// This is used for caching Stock data
@RealmModel()
class _StockRealm {
  @PrimaryKey()
  late String id; // Primary key, using the same id as the Stock model

  int? tin;
  String? bhfId;
  int? branchId;
  double? currentStock;
  double? lowStock;
  bool? canTrackingStock;
  bool? showLowStockAlert;
  bool? active;
  double? value;
  double? rsdQty;
  String? lastTouched; // Store as ISO8601 string
  bool? ebmSynced;
  double? initialStock;

  // Add a field to associate with variant
  String? variantId;
}
