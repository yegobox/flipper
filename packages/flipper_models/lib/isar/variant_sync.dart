library flipper_models;

import 'package:isar/isar.dart';
part 'variant_sync.g.dart';

@Collection()
class VariantSync {
  late int id = Isar.autoIncrement;
  late String name;
  String? sku;
  late int productId;
  late String unit;
  String? table;
  late String productName;
  late int branchId;
  String? taxName;
  double? taxPercentage;
  late double supplyPrice;
  late double retailPrice;
  bool? synced;
  // final stock = IsarLink<StockSync>();
}
