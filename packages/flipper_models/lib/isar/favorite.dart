library flipper_models;

import 'package:isar/isar.dart';

part 'favorite.g.dart';

@collection
class Favorite {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  int? favIndex;

  int? productId;

  Favorite(this.favIndex, this.productId);
}
