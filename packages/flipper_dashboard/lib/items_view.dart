import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class InventoryDashboardApp extends StatelessWidget {
  const InventoryDashboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the parent context's theme instead of defining a new one
    return const Material(
      child: InventoryDashboard(),
    );
  }
}

class InventoryDashboard extends StatefulWidget {
  const InventoryDashboard({Key? key}) : super(key: key);

  @override
  State<InventoryDashboard> createState() => _InventoryDashboardState();
}

class _InventoryDashboardState extends State<InventoryDashboard> {
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
            _buildSummaryCards(),
            const SizedBox(height: 24),

            // Expired items section
            _buildExpiredItemsSection(),
            const SizedBox(height: 24),

            // Charts section
            _buildChartsSection(),
            const SizedBox(height: 24),

            // Recent orders and near expiry items
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildRecentOrdersSection(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildNearExpirySection(),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 1100 ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard(
          title: 'Total Items',
          value: '1,580',
          icon: Icons.inventory,
          color: Colors.blue,
          trend: '+5.8%',
          isPositive: true,
        ),
        _buildSummaryCard(
          title: 'Expired Items',
          value: '${_expiredItems.length}',
          icon: Icons.warning_amber,
          color: Colors.red,
          trend: '+2',
          isPositive: false,
        ),
        _buildSummaryCard(
          title: 'Low Stock Items',
          value: '21',
          icon: Icons.trending_down,
          color: Colors.orange,
          trend: '-3',
          isPositive: true,
        ),
        _buildSummaryCard(
          title: 'Pending Orders',
          value: '12',
          icon: Icons.shopping_cart,
          color: Colors.green,
          trend: '+4',
          isPositive: true,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
    required bool isPositive,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                  color: isPositive
                      ? title == 'Expired Items'
                          ? Colors.red
                          : Colors.green
                      : title == 'Expired Items'
                          ? Colors.green
                          : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  trend,
                  style: TextStyle(
                    fontSize: 12,
                    color: isPositive
                        ? title == 'Expired Items'
                            ? Colors.red
                            : Colors.green
                        : title == 'Expired Items'
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'from last week',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiredItemsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Expired Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Handle view all
                    _showExpiredItemsDialog(context);
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                headingRowColor: WidgetStateProperty.all(
                  Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withOpacity(0.3),
                ),
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Item')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Location')),
                  DataColumn(label: Text('Expired On')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _expiredItems.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(Text(item.id)),
                      DataCell(Text(item.name)),
                      DataCell(Text(item.category)),
                      DataCell(Text(item.quantity.toString())),
                      DataCell(Text(item.location)),
                      DataCell(
                        Text(
                          DateFormat('MMM dd, yyyy').format(item.expiryDate),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20),
                              onPressed: () {
                                // Handle delete action
                                _deleteItem(item);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined,
                                  size: 20),
                              onPressed: () {
                                // Handle view action
                                _showItemDetailsDialog(context, item);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExpiredItemsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('All Expired Items'),
          content: SingleChildScrollView(
            child: Column(
              children: _expiredItems.map((item) {
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                      'Expired on: ${DateFormat('MMM dd, yyyy').format(item.expiryDate)}'),
                );
              }).toList(),
            ),
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

  void _deleteItem(InventoryItem item) {
    setState(() {
      _expiredItems.remove(item);
    });
  }

  Widget _buildChartsSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Inventory by Category',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: _createPieChartSections(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _buildLegendItem('Dairy', Colors.blue),
                      _buildLegendItem('Bakery', Colors.red),
                      _buildLegendItem('Meat', Colors.amber),
                      _buildLegendItem('Produce', Colors.green),
                      _buildLegendItem('Beverages', Colors.purple),
                      _buildLegendItem('Frozen', Colors.teal),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Stock Levels Trend',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const titles = [
                                  'Jan',
                                  'Feb',
                                  'Mar',
                                  'Apr',
                                  'May',
                                  'Jun'
                                ];
                                final int index = value.toInt();
                                if (index >= 0 && index < titles.length) {
                                  return Text(titles[index]);
                                }
                                return const Text('');
                              },
                              reservedSize: 22,
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.blue.withOpacity(0.2),
                            ),
                            spots: const [
                              FlSpot(0, 300),
                              FlSpot(1, 350),
                              FlSpot(2, 290),
                              FlSpot(3, 320),
                              FlSpot(4, 370),
                              FlSpot(5, 400),
                            ],
                          ),
                          LineChartBarData(
                            isCurved: true,
                            color: Colors.red,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.red.withOpacity(0.2),
                            ),
                            spots: const [
                              FlSpot(0, 200),
                              FlSpot(1, 230),
                              FlSpot(2, 210),
                              FlSpot(3, 240),
                              FlSpot(4, 250),
                              FlSpot(5, 270),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _buildLegendItem('Dairy Products', Colors.blue),
                      _buildLegendItem('Meat Products', Colors.red),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _createPieChartSections() {
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.amber,
      Colors.green,
      Colors.purple,
      Colors.teal,
    ];

    int i = 0;
    return _inventoryByCategory.entries.map((entry) {
      final double value = entry.value.toDouble();
      final double total = _inventoryByCategory.values
          .fold(0, (sum, value) => sum + value)
          .toDouble();
      final double percentage = value / total * 100;

      return PieChartSectionData(
        color: colors[i++ % colors.length],
        value: value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildRecentOrdersSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Orders',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _reorderHistory.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final order = _reorderHistory[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        _getStatusColor(order.status).withOpacity(0.2),
                    child: Icon(
                      _getStatusIcon(order.status),
                      color: _getStatusColor(order.status),
                    ),
                  ),
                  title: Text(order.itemName),
                  subtitle: Text(
                    'Order #${order.id} - ${DateFormat('MMM dd, yyyy').format(order.date)}',
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getStatusText(order.status),
                      style: TextStyle(
                        color: _getStatusColor(order.status),
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearExpirySection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Near Expiry Items',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _nearExpiryItems.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = _nearExpiryItems[index];
                final daysLeft =
                    item.expiryDate.difference(DateTime.now()).inDays;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getExpiryColor(daysLeft).withOpacity(0.2),
                    child: Icon(
                      Icons.timelapse,
                      color: _getExpiryColor(daysLeft),
                    ),
                  ),
                  title: Text(item.name),
                  subtitle: Text(
                    '${item.quantity} units - ${item.location}',
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getExpiryColor(daysLeft).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$daysLeft days left',
                      style: TextStyle(
                        color: _getExpiryColor(daysLeft),
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.inTransit:
        return Colors.blue;
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return Icons.check_circle_outline;
      case OrderStatus.inTransit:
        return Icons.local_shipping_outlined;
      case OrderStatus.processing:
        return Icons.pending_outlined;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.inTransit:
        return 'In Transit';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _getExpiryColor(int daysLeft) {
    if (daysLeft <= 1) {
      return Colors.red;
    } else if (daysLeft <= 3) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}

// Data Models
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
