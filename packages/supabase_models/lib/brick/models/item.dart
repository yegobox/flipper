class Item {
  final String barCode;
  String name;
  String category;
  String price;
  String quantity;

  Item({
    required this.barCode,
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
  });

  @override
  String toString() {
    return 'Item(barCode: $barCode, name: $name, category: $category, price: $price, quantity: $quantity)';
  }
}
