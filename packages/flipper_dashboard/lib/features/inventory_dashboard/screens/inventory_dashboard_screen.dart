import 'package:flutter/material.dart';
import '../models/inventory_models.dart';
import '../widgets/summary_cards.dart';
import '../widgets/expired_items_section.dart';
import '../widgets/charts_section.dart';
import '../widgets/recent_orders_section.dart';
import '../widgets/near_expiry_section.dart';
import 'package:intl/intl.dart';

class InventoryDashboardScreen extends StatefulWidget {
  const InventoryDashboardScreen({Key? key}) : super(key: key);

  @override
  State<InventoryDashboardScreen> createState() => _InventoryDashboardScreenState();
}

class _InventoryDashboardScreenState extends State<InventoryDashboardScreen> {
  // Sample data for the dashboard
  final List<InventoryItem> _expiredItems = [
    InventoryItem(
      id: '001',
      name: 'Milk',
      category: 'Dairy',
      quantity: 15,
      expiryDate: DateTime.now().subtract(const Duration(days: 2)),
      location: 'Warehouse A',
    ),
    InventoryItem(
      id: '002',
      name: 'Yogurt',
      category: 'Dairy',
      quantity: 30,
      expiryDate: DateTime.now().subtract(const Duration(days: 1)),
      location: 'Warehouse A',
    ),
    InventoryItem(
      id: '003',
      name: 'Cheese',
      category: 'Dairy',
      quantity: 10,
      expiryDate: DateTime.now().subtract(const Duration(days: 3)),
      location: 'Warehouse B',
    ),
    InventoryItem(
      id: '004',
      name: 'Orange Juice',
      category: 'Beverages',
      quantity: 25,
      expiryDate: DateTime.now().subtract(const Duration(days: 5)),
      location: 'Warehouse C',
    ),
  ];

  final List<InventoryItem> _nearExpiryItems = [
    InventoryItem(
      id: '005',
      name: 'Bread',
      category: 'Bakery',
      quantity: 20,
      expiryDate: DateTime.now().add(const Duration(days: 2)),
      location: 'Warehouse B',
    ),
    InventoryItem(
      id: '006',
      name: 'Eggs',
      category: 'Dairy',
      quantity: 50,
      expiryDate: DateTime.now().add(const Duration(days: 3)),
      location: 'Warehouse A',
    ),
    InventoryItem(
      id: '007',
      name: 'Chicken',
      category: 'Meat',
      quantity: 15,
      expiryDate: DateTime.now().add(const Duration(days: 1)),
      location: 'Warehouse C',
    ),
  ];

  // Sample inventory levels by category
  final Map<String, int> _inventoryByCategory = {
    'Dairy': 325,
    'Bakery': 150,
    'Meat': 200,
    'Produce': 450,
    'Beverages': 275,
    'Frozen': 180,
  };

  // Sample reorder history
  final List<ReorderHistory> _reorderHistory = [
    ReorderHistory(
      id: '101',
      itemName: 'Milk',
      quantity: 100,
      date: DateTime.now().subtract(const Duration(days: 7)),
      status: OrderStatus.delivered,
    ),
    ReorderHistory(
      id: '102',
      itemName: 'Bread',
      quantity: 80,
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: OrderStatus.delivered,
    ),
    ReorderHistory(
      id: '103',
      itemName: 'Eggs',
      quantity: 200,
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: OrderStatus.inTransit,
    ),
    ReorderHistory(
      id: '104',
      itemName: 'Chicken',
      quantity: 50,
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: OrderStatus.processing,
    ),
  ];

  void _deleteItem(InventoryItem item) {
    setState(() {
      _expiredItems.remove(item);
    });
  }

  void _showItemDetailsDialog(BuildContext context, InventoryItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${item.id}'),
              Text('Category: ${item.category}'),
              Text('Quantity: ${item.quantity}'),
              Text('Location: ${item.location}'),
              Text(
                  'Expiry Date: ${DateFormat('MMM dd, yyyy').format(item.expiryDate)}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildDashboard(),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dashboard header with summary cards
            SummaryCards(expiredItemsCount: _expiredItems.length),
            const SizedBox(height: 24),

            // Expired items section
            ExpiredItemsSection(
              expiredItems: _expiredItems,
              onDeleteItem: _deleteItem,
              onViewItemDetails: _showItemDetailsDialog,
            ),
            const SizedBox(height: 24),

            // Charts section
            ChartsSection(inventoryByCategory: _inventoryByCategory),
            const SizedBox(height: 24),

            // Recent orders and near expiry items
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: RecentOrdersSection(reorderHistory: _reorderHistory),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: NearExpirySection(nearExpiryItems: _nearExpiryItems),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
