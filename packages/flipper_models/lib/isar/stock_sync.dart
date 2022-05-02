library flipper_models;

import 'package:isar/isar.dart';
part 'stock_sync.g.dart';

@Collection()
class Stock {
  late int id = Isar.autoIncrement;
  late int branchId;
  @Index()
  late int variantId;
  double? lowStock;

  late double currentStock;
  double? supplyPrice;
  double? retailPrice;
  bool? canTrackingStock;
  bool? showLowStockAlert;
  late int productId;
  bool? active;

  /// the value of stock is currentStock * retailPrice
  double? value;

  // RRA fields
  double? rsdQty;
}
