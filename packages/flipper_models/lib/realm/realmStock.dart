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

  // ... constructors and other methods remain the same
}