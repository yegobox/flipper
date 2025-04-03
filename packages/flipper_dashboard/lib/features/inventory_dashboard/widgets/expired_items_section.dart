import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/inventory_models.dart';

class ExpiredItemsSection extends StatelessWidget {
  const ExpiredItemsSection({
    Key? key,
    required this.expiredItems,
    required this.onDeleteItem,
    required this.onViewItemDetails,
  }) : super(key: key);

  final List<InventoryItem> expiredItems;
  final Function(InventoryItem) onDeleteItem;
  final Function(BuildContext, InventoryItem) onViewItemDetails;

  @override
  Widget build(BuildContext context) {
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
                  Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
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
                rows: expiredItems.map((item) {
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
                                onDeleteItem(item);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.visibility_outlined,
                                  size: 20),
                              onPressed: () {
                                onViewItemDetails(context, item);
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
              children: expiredItems.map((item) {
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
}
