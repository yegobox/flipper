library flipper_models;

import 'package:isar/isar.dart';

import 'package:flipper_models/isar/product.dart';
part 'favorite.g.dart';

@collection
class Favorite {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int? favIndex;

  final product = IsarLink<Product>();
}
