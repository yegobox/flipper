import 'package:flipper_dashboard/features/inventory_dashboard/models/inventory_models.dart';
import 'package:flipper_dashboard/features/inventory_dashboard/widgets/expired_items_section.dart';
import 'package:flipper_models/providers/inventory_provider.dart';
import 'package:flutter/material.dart';
import '../widgets/near_expiry_section.dart';
import '../widgets/summary_cards.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/recent_orders_section.dart';
import 'package:intl/intl.dart';

class InventoryDashboardScreen extends ConsumerStatefulWidget {
  const InventoryDashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<InventoryDashboardScreen> createState() =>
      _InventoryDashboardScreenState();
}

class _InventoryDashboardScreenState
    extends ConsumerState<InventoryDashboardScreen> {
  // Configuration for inventory data

  // No configuration needed as we're using default parameters

  // No sample data needed as we're using real data from the service

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
    // In a real implementation, this would call a service to delete the item
    // and then refresh the provider
    // Refresh the expired items list
    // Using discard to explicitly ignore the result as we don't need to wait for it
    final _ = ref.refresh(expiredItemsProvider(const ExpiredItemsParams()));
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
            Consumer(
              builder: (context, ref, child) {
                final expiredItemsAsync =
                    ref.watch(expiredItemsProvider(const ExpiredItemsParams()));

                return expiredItemsAsync.when(
                  data: (expiredItems) => SummaryCards(
                    expiredItemsCount: expiredItems.length,
                  ),
                  loading: () => SummaryCards(expiredItemsCount: 0),
                  error: (_, __) => SummaryCards(expiredItemsCount: 0),
                );
              },
            ),
            const SizedBox(height: 24),

            // Expired items and Near Expiry items in a row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expired items section
                Expanded(
                  flex: 3,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 700, // Minimum width to ensure readability
                    ),
                    child: Consumer(
                      builder: (context, ref, child) {
                        // Using default parameters since custom parameters cause loading issues
                        final expiredItemsAsync = ref.watch(
                            expiredItemsProvider(const ExpiredItemsParams()));

                        return expiredItemsAsync.when(
                          data: (expiredItems) => ExpiredItemsSection(
                            expiredItems: expiredItems,
                            onDeleteItem: _deleteItem,
                            onViewItemDetails: _showItemDetailsDialog,
                          ),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, stackTrace) => Center(
                            child: Text('Error loading expired items: $error'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Near expiry items section
                Expanded(
                  flex: 2,
                  child: Consumer(
                    builder: (context, ref, child) {
                      // Using default parameters since custom parameters cause loading issues
                      final nearExpiryItemsAsync =
                          ref.watch(nearExpiryItemsProvider(
                        const NearExpiryItemsParams(),
                      ));

                      return nearExpiryItemsAsync.when(
                        data: (nearExpiryItems) => NearExpirySection(
                          nearExpiryItems: nearExpiryItems,
                        ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) => Center(
                          child:
                              Text('Error loading near expiry items: $error'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Charts section
            // Charts section would go here if implemented
            const SizedBox(height: 24),

            // Recent orders section
            //TODO: implement this soon.
            // RecentOrdersSection(reorderHistory: _reorderHistory),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
