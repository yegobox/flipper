// To parse this JSON data, do
//
//     final stock = stockFromJson(jsonString);
library flipper_models;

import 'package:isar/isar.dart';
part 'stock_sync.g.dart';

@Collection()
class StockSync {
  late int id = Isar.autoIncrement;
  late int? branchId;
  late int variantId;
  double? lowStock;
  late double currentStock;
  double? supplyPrice;
  double? retailPrice;
  bool? canTrackingStock;
  bool? showLowStockAlert;
  String? table;
  late int productId;
  late bool? active;
  double? value;
}
