library flipper_models;

import 'package:flipper_models/isar/stock_sync.dart';
import 'package:isar/isar.dart';
part 'variant_sync.g.dart';

@Collection()
class VariantSync {
  late int id = Isar.autoIncrement;
  late String name;
  late String sku;
  late int productId;
  late String unit;
  late String table;
  late String productName;
  late int branchId;
  late String? taxName;
  late double? taxPercentage;
  late double supplyPrice;
  late double retailPrice;
  late bool? synced;
  final stock = IsarLink<StockSync>();
}
