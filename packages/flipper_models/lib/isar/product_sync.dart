library flipper_models;

import 'package:flipper_models/isar/variant_sync.dart';
import 'package:isar/isar.dart';

part 'product_sync.g.dart';

@Collection()
class ProductSync {
  late int id = Isar.autoIncrement;
  late String name;
  late String picture;
  late String? description;
  late bool active;
  late String? ftaxId;
  late bool hasPicture;
  late String table;
  late String color;
  late int businessId;
  late int branchId;
  String? supplierId;
  String? fcategoryId;
  String? createdAt;
  late String unit;
  bool? draft;
  bool? imageLocal;
  bool? currentUpdate;
  String? imageUrl;
  String? expiryDate;
  String? barCode;
  bool? synced;
  @Backlink(to: 'stock')
  final variants = IsarLinks<VariantSync>();
}
