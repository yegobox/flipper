import 'package:realm/realm.dart';

part 'realmStock.g.dart'; // Generated by Realm

@RealmModel()
class _RealmStock {
  late String id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;

  late int branchId;

  late String variantId;
  double? lowStock;
  late double currentStock;

  bool? canTrackingStock;
  bool? showLowStockAlert;

  late String productId;

  bool? active;
  double? value;

  // RRA fields
  double? rsdQty;

  double? supplyPrice;
  double? retailPrice;

  DateTime? lastTouched;

  late String action;

  DateTime? deletedAt;

  bool ebmSynced = false;

  // ... constructors and other methods remain the same
  void updateProperties(RealmStock other) {
    id = other.id;
    branchId = other.branchId;
    variantId = other.variantId;
    lowStock = other.lowStock;
    currentStock = other.currentStock;
    canTrackingStock = other.canTrackingStock;
    showLowStockAlert = other.showLowStockAlert;
    productId = other.productId;
    active = other.active;
    value = other.value;
    rsdQty = other.rsdQty;
    supplyPrice = other.supplyPrice;
    retailPrice = other.retailPrice;
    lastTouched = other.lastTouched;
    action = other.action;
    deletedAt = other.deletedAt;
  }
}
