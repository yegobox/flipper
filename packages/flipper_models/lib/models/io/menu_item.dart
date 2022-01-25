library flipper_models;

import 'package:objectbox/objectbox.dart';

@Entity()
class MenuItem {
  MenuItem({this.id = 0, required this.variantId});

  @Id(assignable: true)
  int id;

  /// a product can not be added to menu only it's variant.
  /// both product and variation and stock should be synced online
  int variantId;
}
