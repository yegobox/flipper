library flipper_models;

class MenuItem {
  MenuItem({required this.id, required this.variantId});

  late String id;

  /// a product can not be added to menu only it's variant.
  /// both product and variation and stock should be synced online
  int variantId;
}
