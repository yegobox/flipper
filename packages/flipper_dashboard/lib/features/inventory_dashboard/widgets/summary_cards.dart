import 'package:flutter/material.dart';

class SummaryCards extends StatelessWidget {
  const SummaryCards({
    Key? key,
    required this.expiredItemsCount,
  }) : super(key: key);

  final int expiredItemsCount;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 1100 ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard(
          context: context,
          title: 'Total Items',
          value: '1,580',
          icon: Icons.inventory,
          color: Colors.blue,
          trend: '+5.8%',
          isPositive: true,
        ),
        _buildSummaryCard(
          context: context,
          title: 'Expired Items',
          value: '$expiredItemsCount',
          icon: Icons.warning_amber,
          color: Colors.red,
          trend: '+2',
          isPositive: false,
        ),
        _buildSummaryCard(
          context: context,
          title: 'Low Stock Items',
          value: '21',
          icon: Icons.trending_down,
          color: Colors.orange,
          trend: '-3',
          isPositive: true,
        ),
        _buildSummaryCard(
          context: context,
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
    required BuildContext context,
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
}
