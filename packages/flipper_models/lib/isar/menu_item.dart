library flipper_models;

class MenuItem {
  MenuItem({this.id = 0, required this.variantId});

  int id;

  /// a product can not be added to menu only it's variant.
  /// both product and variation and stock should be synced online
  int variantId;
}
