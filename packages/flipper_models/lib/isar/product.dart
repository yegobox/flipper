library flipper_models;

import 'package:flipper_models/isar/variant.dart';
import 'package:isar/isar.dart';

part 'product.g.dart';

@Collection()
class Product {
  late int id = Isar.autoIncrement;
  late String name;
  String? picture;
  String? description;
  late bool active;
  String? taxId;
  late bool hasPicture;
  String? table;
  late String color;
  late int businessId;
  late int branchId;
  String? supplierId;
  String? categoryId;
  String? createdAt;
  String? unit;
  bool? draft;
  bool? imageLocal;
  bool? currentUpdate;
  String? imageUrl;
  String? expiryDate;
  String? barCode;
  bool? synced;
  final variants = IsarLinks<Variant>();
}
