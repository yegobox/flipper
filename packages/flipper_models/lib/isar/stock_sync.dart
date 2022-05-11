library flipper_models;

import 'package:isar/isar.dart';
part 'stock_sync.g.dart';

@Collection()
class Stock {
  late int id = Isar.autoIncrement;
  @Index()
  late int branchId;
  @Index(composite: [CompositeIndex('branchId')])
  late int variantId;
  double? lowStock;

  late double currentStock;
  double? supplyPrice;
  double? retailPrice;
  bool? canTrackingStock;
  bool? showLowStockAlert;
  @Index()
  late int productId;
  bool? active;

  /// the value of stock is currentStock * retailPrice
  double? value;

  // RRA fields
  double? rsdQty;
}
