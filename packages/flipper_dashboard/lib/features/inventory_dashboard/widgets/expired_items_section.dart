import 'package:flipper_localize/flipper_localize.dart';
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
    final l10n = context.flipperL10n;
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
                Text(
                  l10n.inventoryDashboardExpiredItems,
                  style: const TextStyle(
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
                  child: Text(l10n.inventoryDashboardViewAll),
                ),
              ],
            ),
          ),
          // Table section - with horizontal scroll
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                headingRowColor: WidgetStateProperty.all(
                  Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                ),
                columns: [
                  DataColumn(label: Text(l10n.idLabel)),
                  DataColumn(label: Text(l10n.item)),
                  DataColumn(label: Text(l10n.category)),
                  DataColumn(label: Text(l10n.quantity)),
                  DataColumn(label: Text(l10n.location)),
                  DataColumn(label: Text(l10n.inventoryDashboardExpiredOn)),
                  DataColumn(label: Text(l10n.actions)),
                ],
                rows: expiredItems.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          item.id.length > 5
                              ? item.id.substring(0, 5) + '...'
                              : item.id,
                        ),
                      ),
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
                              icon: const Icon(
                                Icons.visibility_outlined,
                                size: 20,
                              ),
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
          title: Text(context.flipperL10n.inventoryDashboardAllExpiredItems),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: expiredItems.map((item) {
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                    context.flipperL10n.inventoryDashboardExpiredOnDate(
                      DateFormat('MMM dd, yyyy').format(item.expiryDate),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(context.flipperL10n.close),
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
