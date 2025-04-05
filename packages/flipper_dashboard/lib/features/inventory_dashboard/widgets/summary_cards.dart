import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_models/providers/inventory_provider.dart';

class SummaryCards extends ConsumerWidget {
  const SummaryCards({
    Key? key,
    required this.expiredItemsCount,
  }) : super(key: key);

  final int expiredItemsCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 1100 ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        // Total Items card with real data
        ref.watch(totalItemsProvider).when(
              data: (totalItemsData) {
                return _buildSummaryCard(
                  context: context,
                  title: 'Total Items',
                  value: totalItemsData.formattedCount,
                  icon: Icons.inventory,
                  color: Colors.blue,
                  trend:
                      '${totalItemsData.isPositive ? "+" : "-"}${totalItemsData.trendPercentage.abs().toStringAsFixed(1)}%',
                  isPositive: totalItemsData.isPositive,
                  isEstimate: totalItemsData.isEstimateUsed,
                );
              },
              loading: () => _buildSummaryCard(
                context: context,
                title: 'Total Items',
                value: '...',
                icon: Icons.inventory,
                color: Colors.blue,
                trend: '0.0%',
                isPositive: true,
                isEstimate: true,
              ),
              error: (_, __) => _buildSummaryCard(
                context: context,
                title: 'Total Items',
                value: '0',
                icon: Icons.inventory,
                color: Colors.blue,
                trend: '0.0%',
                isPositive: true,
                isEstimate: true,
              ),
            ),
        // Expired Items card with real data
        ref.watch(expiredItemsProvider(const ExpiredItemsParams())).when(
              data: (expiredItems) {
                // Calculate trend - in a real implementation, you would track this over time
                final currentCount = expiredItems.length;
                final previousCount = expiredItemsCount;
                double trendPercentage = 0.0;
                bool isPositive = false;

                if (previousCount > 0) {
                  final difference = currentCount - previousCount;
                  trendPercentage = (difference / previousCount) * 100;
                  // For expired items, a decrease is positive (fewer expired items is good)
                  isPositive = difference < 0;
                }

                return _buildSummaryCard(
                  context: context,
                  title: 'Expired Items',
                  value: '$currentCount',
                  icon: Icons.warning_amber,
                  color: Colors.red,
                  trend:
                      '${isPositive ? "+" : "-"}${trendPercentage.abs().toStringAsFixed(1)}%',
                  isPositive: isPositive,
                  isEstimate:
                      true, // We're estimating the trend based on previous count
                );
              },
              loading: () => _buildSummaryCard(
                context: context,
                title: 'Expired Items',
                value: '...',
                icon: Icons.warning_amber,
                color: Colors.red,
                trend: '0.0%',
                isPositive: false,
                isEstimate: true,
              ),
              error: (_, __) => _buildSummaryCard(
                context: context,
                title: 'Expired Items',
                value: '$expiredItemsCount',
                icon: Icons.warning_amber,
                color: Colors.red,
                trend: '0.0%',
                isPositive: false,
                isEstimate: true,
              ),
            ),
        // Low Stock Items card with real data
        ref.watch(lowStockItemsProvider).when(
              data: (lowStockData) {
                return _buildSummaryCard(
                  context: context,
                  title: 'Low Stock Items',
                  value: lowStockData.formattedCount,
                  icon: Icons.trending_down,
                  color: Colors.orange,
                  trend:
                      '${lowStockData.isPositive ? "+" : "-"}${lowStockData.trendPercentage.abs().toStringAsFixed(1)}%',
                  isPositive: lowStockData.isPositive,
                  isEstimate: lowStockData.isEstimateUsed,
                );
              },
              loading: () => _buildSummaryCard(
                context: context,
                title: 'Low Stock Items',
                value: '...',
                icon: Icons.trending_down,
                color: Colors.orange,
                trend: '0.0%',
                isPositive: true,
                isEstimate: true,
              ),
              error: (_, __) => _buildSummaryCard(
                context: context,
                title: 'Low Stock Items',
                value: '0',
                icon: Icons.trending_down,
                color: Colors.orange,
                trend: '0.0%',
                isPositive: true,
                isEstimate: true,
              ),
            ),
        // Pending Orders card with real data
        ref.watch(pendingOrdersProvider).when(
              data: (pendingOrdersData) {
                return _buildSummaryCard(
                  context: context,
                  title: 'Pending Orders',
                  value: pendingOrdersData.formattedCount,
                  icon: Icons.shopping_cart,
                  color: Colors.green,
                  trend:
                      '${pendingOrdersData.isPositive ? "+" : "-"}${pendingOrdersData.trendPercentage.abs().toStringAsFixed(1)}%',
                  isPositive: pendingOrdersData.isPositive,
                  isEstimate: pendingOrdersData.isEstimateUsed,
                );
              },
              loading: () => _buildSummaryCard(
                context: context,
                title: 'Pending Orders',
                value: '...',
                icon: Icons.shopping_cart,
                color: Colors.green,
                trend: '0.0%',
                isPositive: true,
                isEstimate: true,
              ),
              error: (_, __) => _buildSummaryCard(
                context: context,
                title: 'Pending Orders',
                value: '0',
                icon: Icons.shopping_cart,
                color: Colors.green,
                trend: '0.0%',
                isPositive: true,
                isEstimate: true,
              ),
            ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String trend,
    required bool isPositive,
    bool isEstimate = false,
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
                if (isEstimate) ...[
                  const SizedBox(width: 4),
                  Tooltip(
                    message: 'This trend is based on an estimate',
                    child: Icon(
                      Icons.info_outline,
                      size: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
