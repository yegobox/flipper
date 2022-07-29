library flipper_models;

import 'package:flipper_models/isar/variant.dart';
import 'package:isar/isar.dart';

part 'product.g.dart';

@Collection()
class Product {
  Id id = Isar.autoIncrement;
  @Index(caseSensitive: true)
  late String name;
  String? picture;
  String? description;
  late bool active;
  String? taxId;
  late bool hasPicture;
  String? table;
  late String color;
  late int businessId;
  @Index()
  late int branchId;
  String? supplierId;
  String? categoryId;
  String? createdAt;
  String? unit;
  @Index(composite: [CompositeIndex('branchId')])
  bool? draft;
  bool? imageLocal;
  bool? currentUpdate;
  String? imageUrl;
  String? expiryDate;
  @Index()
  String? barCode;
  bool? synced;
  final variants = IsarLinks<Variant>();
}
