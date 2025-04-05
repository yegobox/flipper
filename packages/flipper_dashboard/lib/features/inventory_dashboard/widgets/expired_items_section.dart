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
    // Calculate the available width for the table
    final availableWidth =
        MediaQuery.of(context).size.width - 64; // Full width minus padding

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero, // Remove default card margin
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and View All button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
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
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    minimumSize: const Size(80, 40),
                  ),
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
          // Table section - no horizontal scroll
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: SizedBox(
              width: availableWidth,
              child: DataTable(
                columnSpacing: 20,
                headingRowColor: WidgetStateProperty.all(
                  Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.3),
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
                      DataCell(Text(item.id.length > 5
                          ? item.id.substring(0, 5) + '...'
                          : item.id)),
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
          ),
        ],
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
              mainAxisSize: MainAxisSize.min,
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
