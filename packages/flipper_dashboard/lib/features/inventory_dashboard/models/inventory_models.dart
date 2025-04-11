// Data Models for the Inventory Dashboard
class InventoryItem {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final DateTime expiryDate;
  final String location;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.expiryDate,
    required this.location,
  });
}

class ReorderHistory {
  final String id;
  final String itemName;
  final int quantity;
  final DateTime date;
  final OrderStatus status;

  ReorderHistory({
    required this.id,
    required this.itemName,
    required this.quantity,
    required this.date,
    required this.status,
  });
}

enum OrderStatus {
  delivered,
  inTransit,
  processing,
  cancelled,
}
