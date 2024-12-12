class Item {
  final String bcdU;
  final String barCode;
  final String name;
  final String category;
  final String price;
  final String quantity;

  Item({
    required this.bcdU,
    required this.barCode,
    required this.name,
    required this.category,
    required this.price,
    required this.quantity,
  });

  @override
  String toString() {
    return 'Item(barCode: $barCode, name: $name, category: $category, price: $price, quantity: $quantity,bcdU: $bcdU)';
  }
}
