class Item {
  final String barCode;
  String? bcdU;
  double? quantity;
  final String name;
  final String category;
  String price;

  Item({
    required this.barCode,
    required this.name,
    required this.category,
    required this.price,
    this.bcdU,
    this.quantity,
  });

  @override
  String toString() {
    return 'Item(barCode: $barCode, name: $name, category: $category, price: $price)';
  }
}
