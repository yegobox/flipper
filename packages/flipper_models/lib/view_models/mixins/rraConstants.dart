mixin RRADEFAULTS {
  /// code for itemTyCd
  /// TODO: when singup choose wheter is a service
  /// or business so we know the type we need to set for itemTyCd when saving
  /// variant or item in rra world.
  static const String service = "3";
  static const String rawMaterial = "1";
  static const String finishedProduct = "2";
  static const List<String> packagingUnits = [
    "AM: Ampoule Ampoule",
    "BA: Barrel Barrel",
    "BC: Bottlecrate Bottlecrate",
    "BE: Bundle Bundle",
    "BF: Balloon, non-protected Balloon, non-protected",
    "BG: Bag Bag",
    "BJ: Bucket Bucket",
    "BK: Basket Basket",
    "BL: Bale Bale",
    "BQ: Bottle, protected cylindrical Bottle, protected cylindrical",
    "BR: Bar Bar",
    "BV: Bottle, bulbous Bottle, bulbous",
    "BZ: Bag Bag",
    "CA: Can Can",
    "CH: Chest Chest",
    "CJ: Coffin Coffin",
    "CL: Coil Coil",
    "CR: Wooden Box, Wooden Case Wooden Box, Wooden Case",
  ];
}
